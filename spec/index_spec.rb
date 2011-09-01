$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fragmentizer'
require 'index'

describe Index do
  it "should default and have some basic behaviour" do
    i = Index.default
    i.add 'fredrik den store', 1
    i.search( "red" ).should == {1 => 1}
    i.add 'red red wine', 2
    i.search( "red").should == {2 => 2 ,1 => 1}
  end
  
  it "should be possible to add complex strings twice" do
    i = Index.new
    i.add 'fluff', 1
    i.add 'fluffluff', 1
  end
end

