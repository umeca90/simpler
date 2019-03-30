module Simpler
  class Router
    class Route
      attr_reader :controller, :action

      def initialize(method, path, controller, action)
        @method     = method
        @path       = path
        @controller = controller
        @action     = action
        @path_regexp = regexp_path(@path)
      end

      def match?(method, path)
        @method == method && correct_path?(path)
      end

      def request_route_path_params(env)
        path = env['PATH_INFO']
        create_params(path)
      end

      private

      def create_params(env_path_info)
        path = path_to_array(@path)
        request = path_to_array(env_path_info)

        path.zip(request).each.with_object({}) do |(path_part, request_part), param|
          param[path_part.delete(':').to_sym] = request_part if param?(path_part)
        end
      end

      def path_to_array(path)
        path.split('/').reject(&:empty?)
      end

      def correct_path?(path)
        proper_params_size?(path) && path.match?(@path_regexp)
      end

      def proper_params_size?(path)
        path.split('/').size == @path.split('/').size
      end

      def param?(param)
        param.start_with?(':')
      end

      def regexp_path(path)
        splited_path = path.split('/')
        splited_path.map {|part| part.replace('.*') if part.match?(':')}
        splited_path.join('/')
      end
    end
  end
end
