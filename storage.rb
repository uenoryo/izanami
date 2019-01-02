require 'date'
require 'yaml'

# Storage (｀・ω・)▄︻┻┳═一
module Storage
  FILENAME = 'storage.yml'

  # Record (｀・ω・)▄︻┻┳═一
  class Record
    def self.create(subdomain, image, name, container_port, updated_at)
      raise "invalid date format #{updated_at}" unless Date.parse(updated_at)

      {
        subdomain: subdomain,
        image: image,
        name: name,
        container_port: container_port,
        updated_at: updated_at
      }
    end
  end

  def save(record)
    file = nil
    maybe "error file open #{FILENAME}" do
      file = File.open(FILENAME, 'w')
    end

    maybe 'error dump yaml' do
      YAML.dump(all.push(record), file)
    end
  end

  def all
    list = nil
    maybe "failed load file #{FILENAME}" do
      list = YAML.load_file(FILENAME)
    end

    list
  end
end
