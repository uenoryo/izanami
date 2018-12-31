class Izanami
  attr_accessor @docker

  def initialize()
    @docker = new Docker
  end
end
