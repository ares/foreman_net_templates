module ForemanNetTemplates
  module HostExtensions

    # Returns a os_net_config compatible hash
    # See https://github.com/openstack/os-net-config for the specs
    def os_net_config
    end

    def os_net_config_json
      os_net_config.to_json
    end

  end
end
