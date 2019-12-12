require 'json'
require 'kenko/middleware/response_builder'

module Kenko
  class Middleware
    attr_reader :container, :checks, :options, :health_check_path_regexp, :checker

    def initialize(app, path: '/health', checks: :all, container: Kenko::Container, checker: Kenko::Checker.new, **options)
      @container = container
      @checker = checker
      @checks = checks
      @options = options
      @app = app
      @health_check_path_regexp = %r/\A#{path}(?<json>.json)?\z/
    end

    def call(env)
      req = Rack::Request.new(env)
      status, headers, response = @app.call(env)
      headers = Rack::Utils::HeaderHash.new(headers)

      check_statueses = checker.call(checks: checks)

      if path = health_check_path?(req)
        status = check_statueses.all? { |c| c[:status] } ? 200 : 503
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
