# 1. Tries to register as master by creating an ephemeral node /master.
# 2. If a master is already registered, it watches the /master (hence being a stand-by master)
# 3. When it is a stand-by master and receives notification about a change, "/master" deleted,
#    then it goes back to step [1]

# ... rest of the functionality will be described later on ...

require_relative 'master_app'

master_app = MasterApp.new

while true
  sleep 3
  puts "I am #{master_app.mode} master"
end
