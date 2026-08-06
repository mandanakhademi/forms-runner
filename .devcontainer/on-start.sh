#!/bin/bash

# Start services
service postgresql start || true
service redis-server start || true

# Fix Postgres password for Rails TCP auth
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';" || true

# Remove old PID files to prevent EADDRINUSE / server start blocks
rm -f /workspaces/forms-runner/tmp/pids/server.pid
rm -f /workspaces/forms-admin/tmp/pids/server.pid

# Start forms-runner (Port 3001)
mkdir -p /workspaces/forms-runner/log
nohup bash -c 'bin/rails server -b 0.0.0.0 -p 3001' > /workspaces/forms-runner/log/server.log 2>&1 &

# Start forms-admin (Port 3000)
if [ -d /workspaces/forms-admin ]; then
  cd /workspaces/forms-admin
  mkdir -p log
  nohup bash -c 'bin/rails server -b 0.0.0.0 -p 3000' > log/server.log 2>&1 &
fi