require './docker'
require './storage'

# Izanami ...
class Izanami
  include Docker
  include Storage
end
