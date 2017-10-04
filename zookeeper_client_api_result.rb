class ZookeeperClientApiResult
  def initialize(result)
    @result = result
  end

  def request_id
    result[:req_id]
  end

  alias :req_id :request_id

  def node_already_exists?
    result[:rc] == Zookeeper::Constants::ZNODEEXISTS
  end

  def no_error?
    result[:rc] == 0
  end

  attr_reader :result
end
