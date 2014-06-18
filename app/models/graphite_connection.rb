class GraphiteConnection
  def initialize(options = {})
    @connection_options = options
  end

  def execute(query, query_options = {})
    result = ActiveSupport::JSON.decode(Typhoeus::Request.get(query).body).first
    format_results(result)
  end

  def format_results(result, query_options = {})
    formatted = []
    result['datapoints'].each do |d|
      formatted << {"target" => result['target'], "time" => Time.at(d[1]), "result" => d[0] }
    end
    QueryResultPresenter::Presenter.new(formatted)
  end
end
