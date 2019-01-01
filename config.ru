require './izanami_server'
require 'rack'

class Server
  def call(request)
    server = IzanamiServer.new
    server.receive request
    return server.respond
  end
end

run Server.new
