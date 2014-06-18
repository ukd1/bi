require 'test_helper'

class KpiResultTest < ActiveSupport::TestCase
  context "kpi result tests" do
    setup do
      @kpi_result_params = {
        :today            => "50",
        :today_pct_change => "3.4542343",
        :t7days           => "350",
        :t30days          => "1500",
        :qtd              => "3000",
        :ytd              => "6000"
      }
      @result = KpiResult.new(@kpi_result_params)
    end

    context "kpi result creation" do
      should "save correctly" do
        assert @result.valid?
        assert @result.save!
      end
    end

    context "humanize" do
      setup do
        @result.stubs(:kpi => stub(:rate? => false))
      end
      should "humanize a percentile" do
        assert_equal @result.humanize("today_pct_change"), "3.45%"
      end

      should "humanize a regular value" do
        assert_equal "1,500", @result.humanize("t30days")
      end
    end
  end
end
