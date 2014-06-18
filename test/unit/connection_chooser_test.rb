require 'test_helper'

class ConnectionChooserTest < ActiveSupport::TestCase
  context "Connection Chooser" do
    setup do
      @creds = { "type"=>"db", "adapter"=>"postgresql", "database"=>"campaign_finance", "username"=>nil, "password"=>nil, "host"=>"localhost", "port"=>5432, "pool"=>5}
      ConnectionChooser.any_instance.stubs(:settings).returns(@creds)
      @chooser = ConnectionChooser.new('test_source')
    end

    should "#klass_name should be correct" do
      assert_equal "TestSourceConnection", @chooser.klass_name
    end

    # Note, this is testing the mock, not the YAML::load
    should "have the correct settings" do
      assert_equal @creds, @chooser.settings
    end

    should "have the correct credentials" do
      db_credentials = {"adapter"=>"postgresql", "database"=>"campaign_finance", "username"=>nil, "password"=>nil, "host"=>"localhost", "port"=>5432, "pool"=>5}
      assert_equal db_credentials, @chooser.credentials
    end

    should "have the correct type" do
      assert_equal "db", @chooser.type
    end
  end

end
