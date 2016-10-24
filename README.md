# README

it acts like a reverse proxy for any request, calling localhost:3000 (it's hardcoded)

## How to run it

bundle install

bundle exec puma -R config.ru -p <port>
