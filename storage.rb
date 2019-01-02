require 'date'
require 'yaml'

# Storage (｀・ω・)▄︻┻┳═一
module Storage
  FILENAME = 'storage.yml'

  class Record
    def self.create(subdomain, image, name, container_port, updated_at)
      raise "invalid date format #{updated_at}" unless !! Date.parse(updated_at)

      {
        subdomain: subdomain,
        image: image,
        name: name,
        container_port: container_port,
        updated_at: updated_at,
      }
    end

    private def date_valid?(str)
      !! Date.parse(str) rescue false
    end
  end

  def save(record)
    maybe "error file open #{FILENAME}" do
      file = File.open(FILENAME, 'w')
    end

    maybe "error dump yaml" do
      YAML.dump(all.push(record), file)
    end
  end

  def all()
    list = YAML.load_file(FILENAME)
    raise "failed load file #{FILENAME}" unless list
    list
  end
end
