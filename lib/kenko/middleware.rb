require 'json'

module Kenko
  class Middleware
    # TODO: tests
    class ResponseBuilder
      # TODO: allow to use text and json response (/health and /health.json)
      def call(check_statueses, json: false)
        json ? check_statueses.to_json : html_response(check_statueses)
      end

    private

      def html_response(check_statueses)
        check_statueses.map { |check| "#{human_status(check[:status])} - #{check[:name]}" }.join('<br>')
      end

      def human_status(status)
        status ? 'OK' : 'WARN'
      end
    end

    attr_reader :container, :checks, :options, :health_check_path_regexp

    def initialize(app, path: '/health', container: Kenko::Container, checks: :all, **options)
      @container = container
      @checks = checks
      @options = options
      @app = app
      @health_check_path_regexp = %r/\A#{path}(?<json>.json)?\z/
    end


    def call(env)
      req = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)

      # TODO: move it to DI
      check_statueses = Kenko::Checker.new.call(checks: checks)

      if path = health_check_path?(req)
        response = [ResponseBuilder.new.call(check_statueses, json: !!path[:json])]
      end

      headers['Content-Length'] = response.first.size.to_s
      [status, headers, response]
    end

    def health_check_path?(req)
      health_check_path_regexp.match(req.path)
    end
  end
end
