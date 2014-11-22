require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec/matchers'
require 'rack/test'
ENV['RACK_ENV'] = 'test'
ENV['ALIENIST_FILE'] = 'spec/fixtures/data.json'

require ::File.expand_path('../../alienist_viewer',  __FILE__)

AlienistViewer.plugin :not_found do
  raise 'page not found'
end

Capybara.app = AlienistViewer.app

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end

class RSpec::Core::ExampleGroup
  include Rack::Test::Methods
  include Capybara::DSL
  include Capybara::RSpecMatchers

  after do
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

describe "AlienistViewer" do
  it "should allow navigating the memory dump" do 
    visit('/')
    find('title').text.should == "AlienistViewer"
    click_link 'String'
    click_link '"Tom"'
    click_link 'String'
    click_link '"Valerie"'
    click_link '#[NameClass: 0x3]'
    click_link 'NameClass'
    click_link '#[NameClass: 0x2]'
    click_link '#[Fixnum: 0x5]'
    click_link '#[NameClass: 0x3]'
  end
end
