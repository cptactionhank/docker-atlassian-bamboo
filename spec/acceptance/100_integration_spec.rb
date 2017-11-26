describe 'Atlassian Bamboo with Embedded Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx2048m -Djava.security.egd=file:/dev/./urandom -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout}"]

  include_examples 'an acceptable Atlassian Bamboo instance', 'using an embedded database'
end
