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
    all_records = []
    maybe 'error get all record' do
      all = fetch_all
      all_records = all if all
    end

    file = nil
    maybe "error file open #{FILENAME}" do
      file = File.open(FILENAME, 'w')
    end

    maybe 'error dump yaml' do
      all_records.unshift(record)
      all_records = uniq_by_subdomain(all_records)
      YAML.dump(all_records, file)
      reset_cache
    end

    file.close
  end

  def fetch_all
    return @list unless @list.nil?

    list = []
    return list unless File.exist?(FILENAME)

    maybe "failed load file #{FILENAME}" do
      list = YAML.load_file(FILENAME)
    end

    @list = list
    list
  end

  def reset_cache
    @list = nil
  end

  def uniq_by_subdomain(records)
    subdomains = []
    records.reject do |record|
      if subdomains.include?(record[:subdomain])
        true
      else
        subdomains.push(record[:subdomain])
        false
      end
    end
  end
end
