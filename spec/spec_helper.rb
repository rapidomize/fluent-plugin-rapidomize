require 'fluent/test'
require 'fluent/test/driver/output'
require 'fluent/test/helpers'
require 'fluent/plugin/out_rapidomize'
require 'rapidomize'

# Disable Test::Unit
module Test::Unit::RunCount; def run(*); end; end
Test::Unit.run = true if defined?(Test::Unit) && Test::Unit.respond_to?(:run=)

RSpec.configure do |config|
  config.before(:all) do
    Fluent::Test.setup
  end
end

TEST_ICAPP_ID = "<icappid>".freeze
TEST_APP_ID = "<appid>".freeze
TEST_AUTH_TOKEN = "<token>".freeze

def run_driver(options = {})
  fluentd_conf = <<-EOB
type rapidomize
appid #{TEST_APP_ID}
icappid #{TEST_ICAPP_ID}
apptoken #{TEST_AUTH_TOKEN}
  EOB

  tag = options[:tag] || 'test.default'
  driver = Fluent::Test::Driver::Output.new(Fluent::Plugin::RapidomizeOutput).configure(fluentd_conf)

  driver.run(default_tag: tag) do
    rpz = driver.instance.instance_variable_get(:@rpz)
    yield(driver, rpz)
  end
end