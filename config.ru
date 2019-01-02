require './izanami_server'
require 'rack'

# Server (｀・ω・)▄︻┻┳═一
class Server
  def call(request)
    server = IzanamiServer.new
    server.respond(request)
  end
end

run Server.new
