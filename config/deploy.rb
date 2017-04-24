# config valid only for current version of Capistrano
lock "3.8.1"

set :application, 'disney_tour'
set :repo_url, 'git@github.com:snowhork/disney_tour.git'

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

set :rbenv_type, :user
set :rbenv_ruby, '2.3.1'

set :ssh_options, auth_methods: ['publickey']
    # keys: ['<EC2インスタンスのSSH鍵(pem)へのパス>']

set :unicorn_pid, -> { "#{shared_path}/tmp/pids/unicorn.pid" }
set :unicorn_config_path, -> { "#{current_path}/current/config/unicorn.rb" }

set :bundle_env_variables, { nokogiri_use_system_libraries: 1 }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end
end