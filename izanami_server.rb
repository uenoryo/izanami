require 'json'
require 'rack/reverse_proxy'

require './errors'
require './request'
require './izanami'

# IzanamiServer (｀・ω・)▄︻┻┳═一
class IzanamiServer
  attr_reader :request

  def receive(request)
    maybe "error request marshal #{request}" do
      @request = Request.marshal(request)
    end
  end

  def respond
    case @request.subdomain
    when 'dobai'
      target = 'http://localhost:8001'
    when 'dev'
      target = 'http://localhost:8002'
    when 'izanami'
      return respond_to_admin_request
    else
      return respond_not_found
    end

    app = Rack::ReverseProxy.new { reverse_proxy '/', target }
    app.call(@request.data)
  rescue => e
    err = errors_new(e)
    STDERR.puts err
    respond_server_error(err)
  end

  def respond_to_admin_request
    if @request.get?
      case @request.path
      when '/'
        return [200, { 'Content-Type' => 'application/json' }, [{ x: 1 }.to_json]]
      when '/list'
        return [200, { 'Content-Type' => 'application/json' }, [{ x: 2 }.to_json]]
      end
    end

    if @request.post?
      case @request.path
      when '/launch'
        err = @request.validate_for_launch
        return respond_bad_request(err) unless err.nil?

        input = @request.input

        maybe "izanami launch failed, input: #{input}" do
          Izanami.new.launch(
            subdomain: input['subdomain'],
            image: input['image'],
            branch: input['branch']
          )
        end
        return [200, { 'Content-Type' => 'application/json' }, [{ x: 2 }.to_json]]
      end
    end

    respond_not_found
  end

  def respond_server_error(message)
    Rack::Response.new("500 internal server error: #{message}", 500)
  end

  def respond_bad_request(message)
    Rack::Response.new("400 bad request: #{message}", 400)
  end

  def respond_not_found
    Rack::Response.new('404 not found', 404)
  end
end
