require 'date'

require './docker'
require './storage'
require './response'

# Izanami (｀・ω・)▄︻┻┳═一
class Izanami
  include Storage
  include Docker

  CONTAINER_NAME_PREFIX = 'izanami_'
  HTTP_PORT = 80
  BEGINING_PORT = 8500

  def launch(subdomain:, image:, branch:)
    info = nil
    maybe 'error create record' do
      container_name = CONTAINER_NAME_PREFIX + subdomain
      now = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      info = Record.create(subdomain, image, container_name, next_port(BEGINING_PORT), now)
    end

    maybe "error launch container info #{info}" do
      launch_container(
        image: info[:image],
        name: info[:name],
        host_port: info[:container_port],
        container_port: HTTP_PORT,
        subdomain: info[:subdomain],
        branch: branch
      )
    end

    maybe "error save record #{info}" do
      save(info)
    end

    Response.success_launch(info)
  end
end
