module ForemanNetTemplates
  module NicExtensions
    extend ActiveSupport::Concern

    def os_net_config_type
      case self.type
      when 'Nic::Bond'
        'linux_bond'
      when 'Nic::Bridge'
        'linux_bridge'
      else
        'interface'
      end
    end

    def os_net_config_ipaddress
      [{:ip_netmask => "#{ip}/#{subnet.cidr}"}] if subnet
      []
    end

    def to_os_net_config
      {
        :name => identifier,
        :type => os_net_config_type,
        :addresses => os_net_config_ipaddress,
        #TODO: routes
        #TODO: bond
        #TODO: bridge
      }
    end

  end
end
