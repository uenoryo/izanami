class Request
  attr_reader :data
  attr_reader :subdomain
  attr_reader :path

  def self.marshal(data)
    request = self.new data
    request.set_sub_domain
    request.set_path
    return request
  end

  def initialize(data)
    data.each_with_index do |a, b|
      p a
      p b
    end
    @data = data
  end

  def set_sub_domain
    @subdomain = @data["HTTP_HOST"].split(".")[0] || ""
  end

  def set_path
    @path = @data["REQUEST_PATH"]
  end
end
