require 'json'
require 'rack/reverse_proxy'

require './errors'
require './request'
require './response'
require './izanami'

# IzanamiServer (｀・ω・)▄︻┻┳═一
class IzanamiServer
  attr_reader :request

  ADMIN_SUBDOMAIN = 'izanami'

  def respond(request)
    maybe 'error marshal request' do
      @request = Request.marshal(request)
    end

    if @request.subdomain == ADMIN_SUBDOMAIN
      return respond_to_admin_request
    end

    respond_to_proxy_request
  rescue => e
    message = errors_new(e)
    STDERR.puts message
    Response.server_error(message)
  end

  def respond_to_proxy_request
    proxy_host = Izanami.new.proxy_host(@request.subdomain)
    return Response.not_found if proxy_host.nil?

    app = Rack::ReverseProxy.new { reverse_proxy '/', proxy_host }
    app.call(@request.data)
  end

  def respond_to_admin_request
    if @request.get?
      case @request.path
      when '/'
        return Izanami.new.view_home
      when '/list'
        return Izanami.new.list
      end
    end

    if @request.post?
      case @request.path
      when '/launch'
        err = @request.validate_for_launch
        return Response.bad_request(err) unless err.nil?

        input = @request.input
        return Izanami.new.launch(subdomain: input['subdomain'], image: input['image'], branch: input['branch'])
      when '/destroy'
        err = @request.validate_for_destroy
        return Response.bad_request(err) unless err.nil?

        input = @request.input
        return Izanami.new.destroy(subdomain: input['subdomain'])
      end
    end

    Response.not_found
  end
end
