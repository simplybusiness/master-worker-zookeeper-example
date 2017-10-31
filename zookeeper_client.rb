require 'zookeeper'
require_relative 'zookeeper_client_configuration'
require_relative 'zookeeper_client_api_result'

module ZookeeperClient
  def self.included(base)
    base.include InstanceMethods
  end

  module InstanceMethods
    private

    def zk_create_node(options)
      ZookeeperClientApiResult.new(zookeeper_client.create(options))
    end

    def zookeeper_client
      @zookeeper_client ||= Zookeeper.new(zookeeper_client_configuration.servers)
    end

    def zookeeper_client_configuration
      ZookeeperClientConfiguration.instance
    end
  end
end
