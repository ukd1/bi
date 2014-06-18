class ConnectionChooser
  def initialize(source_name)
    @source = source_name
  end

  def klass_name
    (@source + '_connection').camelize
  end

  def connection
    if type == "db"
      database_connection
    elsif type == "api"
      api_connection
    end
  end

  def execute(query, query_options = {})
    connection.execute(query, query_options)
  end

  def settings
    @settings ||= YAML::load_file("#{Rails.root}/config/data_sources.yml")['sources']["#{@source}"]
  end

  def credentials
    settings.except('type')
  end

  def type
    settings.fetch('type')
  end

  def database_connection
    @db_connection ||= DbConnection.new(klass_name, credentials)
  end

  def api_connection
    @api_connection ||= ApiConnection.new(klass_name, credentials)
  end

end
