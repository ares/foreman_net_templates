module ForemanNetTemplates
  module HostExtensions
    extend ActiveSupport::Concern

    # Returns a os_net_config compatible hash
    # See https://github.com/openstack/os-net-config for the specs
    def os_net_config
      {:network_config => interfaces.map(&:to_os_net_config)}
    end

    def os_net_config_json
      os_net_config.to_json
    end

  end
end
