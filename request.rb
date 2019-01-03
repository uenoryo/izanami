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
    @input = []
    json = @data['rack.input']&.read
    return if json.nil? || json.empty?

    @input = JSON.parse json
  end

  def validate_for_launch
    if @input['subdomain'].nil? || @input['subdomain'].empty?
      return 'subdomain is required for launch'
    end

    if @input['image'].nil? || @input['image'].empty?
      return 'image is required for launch'
    end

    if @input['branch'].nil? || @input['branch'].empty?
      return 'branch is required for launch'
    end
  end

  def validate_for_destroy
    if @input['subdomain'].nil? || @input['subdomain'].empty?
      'subdomain is required for destroy'
    end
  end

  def get?
    @method == 'GET'
  end

  def post?
    @method == 'POST'
  end
end
