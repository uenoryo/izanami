class Request
  attr_reader :data
  attr_reader :subdomain

  def self.marshal(data)
    request = self.new data
    request.set_sub_domain
    return request
  end

  def initialize(data)
    @data = data
  end

  def set_sub_domain
    @subdomain = @data["HTTP_HOST"].split(".")[0] || ""
  end
end
