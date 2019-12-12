require 'json'

module Kenko
  class Middleware
    # TODO: tests
    class ResponseBuilder
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
  end
end
