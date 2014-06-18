ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/autorun'
require 'minitest/display'
require 'shoulda'
require 'mocha/setup'
require 'pry'
# require 'paperless-devtools/env'


class ActiveSupport::TestCase
end
