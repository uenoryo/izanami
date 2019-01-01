require 'json'

class Request
  attr_reader :data
  attr_reader :subdomain
  attr_reader :path
  attr_reader :method
  attr_reader :input

  def self.marshal(data)
    request = self.new data
    request.set_sub_domain
    request.set_path
    request.set_method
    request.set_input
    return request
  end

  def initialize(data)
    data.each_with_index do |a, b|
      p a
    end
    @data = data
  end

  def set_sub_domain
    @subdomain = @data["HTTP_HOST"].split(".")[0] || ""
  end

  def set_path
    @path = @data["REQUEST_PATH"]
  end

  def set_method
    @method = @data["REQUEST_METHOD"]
  end

  def set_input
    json = @data["rack.input"]&.read
    @input = JSON.parse json
  end

  def is_get?
    @method === 'GET'
  end

  def is_post?
    @method === 'POST'
  end
end
