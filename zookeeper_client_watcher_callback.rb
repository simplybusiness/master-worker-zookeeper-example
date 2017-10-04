class ZookeeperClientWatcherCallback
  def initialize(callback_object)
    @callback_object = callback_object
  end

  def node_deleted?(node)
    callback_object.type == Zookeeper::Constants::ZOO_DELETED_EVENT && callback_object.path == node
  end

  private

  attr_reader :callback_object
end
