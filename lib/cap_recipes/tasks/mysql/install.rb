# @author Donovan Bray <donnoman@donovanbray.com>
require File.expand_path(File.dirname(__FILE__) + '/../utilities')

Capistrano::Configuration.instance(true).load do

  namespace :mysql do

    set(:mysql_admin_password) { utilities.ask "mysql_admin_password:"}

    desc "Install Mysql-server"
    task :install, :roles => :db do
      #TODO: check password security, something seems off after install
      #http://serverfault.com/questions/19367/scripted-install-of-mysql-on-ubuntu
      #TODO: Break out Client Server Roles into :mysql (client) :mysqld (server)
      begin
        put %Q{
          Name: mysql-server/root_password
          Template: mysql-server/root_password
          Value: #{mysql_admin_password}
          Owners: mysql-server-5.1
          Flags: seen

          Name: mysql-server/root_password_again
          Template: mysql-server/root_password_again
          Value: #{mysql_admin_password}
          Owners: mysql-server-5.1
          Flags: seen

          Name: mysql-server/root_password
          Template: mysql-server/root_password
          Value: #{mysql_admin_password}
          Owners: mysql-server-5.0
          Flags: seen

          Name: mysql-server/root_password_again
          Template: mysql-server/root_password_again
          Value: #{mysql_admin_password}
          Owners: mysql-server-5.0
          Flags: seen
        }, "non-interactive.txt"
        sudo "DEBIAN_FRONTEND=noninteractive DEBCONF_DB_FALLBACK=Pipe apt-get -qq -y install mysql-server < non-interactive.txt"
      rescue
        raise
      ensure
        sudo "rm non-interactive.txt"
      end

    end

    desc "Install Mysql Developement Libraries"
    task :install_client_libs, :except => {:no_release => true} do
        utilities.apt_install "libmysqlclient-dev"
    end
    
  end

end