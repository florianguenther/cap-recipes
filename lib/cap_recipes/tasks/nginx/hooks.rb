# @author Donovan Bray <donnoman@donovanbray.com>

Capistrano::Configuration.instance(true).load do
  
  before "deploy:provision", "nginx:install"
  before "deploy:setup", "nginx:configure"
  
end