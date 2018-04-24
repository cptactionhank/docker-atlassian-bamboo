describe 'Atlassian Bamboo with PostgreSQL 9.3 Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx2048m -Djava.security.egd=file:/dev/./urandom -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout}"]

  include_examples 'an acceptable Atlassian Bamboo instance', 'using a PostgreSQL database' do
    before :all do
      Docker::Image.create fromImage: 'postgres:9.3'
      # Create and run a PostgreSQL 9.3 container instance
      @container_db = Docker::Container.create image: 'postgres:9.3'
      @container_db.start!
      # Wait for the PostgreSQL instance to start
      @container_db.wait_for_output(/PostgreSQL\ init\ process\ complete;\ ready\ for\ start\ up\./)
      # Create JIRA database
      if ENV['CIRCLECI']
        `docker run --rm --link "#{@container_db.id}:db" postgres:9.3 psql --host "db" --user "postgres" --command "create database bamboodb owner postgres encoding 'utf8';"`
      else
        @container_db.exec ['psql', '--username', 'postgres', '--command', "create database bamboodb owner postgres encoding 'utf8';"]
      end
    end
    after :all do
      @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
      @container_db.remove force: true, v: true unless @container_db.nil? || ENV['CIRCLECI']
    end
  end
end
