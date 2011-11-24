# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'bundler/capistrano'
require 'rvm/capistrano'
require 'hoptoad_notifier/capistrano'

#set :rvm_ruby_string, 'ree'
#set :rvm_type, :user  # Don't use system-wide RVM

set :application, "giftcircle"
set :repository,  "git@github.com:tedkulp/giftcircle.git"

set :deploy_to, "/var/www/gift-circle.com/www"

set :scm, :git

set :user, "rails"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

role :web, "shiftrefresh.net"                         # Your HTTP server, Apache/etc
role :app, "shiftrefresh.net"                         # This may be the same as your `Web` server
role :db,  "shiftrefresh.net", :primary => true       # This is where Rails migrations will run
set :keep_releases, 3

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    #run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

