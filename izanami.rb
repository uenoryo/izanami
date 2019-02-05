require 'erb'
require 'date'

require './docker'
require './storage'
require './response'

# Izanami (｀・ω・)▄︻┻┳═一
class Izanami
  include Storage
  include Docker

  CONTAINER_NAME_PREFIX = 'izanami_'
  HTTP_PORT = 80
  BEGINING_PORT = 8500
  LOCAL_LOOPBACK_ADDRESS = '127.0.0.1'
  URL_SCHEME_HTTP = 'http://'

  def launch(subdomain:, image:, branch:)
    info = nil
    maybe 'error create record' do
      container_name = CONTAINER_NAME_PREFIX + subdomain
      now = DateTime.now.strftime('%Y-%m-%d %H:%M:%S')
      info = Record.create(
        subdomain: subdomain,
        image: image,
        name: container_name,
        branch: branch,
        container_port: next_port(BEGINING_PORT),
        updated_at: now
      )
    end

    container = nil
    maybe "error launch container info #{info}" do
      container = launch_container(
        image: info[:image],
        name: info[:name],
        host_port: info[:container_port],
        container_port: HTTP_PORT,
        subdomain: info[:subdomain],
        branch: branch
      )
    end
    info[:id] = container.id

    maybe "error save record #{info}" do
      save(info)
    end

    Response.success_launch(info)
  end

  def restart(subdomain:)
    record = nil
    maybe 'error find record' do
      record = find_must_by_subdomain(subdomain)
    end

    maybe "error restart container id #{record[:id]}" do
      restart_container(record[:id])
    end

    Response.success_restart(record)
  end

  def destroy(subdomain:)
    record = nil
    maybe 'error find record' do
      record = find_must_by_subdomain(subdomain)
    end

    maybe "error destroy container id #{record[:id]}" do
      destroy_container(record[:id])
    end

    maybe "error delete record #{record}" do
      delete(record)
    end

    Response.success_destroy(record)
  end

  def list()
    records = []
    maybe "error fetch all" do
      records = fetch_all
    end
    Response.success_list(records)
  end

  # TODO: https への対応
  def proxy_host(subdomain)
    record = find_by_subdomain(subdomain)
    return if record.nil?

    "#{URL_SCHEME_HTTP}#{LOCAL_LOOPBACK_ADDRESS}:#{record[:container_port]}"
  end

  def view_home()
    base = ERB.new(File.read('./templates/home.html.erb'))
    script = ERB.new(File.read('./templates/_script.html.erb')).result
    Response.view(base.result(binding))
  end
end
