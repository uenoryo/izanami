require './request'
require 'rack/reverse_proxy'

class IzanamiServer
  attr_accessor :request

  def receive(request)
    @request = Request.marshal(request)
  end

  def respond
    case @request.subdomain
    when "dobai"
      target = "http://localhost:8001"
    when "dev"
      target = "http://localhost:8002"
    when "izanami"
      return self.respond_to_admin_request
    else
      return self.respond_not_found
    end

    app = Rack::ReverseProxy.new {reverse_proxy "/", target}
    app.call(@request.data)
  end

  def respond_to_admin_request
    nil
  end

  def respond_not_found
    Rack::Response.new("not found", 404)
  end
end
