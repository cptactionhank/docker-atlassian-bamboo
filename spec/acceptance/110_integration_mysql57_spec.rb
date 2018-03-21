describe 'Atlassian Bamboo with MySQL 5.7 Database' do
  include_examples 'a buildable Docker image', '.', env: ["CATALINA_OPTS=-Xms1024m -Xmx2048m -Djava.security.egd=file:/dev/./urandom -Datlassian.plugins.enable.wait=#{Docker::DSL.timeout}"]

  include_examples 'an acceptable Atlassian Bamboo instance', 'using a MySQL database' do
    before :all do
      Docker::Image.create fromImage: 'mysql:5.7'
      # Create and run a MySQL 5.7 container instance
      @container_db = Docker::Container.create image: 'mysql:5.7', env: ['MYSQL_ROOT_PASSWORD=mysecretpassword']
      @container_db.start!
      # Wait for the MySQL instance to start
      @container_db.wait_for_output %r{socket:\ '/var/run/mysqld/mysqld\.sock'\ \ port:\ 3306\ \ MySQL\ Community\ Server\ \(GPL\)}
      # Create JIRA database
      if ENV['CIRCLECI']
        `docker run --link "#{@container_db.id}:db" mysql:5.7 mysql --host "db" --user=root --password=mysecretpassword --execute 'CREATE DATABASE bamboodb CHARACTER SET utf8 COLLATE utf8_bin;'`
      else
        @container_db.exec ['mysql', '--user=root', '--password=mysecretpassword', '--execute', 'CREATE DATABASE bamboodb CHARACTER SET utf8 COLLATE utf8_bin;']
      end
    end
    after :all do
      if ENV['CIRCLECI']
        @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
      else
        @container_db.kill signal: 'SIGKILL' unless @container_db.nil?
        @container_db.remove force: true, v: true unless @container_db.nil?
      end
    end
  end
end
