# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'
#require 'resque'
#require 'resque_scheduler'
#require 'resque/scheduler'

namespace :resque do
  task setup: :environment do
    Resque.before_fork = Proc.new { ActiveRecord::Base.establish_connection }
    #Resque.redis = 'localhost:6379'
    #Resque.schedule = YAML.load_file("#{Rails.root}/config/resque_schedule.yml")
  end

  desc "Resque | kill all workers (using -QUIT), god will take care of them"
  task :stop_workers => :environment do
    pids = Array.new

    Resque.workers.each do |worker|
      pids << worker.to_s.split(/:/).second
    end

    if pids.size > 0
      system("kill -QUIT #{pids.join(' ')}")
    end
  end
end

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"
