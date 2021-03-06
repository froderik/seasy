$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'seasy'

include Seasy

describe Index do
  before :each do
    subject.clear
    configure do |config|
      config.storage = InMemoryStorage
    end
  end

  it "should default and have some basic behaviour" do
    i = subject
    target_one = "1"
    target_two = "2"
    i.add 'fredrik den store', target_one
    i.search( "red" ).should == {target_one => 1}
    i.add 'red red wine', target_two
    i.search( "red").should == {target_two => 2 ,target_one => 1}
    i.search( "RED").should == {target_two => 2 ,target_one => 1}
    i.search( "e" ).should == {target_one => 3, target_two => 3}
  end

  it "should be possible to add complex strings twice" do
    i = subject
    target = 1
    i.add 'fluff', target
    i.search( 'f' ).should == {target => 3}
    i.add 'fluffluff', target
    i.search( 'fluff' ).should == {target => 3}
    i.search( 'lu' ).should == {target => 3}
    i.search( 'f' ).should == {target => 8}
  end

  it "should have named indices" do
    one_index = Index.with_name 42
    another_index = Index.with_name 66

    one_index.name.should == '42'
    another_index.name.should == '66'

    one_index.add 'meaning', 'universe'
    another_index.add 'evilness', 'hell'

    one_index.search( 'vil' ).should == { }
    another_index.search( 'vil' ).should == { 'hell' => 1 }

    one_index.search( 'ean' ).should == {'universe' => 1}
    another_index.search( 'ean' ).should == {  }
  end

  it "should handle source also" do
    i = subject
    i.add 'landsnora', 'edsberg'
    i.add 'landsnora', 'edsberg', :source => 'sollentuna'
    i.search( 'landsnora' ).should == {'edsberg' => 2}
  end

  it "should remove targets" do
    i = subject
    i.add 'searchentry', 'gooo', :source => 'gooo'
    i.search( 'entry' ).should == {'gooo' => 1}
    i.remove 'gooo'
    i.search( 'entry' ).should == {}
  end

  it "should remove sources" do
    i = subject
    i.add 'searchentry', 'target', :source => 'hoola'
    i.search( 'entry' ).should == {'target' => 1}
    i.remove 'hoola'
    i.search( 'entry' ).should == {}
  end

  it "should have a configurable storage" do
    configure do |config|
      config.storage = DummyStorage
    end

    i = Index.default
    i.add 'a', 1
    i.search 'a'
    DummyStorage.should be_saved_once
    DummyStorage.should be_searched_once
  end

  it "should set name in init if name= is present" do
    configure do |config|
      config.storage = DummyStorage
    end

    i = Index.with_name 'a_name'
    DummyStorage.should be_name_setter_called
  end

end

class DummyStorage

  def initialize
    @@saved_count = 0
    @@searched_count = 0
    @@name_setter_called = false
  end

  def save target, weights, options = {}
    @@saved_count += 1
  end

  def search query
    @@searched_count += 1
  end

  def DummyStorage::saved_once?
    @@saved_count == 1
  end

  def DummyStorage::searched_once?
    @@searched_count == 1
  end

  def DummyStorage::name_setter_called?
    @@name_setter_called
  end

  def name= name
    @@name_setter_called = true
  end

  def clear
  end
end


