set :application, 'explorelocal'
set :repo_url, 'git@github.com:jackhughesweb/explorelocal.git'

set :branch, 'master'

set :deploy_to, '/home/deployer/apps/explorelocal'
set :scm, :git

# set :format, :pretty
# set :log_level, :debug
set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/home/deployer/.rbenv/bin:$PATH" }
set :keep_releases, 5

set :rvm_ruby_version, '2.1.2'

namespace :deploy do

  desc 'Setup config'
  task :setup_config do
    on roles(:app), in: :sequence, wait: 5 do
      execute :sudo, "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_explorelocal"
    end
  end

  desc 'Start application'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "#{current_path}/config/unicorn_init.sh start"
    end
  end

  desc 'Stop application'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "#{current_path}/config/unicorn_init.sh stop"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute "#{current_path}/config/unicorn_init.sh restart"
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  after :finishing, 'deploy:cleanup'

end
