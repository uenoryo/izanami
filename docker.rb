require 'docker'

# Docker (｀・ω・)▄︻┻┳═一
module Docker
  def launch_container(image:, name:, host_port:, container_port:, subdomain:, branch:)
    Docker::Container.create(
      'Image' => image,
      'name' => name,
      'Tty' => true,
      'AttachStdin' => true,
      'ExposedPorts' => { "#{container_port}/tcp" => {} },
      'HostConfig' => {
        'PortBindings' => {
          "#{container_port}/tcp" => [{ 'HostPort' => host_port.to_s }]
        }
      },
      'Env' => [
        "GIT_BRANCH=#{branch}",
        "PORT=#{container_port}",
        "SUBDOMAIN=#{subdomain}"
      ]
      # 'Volumes' => {'additionalProperties' => {'/' => '/'}},
    ).start
  end

  def destroy_container(id)
    Docker::Container.get(id).remove(force: true)
  end
end
