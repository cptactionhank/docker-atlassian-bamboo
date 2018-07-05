describe 'Atlassian Bamboo behind reverse proxy' do
  include_examples 'a buildable Docker image', '.',
    env: [
      "CATALINA_OPTS=-Xms1024m -Xmx2048m -Djava.security.egd=file:/dev/./urandom -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout}",
      "X_PROXY_NAME=localhost",
      'X_PROXY_PORT=1234',
      'X_PROXY_SCHEME=http',
      'X_PATH=/bamboo-path'
    ]

  include_examples 'an acceptable Atlassian Bamboo instance', 'using an embedded database' do
    before :all do
      image = Docker::Image.build_from_dir '.docker/nginx'
      # Create and run a nginx reverse proxy container instance
      @container_proxy = Docker::Container.create image: image.id,
        portBindings: { '80/tcp' => [{ 'HostPort' => '1234' }] },
        links: ["#{@container.id}:container"]
      @container_proxy.start!
      @container_proxy.setup_capybara_url({ tcp: 80 }, '/bamboo-path')
    end

    after :all do
      if ENV['CIRCLECI']
        @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
      else
        @container_proxy.kill signal: 'SIGKILL' unless @container_proxy.nil?
        @container_proxy.remove force: true, v: true unless @container_proxy.nil?
      end
    end
  end
end
