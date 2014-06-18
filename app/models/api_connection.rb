class ApiConnection
  def initialize(name, options = {})
    @name = name
    @options = options
  end

  def klass_name
    (@options['source'] + '_connection').camelize
  end

  def execute(query, options = {})
    klass.execute(query, options)
  end

  def klass
    @klass ||= klass_name.constantize.new(@options)
  end
end
