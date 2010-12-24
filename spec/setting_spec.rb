require 'spec_helper'
require 'setting'

describe Setting do
  it "should raise error for illegal key" do
    lambda{Setting['illegal/key']}.should raise_error
  end
  it "should return nil for not exist key!" do
    Setting['not.exist.key'].should be_nil
  end
  it "should return the value" do
    Setting.stub(:find_by_key).with('key.to.value').and_return("the value")
    Setting['key.to.value'].should == 'the value'
  end
  it "should accept and store for the key/value pair" do
    Setting['key.to.value'] = 'the value'
    Setting['key.to.value'].should == 'the value'
  end
end