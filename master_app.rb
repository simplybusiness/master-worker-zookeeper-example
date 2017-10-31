require_relative 'zookeeper_client'
require_relative 'zookeeper_client_watcher_callback'

class MasterApp
  MASTER_NODE = '/master'

  include ZookeeperClient

  attr_reader :mode

  def initialize
    self.mode = :not_connected
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

  def watch_for_failing_active
    watcher_callback = Zookeeper::Callbacks::WatcherCallback.create do |callback_object|
      callback_object = ZookeeperClientWatcherCallback.new(callback_object)

      if callback_object.node_deleted?(MASTER_NODE)
        result = register_as_active
        watch_for_failing_active unless result
      end
    end

    # TODO: Catch Error here? Think about wrapping call to ZookeeperClientApiResult and maybe put this
    # inside the `ZookeeperClient` module, by creating the method `zk_stat_node`
    zookeeper_client.stat(path: MASTER_NODE, watcher: watcher_callback)
  end

  private

  attr_writer :mode

  def create_ephemeral_node(node, data)
    zk_create_node(path: node, data: data.to_s, ephemeral: true)
  end
end
