module ForemanNetTemplates
  module RendererExtensions
    extend ActiveSupport::Concern

    included do
      Foreman::Renderer::ALLOWED_HELPERS << :net_config
    end

    # create or overwrite instance methods...
    def net_config
      'hello'
    end
  end
end
