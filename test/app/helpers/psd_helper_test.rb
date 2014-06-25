require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

describe "Psdgo::App::PsdHelper" do
  setup do
    helpers = Class.new
    helpers.extend Psdgo::App::PsdHelper
    [helpers.foo]
  end

  asserts("#foo"){ topic.first }.nil
end
