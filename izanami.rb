require './docker'
require './storage'

# Izanami (｀・ω・)▄︻┻┳═一
class Izanami
  include Storage
  include Docker

  def launch(subdomain, image)
    record = nil
    maybe 'error create record' do
      record = Record.create(subdomain, image, 'せんべい', 9922, '1995-06-11 10:00:22')
    end

    maybe 'error save record' do
      save(record)
    end
  end
end
