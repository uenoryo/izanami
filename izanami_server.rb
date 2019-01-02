require 'json'
require 'rack/reverse_proxy'

require './errors'
require './request'
require './response'
require './izanami'

# IzanamiServer (｀・ω・)▄︻┻┳═一
class IzanamiServer
  attr_reader :request

  def respond(request)
    maybe "error marshal request" do
      @request = Request.marshal(request)
    end

    case @request.subdomain
    when 'dobai'
      target = 'http://localhost:8001'
    when 'dev'
      target = 'http://localhost:8002'
    when 'izanami'
      return respond_to_admin_request
    else
      return Response.not_found
    end

    app = Rack::ReverseProxy.new { reverse_proxy '/', target }
    app.call(@request.data)
  rescue => e
    message = errors_new(e)
    STDERR.puts message
    Response.server_error(message)
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
        return Response.bad_request(err) unless err.nil?

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

    Response.not_found
  end
end
