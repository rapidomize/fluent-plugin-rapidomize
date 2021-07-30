describe Fluent::Plugin::RapidomizeOutput do
  include Fluent::Test::Helpers 

  it 'should load config' do
    run_driver do | driver, rpz |
      expect(driver.instance.appid).to eq TEST_APP_ID
      expect(driver.instance.icappid).to eq TEST_ICAPP_ID
      expect(driver.instance.apptoken).to eq TEST_AUTH_TOKEN
    end
  end
end