require 'zookeeper'
require 'zookeeper_client_configuration'
require 'zookeeper_client_api_result'
require 'zookeeper_client_watcher_callback'

class MasterApp
  MASTER_NODE = '/master'

  attr_reader :mode

  def initialize
    self.mode = :not_connected
  end

  def connect_to_zk
    @zookeeper_client = Zookeeper.new(zookeeper_client_configuration.servers)
  end

  def register_as_active
    result = create_ephemeral_node(MASTER_NODE, Process.pid)
    if result.no_error?
      self.mode = :active
      true
    elsif result.node_already_exists?
      self.mode = :standby
      false
    else
      raise "ERROR: Cannot start master app: #{result.inspect}"
    end
  end

  def watch_for_failing_master
    watcher_callback = Zookeeper::Callbacks::WatcherCallback.create do |callback_object|
      callback_object = ZookeeperClientWatcherCallback.new(callback_object)

      if callback_object.node_deleted?(MASTER_NODE)
        result = register_as_active
        watch_for_failing_master unless result
      end
    end

    zookeeper_client.stat(path: MASTER_NODE, watcher: watcher_callback)
  end

  private

  attr_reader :zookeeper_client
  attr_writer :mode

  def zookeeper_client_configuration
    ZookeeperClientConfiguration.instance
  end

  def create_ephemeral_node(node, data)
    ZookeeperClientApiResult.new(zookeeper_client.create(path: node, data: data.to_s, ephemeral: true))
  end
end
