require_relative 'zookeeper_client'

class TaskProducerApp
  WORKERS_NODE = '/workers'
  TASKS_NODE = '/tasks'
  ASSIGNMENTS_NODE = '/assignments'

  include ZookeeperClient

  class CreatingMainNodesException < RuntimeError; end

  def initialize
    [WORKERS_NODE, TASKS_NODE, ASSIGNMENTS_NODE].each do |node|
      result = zk_create_node(path: node)
      raise CreatingMainNodesException, "Problem creating node: #{node}" unless result.no_error? || result.node_already_exists?
    end
  end
end

