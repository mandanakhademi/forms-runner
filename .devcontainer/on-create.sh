#!/bin/bash
set -e

# 1. Start services and set Postgres password
service postgresql start || true
service redis-server start || true
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" || true

# 2. Setup forms-runner
cd /workspaces/forms-runner
bundle install
bin/rails db:create db:schema:load
npm install
bin/vite build

# 3. Clone and setup forms-admin if present
if [ ! -d /workspaces/forms-admin ]; then
  git clone https://github.com/mandanakhademi/forms-admin.git /workspaces/forms-admin
fi

cd /workspaces/forms-admin
bundle install
bin/rails db:create db:schema:load db:seed
npm install
bin/vite build