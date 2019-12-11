require 'json'

module Kenko
  class Middleware
    class ResponseBuilder
      def call(check_statueses)
        check_statueses.to_json
      end
    end

    attr_reader :container, :checks, :options

    def initialize(app, container: Kenko::Container, checks: :all, **options)
      @container = container
      @checks = checks
      @options = options
      @app = app
    end

    HEALTH_CHECL_PATH_REGEXP = %r{\A/health\z}

    def call(env)
      req = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)

      check_statueses = Kenko::Checker.new.call(checks: checks)

      if health_check_path?(req)
        response = [
          ResponseBuilder.new.call(check_statueses)
        ]
      end

      headers['Content-Length'] = response.first.size.to_s
      [status, headers, response]
    end

    def health_check_path?(req)
      req.path =~ HEALTH_CHECL_PATH_REGEXP
    end
  end
end
