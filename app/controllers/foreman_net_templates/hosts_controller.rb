module ForemanNetTemplates
  # Example: Plugin's HostsController inherits from Foreman's HostsController
  class HostsController < ::HostsController
    # change layout if needed
    # layout 'foreman_net_templates/layouts/new_layout'

    def new_action
      # automatically renders view/foreman_net_templates/hosts/new_action
    end
  end
end
