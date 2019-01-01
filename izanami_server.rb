require 'json'
require 'rack/reverse_proxy'

require './request'
require './izanami'

class IzanamiServer
  attr_reader :request

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
    if @request.is_get?
      case @request.path
      when "/"
        return [200, { "Content-Type" => "application/json" }, [ { :x => 1 }.to_json ]]
      when "/list"
        return [200, { "Content-Type" => "application/json" }, [ { :x => 2 }.to_json ]]
      end
    end

    if @request.is_post?
      case @request.path
      when "/launch"
        # Izanami.new.launch("nimmis/apache-php7", "onigiri", 80, 80)
        return [200, { "Content-Type" => "application/json" }, [ { :x => 2 }.to_json ]]
      end
    end

    return self.respond_not_found
  end

  def respond_not_found
    Rack::Response.new("404 not found", 404)
  end
end
