module ForemanNetTemplates
  class Engine < ::Rails::Engine
    engine_name 'foreman_net_templates'

    config.autoload_paths += Dir["#{config.root}/app/controllers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/helpers/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/models/concerns"]
    config.autoload_paths += Dir["#{config.root}/app/overrides"]

    # Add any db migrations
    initializer 'foreman_net_templates.load_app_instance_data' do |app|
      ForemanNetTemplates::Engine.paths['db/migrate'].existent.each do |path|
        app.config.paths['db/migrate'] << path
      end
    end

    initializer 'foreman_net_templates.register_plugin', :before => :finisher_hook do |_app|
      Foreman::Plugin.register :foreman_net_templates do
        requires_foreman '>= 1.10'

        allowed_template_helpers :build_network_config_files

        # Add permissions
        # security_block :foreman_net_templates do
        #   permission :view_foreman_net_templates, :'foreman_net_templates/hosts' => [:new_action]
        # end

        # Add a new role called 'Discovery' if it doesn't exist
        # role 'ForemanNetTemplates', [:view_foreman_net_templates]

        # add menu entry
        # menu :top_menu, :template,
        #      url_hash: { controller: :'foreman_net_templates/hosts', action: :new_action },
        #      caption: 'ForemanNetTemplates',
        #      parent: :hosts_menu,
        #      after: :hosts

        # add dashboard widget
        # widget 'foreman_net_templates_widget', name: N_('Foreman plugin template widget'), sizex: 4, sizey: 1
      end
    end

    # Precompile any JS or CSS files under app/assets/
    # If requiring files from each other, list them explicitly here to avoid precompiling the same
    # content twice.
    # assets_to_precompile =
    #   Dir.chdir(root) do
    #     Dir['app/assets/javascripts/**/*', 'app/assets/stylesheets/**/*'].map do |f|
    #       f.split(File::SEPARATOR, 4).last
    #     end
    #   end
    # initializer 'foreman_net_templates.assets.precompile' do |app|
    #   app.config.assets.precompile += assets_to_precompile
    # end
    # initializer 'foreman_net_templates.configure_assets', group: :assets do
    #   SETTINGS[:foreman_net_templates] = { assets: { precompile: assets_to_precompile } }
    # end

    # Include concerns in this config.to_prepare block
    config.to_prepare do
      begin
        Host::Managed.send(:include, ForemanNetTemplates::HostExtensions)
        Nic::Managed.send(:include, ForemanNetTemplates::NicExtensions)
      rescue => e
        Rails.logger.warn "ForemanNetTemplates: skipping engine hook (#{e})"
      end
    end

    initializer 'foreman_net_templates.renderer_extensions' do |app|
      ActionView::Base.send :include, ForemanNetTemplates::RendererExtensions
    end

    config.after_initialize do
      # this does not work because of STI of controllers :-/
      # ::Foreman::Renderer.send :include, ForemanNetTemplates::RendererExtensions
      # we use this hack instead
      (TemplatesController.descendants + [TemplatesController]).each do |klass|
        klass.send(:include, ForemanNetTemplates::RendererExtensions)
      end
    end

    rake_tasks do
      Rake::Task['db:seed'].enhance do
        ForemanNetTemplates::Engine.load_seed
      end
    end

    initializer 'foreman_net_templates.register_gettext', after: :load_config_initializers do |_app|
      locale_dir = File.join(File.expand_path('../../..', __FILE__), 'locale')
      locale_domain = 'foreman_net_templates'
      Foreman::Gettext::Support.add_text_domain locale_domain, locale_dir
    end
  end
end
