require 'test_plugin_helper'

describe ForemanNetTemplates::HostExtensions do
  context 'single interface' do
    let(:host) { FactoryGirl.build(:host) }

    it 'should render an empty config' do
      host.os_net_config.must_equal({:network_config => []})
    end
  end
end
