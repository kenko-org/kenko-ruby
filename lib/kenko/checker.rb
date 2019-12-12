module Kenko
  class Checker
    attr_reader :container

    ALL_CHECKS = :all

    def initialize(container: Container)
      @container = container
    end

    def call(checks: :all)
      check_names = checks == ALL_CHECKS ? container.keys : checks
      check_names.map { |check| { name: check, status: check_status(check) } }
    end

  private

    def check_status(check)
      !!container.resolver(check)
    rescue StandardError
      false
    end
  end
end
