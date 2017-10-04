# 1. Tries to register as master by creating an ephemeral node /master.
# 2. If a master is already registered, it watches the /master (hence being a stand-by master)
# 3. When it is a stand-by master and receives notification about a change, "/master" deleted,
#    then it goes back to step [1]

# ... rest of the functionality will be described later on ...

$LOAD_PATH.unshift('.')

require 'master_app'

master_app = MasterApp.new
master_app.connect_to_zk
result = master_app.register_as_active
master_app.watch_for_failing_master unless result
while true
  sleep 3
  puts "I am #{master_app.mode} master"
end
