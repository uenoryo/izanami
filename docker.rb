require 'docker'

# Docker ...
module Docker
  def launch(image, name, host_port, container_port)
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
      }
      # 'Volumes' => {'additionalProperties' => {'/' => '/'}},
    ).start
  end
end
