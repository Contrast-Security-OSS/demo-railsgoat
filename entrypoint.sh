rm -f tmp/pids/server.pid
if [[ $TEST = true ]] 
then
    bundle exec rails training
else 
    bundle exec rails s -p 3000 -b '0.0.0.0'
fi