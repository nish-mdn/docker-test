#!/bin/bash
set -e

cd /myapp

export BUNDLE_GEMFILE=/myapp/Gemfile
#DB_HOST=${DB_HOST:-db}

# echo "Waiting for database at $DB_HOST..."
# i=0
# until mysqladmin ping -h"$DB_HOST" --silent; do
#   i=$((i+1))
#   if [ $i -ge 60 ]; then
#     echo "Database did not respond within 60 seconds."
#     exit 1
#   fi
#   sleep 2
# done
echo "ruby version"
ruby -v
echo "rails version"
rails -v
echo "bundler version"
bundle --version
echo "Running migrations (if needed) and seeding..."
bundle exec rails db:migrate 2>/dev/null || bundle exec rails db:setup

exec "$@"
