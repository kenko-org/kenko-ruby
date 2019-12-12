require 'json'

module Kenko
  class Middleware
    # TODO: tests
    class ResponseBuilder
      # TODO: allow to use text and json response (/health and /health.json)
      def call(check_statueses)
        check_statueses.to_json
      end
    end

    attr_reader :container, :checks, :options, :health_checl_path_regexp

    def initialize(app, path: '/health', container: Kenko::Container, checks: :all, **options)
      @container = container
      @checks = checks
      @options = options
      @app = app
      @health_checl_path_regexp = %r/\A#{path}\z/
    end


    def call(env)
      req = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)

      # TODO: move it to DI
      check_statueses = Kenko::Checker.new.call(checks: checks)

      if health_check_path?(req)
        response = [ResponseBuilder.new.call(check_statueses)]
      end

      headers['Content-Length'] = response.first.size.to_s
      [status, headers, response]
    end

    def health_check_path?(req)
      req.path =~ health_checl_path_regexp
    end
  end
end
