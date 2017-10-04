require 'singleton'
require 'yaml'

class ZookeeperClientConfiguration
  include Singleton

  def servers
    config['zookeeper']['servers'].join(',')
  end

  def config
    @config ||= YAML.load_file(config_file)
  end

  def config_file
    File.join(File.expand_path('..', __FILE__), 'config', 'app.yml')
  end
end
