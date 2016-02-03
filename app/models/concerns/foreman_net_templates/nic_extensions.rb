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

    def os_net_config_ip_address
      return [{:ip_netmask => "#{ip}/#{subnet.cidr}"}] if subnet
      []
    end

    def to_os_net_config
      # TODO for debian a name is required but identifier is not required field
      {
        :name => identifier,
        :type => os_net_config_type,
        :addresses => os_net_config_ip_address,
        #TODO skip BMC
        #TODO: routes
        #TODO: bond
        #TODO: bridge
      }
    end

  end
end
