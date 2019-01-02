require 'date'

require './docker'
require './storage'

# Izanami (｀・ω・)▄︻┻┳═一
class Izanami
  include Storage
  include Docker

  CONTAINER_NAME_PREFIX = 'izanami_'
  BEGINING_PORT = 8500

  def launch(subdomain, image)
    info = nil
    maybe 'error create record' do
      container_name = CONTAINER_NAME_PREFIX + subdomain
      now = DateTime.now.strftime("%Y-%m-%d %H:%M:%S")
      info = Record.create(subdomain, image, container_name, next_port(BEGINING_PORT), now)
    end

    maybe "error save record #{record}" do
      save(record)
    end
  end
end
