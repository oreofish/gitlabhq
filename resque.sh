mkdir -p tmp/pids
kill `cat tmp/pids/resque-scheduler.pid`  `cat tmp/pids/resque_worker.pid`
sleep 5
nohup bundle exec rake environment resque:work QUEUE=post_receive,mailer,system_hook RAILS_ENV=production PIDFILE=tmp/pids/resque_worker.pid > ./log/resque.stdout.log 2>./log/resque.stderr.log  &
PIDFILE=tmp/pids/resque-scheduler.pid BACKGROUND=yes  bundle exec rake resque:scheduler
