$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'fragmentizer'

describe Fragmentizer do
  it "should split a string in its parts" do
    f = Fragmentizer.new
    result = f.fragmentize( "abc" )
    result.size.should == 6
    result["a"].should == 1
    result["b"].should == 1
    result["c"].should == 1
    result["ab"].should == 1
    result["bc"].should == 1
    result["abc"].should == 1
  end

  it "should count several ocurrences" do
    f = Fragmentizer.new
    result = f.fragmentize( "abcab" )
    result.size.should == 12
    result["a"].should == 2
    result["b"].should == 2
    result["c"].should == 1
    result["ab"].should == 2
    result["bc"].should == 1
    result["ca"].should == 1
    result["abc"].should == 1    
    result["abca"].should == 1    
    result["abcab"].should == 1    
    result["bca"].should == 1    
    result["bcab"].should == 1    
    result["cab"].should == 1    
  end
  
  it "should count conecutive singularities" do
    f = subject
    result = f.fragmentize "fluffluff"
    result["f"].should == 5
  end
  
  it "should split a string into parts on whitespace" do
    f = Fragmentizer.new
    result = f.fragmentize( "ab c" )
    result.size.should == 4
  end
end
