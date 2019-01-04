require 'date'
require 'yaml'

# Storage (｀・ω・)▄︻┻┳═一
module Storage
  FILENAME = 'storage.yml'

  # Record (｀・ω・)▄︻┻┳═一
  class Record
    def self.create(subdomain:, image:, name:, branch:, container_port:, updated_at:)
      raise "invalid date format #{updated_at}" unless Date.parse(updated_at)

      {
        id: '',
        subdomain: subdomain,
        image: image,
        name: name,
        branch: branch,
        container_port: container_port,
        updated_at: updated_at
      }
    end
  end

  def save(record)
    raise 'container id is empty' if record[:id] == ''

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

  def delete(record)
    raise 'container id is empty' if record[:subdomain] == ''

    all_records = []
    maybe 'error get all record' do
      all = fetch_all
      all_records = all if all
    end

    file = nil
    maybe "error file open #{FILENAME}" do
      file = File.open(FILENAME, 'w')
    end

    all_records.reject! do |r|
      r[:subdomain] == record[:subdomain]
    end

    maybe 'error dump yaml' do
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
      list = YAML.load_file(FILENAME) || []
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

  def next_port(begining_port)
    limit = 500
    max_port = begining_port + limit
    used_ports = fetch_all.map do |record|
      record[:container_port]
    end

    (begining_port..max_port).each do |port|
      return port unless used_ports.include?(port)
    end

    raise "port #{begining_port} ~ #{max_port} is perfectly used"
  end

  def find_by_subdomain(subdomain)
    fetch_all.each do |record|
      return record if record[:subdomain] == subdomain
    end
    nil
  end

  def find_must_by_subdomain(subdomain)
    record = find_by_subdomain(subdomain)
    raise "record linked subdomain #{subdomain} is not found" if record.nil?

    record
  end
end
