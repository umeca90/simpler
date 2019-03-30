require 'erb'

module Simpler
  class View

    VIEW_BASE_PATH = 'app/views'.freeze

    def initialize(env)
      @env = env
    end

    def render(binding)
      if @env['simpler.template'] && @env['simpler.template'][:plain]
        render_plain
      else
        render_html(binding)

      end
    end

    private

    def render_plain
      @env['simpler.template'][:plain]
    end

    def render_html(binding)
      template = File.read(template_path)

      ERB.new(template).result(binding)
    end    

    def controller
      @env['simpler.controller']
    end

    def action
      @env['simpler.action']
    end

    def template
      @env['simpler.template']
    end

    def template_path
      path = template || [controller.name, action].join('/')
      @env['simpler.template_path'] = "#{path}.html.erb"
      Simpler.root.join(VIEW_BASE_PATH, "#{path}.html.erb")
    end

    #def render_template(binding)
      #template = File.read(template_path)

      #ERB.new(template).result(binding)
    #end
  end
end
