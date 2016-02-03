module ForemanNetTemplates
  module NicExtensions
    extend ActiveSupport::Concern

    def os_net_config_type
      case interface_class(name).to_s
        when 'Nic::Bond'
          'linux_bond'
        when 'Nic::Bridge'
          'linux_bridge'
        else
          'interface'
        end
    end

    def os_net_config_ipaddress
      {:ip_netmask => "#{ip}/#{subnet.cidr}"}
    end

    def to_os_net_config
      os_net_config = Hash.new
      os_net_config['name'] = identifier
      os_net_config['type'] = os_net_config_type
      os_net_config['addresses'] = Array.new(os_net_config_ipaddress)
      #TODO: routes
      #TODO: bond
      #TODO: bridge
    end

  end
end
