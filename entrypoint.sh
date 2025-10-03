#!/bin/bash
set -e

cd /myapp

export BUNDLE_GEMFILE=/myapp/Gemfile
DB_HOST=${DB_HOST:-db}

echo "Waiting for database at $DB_HOST..."
i=0
until mysqladmin ping -h"$DB_HOST" --silent; do
  i=$((i+1))
  if [ $i -ge 60 ]; then
    echo "Database did not respond within 60 seconds."
    exit 1
  fi
  sleep 2
done

echo "Running migrations (if needed) and seeding..."
bin/rails db:migrate 2>/dev/null || bin/rails db:setup

exec "$@"
