require 'docker'

container = Docker::Container.create(
  'Image'        => 'nimmis/apache-php7',
  'name'         => 'ruby-test',
  'Tty'          => true,
  'AttachStdin'  => true,
  'Volumes'      => {'additionalProperties' => {'/Users/ryo/dev/src/github.com/uenoryo/izanami' => '/var/www/html'}},
  'ExposedPorts' => { '80/tcp' => {} },
  'HostConfig'   => {
    'PortBindings' => {
      '80/tcp' => [{ 'HostPort' => '80' }]
    }
  }
)

container.start
