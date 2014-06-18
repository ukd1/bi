module ApplicationHelper
  def data_source_options
    YAML::load_file("#{Rails.root}/config/data_sources.yml")['sources'].keys
  end
end
