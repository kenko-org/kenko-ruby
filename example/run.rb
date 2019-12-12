require 'sinatra/base'
require 'kenko'
require 'kenko/middleware'

Kenko::Container.register(:base) { true }
Kenko::Container.register(:bad) { nil }

class Web < Sinatra::Base
  # use Kenko::Middleware, checks: :all
  use Kenko::Middleware, checks: :all, path: '/health'
  # use Kenko::Middleware, checks: [:base]

  get '/' do
    'index'
  end
end

Web.run!
