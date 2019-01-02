require './izanami_server'
require 'rack'

# Server (｀・ω・)▄︻┻┳═一
class Server
  def call(request)
    server = IzanamiServer.new
    server.receive request
    server.respond
  end
end

run Server.new
