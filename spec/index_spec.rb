$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fragmentizer'
require 'index'

include Seasy

describe Index do
  before :each do
    subject.clear
  end
  
  it "should default and have some basic behaviour" do
    i = subject
    i.add 'fredrik den store', 1
    i.search( "red" ).should == {1 => 1}
    i.add 'red red wine', 2
    i.search( "red").should == {2 => 2 ,1 => 1}
    i.search( "e" ).should == {1 => 3, 2 => 3}
  end
  
  it "should be possible to add complex strings twice" do
    i = subject
    i.add 'fluff', 1
    i.search( 'f' ).should == {1 => 3}
    i.add 'fluffluff', 1
    i.search( 'fluff' ).should == {1 => 3}
    i.search( 'lu' ).should == {1 => 3}
    i.search( 'f' ).should == {1 => 8}
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
end

class DummyStorage 
  def initialize
    @@saved_count = 0
    @@searched_count = 0
  end
  
  def save target, weights
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
  
  def clear
  end
end


