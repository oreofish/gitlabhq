mkdir -p tmp/pids
nohup bundle exec rake environment resque:work QUEUE=post_receive,mailer,system_hook RAILS_ENV=production PIDFILE=tmp/pids/resque_worker.pid > ./log/resque.stdout.log 2>./log/resque.stderr.log  &
PIDFILE=tmp/pids/resque-scheduler.pid BACKGROUND=yes  bundle exec rake resque:scheduler
