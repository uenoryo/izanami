require './izanami'
require 'rack'
require 'rack/reverse_proxy'

class IzanamiServer
  def call(env)
    izanami = Izanami.new env
    return izanami.respond
  end
end

run IzanamiServer.new
