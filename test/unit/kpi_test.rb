require 'test_helper'

class KpiTest < ActiveSupport::TestCase
  context "kpi creation" do
    setup do
      @kpi_hash = {
        :name     => "test query",
        :query    => "SELECT o.id FROM orders o LIMIT 1"
      }
    end

    should "be a valid kpi" do
      kpi = Kpi.new(@kpi_hash)
      assert kpi.valid?
      assert kpi.save!
    end

  end

end
