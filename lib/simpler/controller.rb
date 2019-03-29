require_relative 'view'

module Simpler
  class Controller #:nodoc:
    attr_reader :name, :request, :response, :headers

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @headers  = @response.headers
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action

      send(action)
      set_default_headers
      write_response

      @response.finish
    end

    def params
      @request.env['simpler.params']
    end

    private

    def path_params
      @request.env['simpler.params']
    end

    def request_params
      @request.params
    end

    def status(status_code)
      @response.status = status_code
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = plain_text? ? 'text/plain' : 'text/html'
    end

    def write_response
      body = render_body

      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def plain_text?
      template = @request.env['simpler.template']
      !template.nil? && template.key?(:plain)
    end
  end
end
