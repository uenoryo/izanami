require './docker'
require './storage'

# Izanami (｀・ω・)▄︻┻┳═一
class Izanami
  include Storage
  include Docker

  CONTAINER_NAME_PREFIX = 'izanami_'

  def launch(subdomain, image)
    record = nil
    maybe 'error create record' do
      container_name = CONTAINER_NAME_PREFIX + subdomain
      record = Record.create(subdomain, image, container_name, 9922, '1995-06-11 10:00:22')
    end

    maybe "error save record #{record}" do
      save(record)
    end
  end
end
