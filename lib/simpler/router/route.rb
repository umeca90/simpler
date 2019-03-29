module Simpler
  class Router
    class Route #:nodoc:
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method     = method
        @path       = path
        @controller = controller
        @action     = action
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def params(env)
        request = Rack::Request.new(env)
        request.params.merge(create_params(env['PATH_INFO']))
      end

      private

      def create_params(env_path_info)
        param = {}
        path = define_params(@path)
        request = define_params(env_path_info)

        path.zip(request).each.with_object({}) do |(path_part, request_part), param|
          param[path_part.delete(':').to_sym] = request_part if param?(path_part)
        end
      end

      def define_params(path)
        path.split('/').reject(&:empty?)
      end

      def correct_path?(path)
        proper_params_size?(path) && path.match?(path_regexp)
      end

      def proper_params_size?(path)
        path.split('/').size == @path.split('/').size
      end

      def param?(param)
        param.start_with?(':')
      end

      def path_regexp
        route = define_params(@path)
        route.map { |param| param?(param) ? '[[:alnum:]]' : param }
             .join('/')
      end
    end
  end
end
