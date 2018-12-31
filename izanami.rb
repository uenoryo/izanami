require 'rack'
require 'rack/reverse_proxy'

class Izanami
  attr_accessor :env

  def initialize(env)
    @env = env
  end

  def respond
    case self.subdomain
    when 'dobai'
      target = 'http://localhost:8001'
    when 'dev'
      target = 'http://localhost:8002'
    else
      return Rack::Response.new("not found", 404)
    end

    app = Rack::ReverseProxy.new {reverse_proxy '/', target}
    app.call(@env)
  end

  def respond_to_admin_request
    nil
  end

  def subdomain
    @env['HTTP_HOST'].split('.')[0]
  end
end
