require 'json'

# Request (｀・ω・)▄︻┻┳═一
class Request
  attr_reader :data
  attr_reader :subdomain
  attr_reader :path
  attr_reader :method
  attr_reader :input

  def self.marshal(data)
    request = new data
    request.set_sub_domain
    request.set_path
    request.set_method
    request.set_input
    request
  end

  def initialize(data)
    # data.each do |d|
    #   p d
    # end
    @data = data
  end

  def set_sub_domain
    @subdomain = @data['HTTP_HOST'].split('.')[0] || ''
  end

  def set_path
    @path = @data['REQUEST_PATH']
  end

  def set_method
    @method = @data['REQUEST_METHOD']
  end

  def set_input
    json = @data['rack.input']&.read
    @input = JSON.parse json
  end

  def get?
    @method == 'GET'
  end

  def post?
    @method == 'POST'
  end
end
