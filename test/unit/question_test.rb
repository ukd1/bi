require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  context "valid question" do
    setup do
      params = {
        :name => "Test Query",
        :description => "Describe the query",
        :question_sql => "SELECT e.name as name
                          , e.created_at as created_at
                          FROM events e
                          WHERE e.created_at BETWEEN '<%= start_date %>' AND '<%= end_date %>'
                          LIMIT <%= limit %>",
      }
      @question = Question.new(params)
    end

    should "be valid" do
      assert @question.valid?
    end

    should "have the right inputs" do
      assert_same_elements ['start_date', 'end_date', 'limit'], @question.inputs
    end

    should "build the sql correctly" do
      inputs = {:start_date => '1/1/2013', :end_date => '2/1/2013', :limit => 10}
      actual_sql = "SELECT e.name as name
                    , e.created_at as created_at
                    FROM events e
                    WHERE e.created_at BETWEEN '1/1/2013' AND '2/1/2013'
                    LIMIT 10"
      assert_equal actual_sql.gsub(/\s+/,""), @question.build_sql(inputs).gsub(/\s+/,"")
    end

  end
  context "correct output field parsing - " do
    context "simple case" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Simple query',
          :question_sql => "SELECT id as Account_ID
                            , accounts.registered_at
                            FROM accounts
                            WHERE registered > '2014-01-01'
                            LIMIT 10"
        }
        @question = Question.new(params)
      end

      should 'have the right fields' do
        assert_same_elements ['account_id', 'registered_at'], @question.fields
      end
    end
    context "handle WITH subquery in parens" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Simple query',
          :question_sql => "WITH temp AS (
                            SELECT id
                            , registered_at
                            , created_at
                            FROM accounts
                            WHERE registered > '2014-01-01'
                            )

                            SELECT id as account_id
                            , temp.registered_at
                            FROM temp
                            LIMIT 10"
        }
        @question = Question.new(params)
      end

      should 'have the right fields' do
        assert_same_elements ['account_id', 'registered_at'], @question.fields
      end
    end
    context "handle subqueries in parens" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Simple query',
          :question_sql => "SELECT id as account_id
                            , temp.registered_at
                            FROM (
                            SELECT id, registered_at
                            FROM accounts
                            WHERE registered > '2014-01-01'
                            ) temp
                            LIMIT 10"
        }
        @question = Question.new(params)
      end

      should 'have the right fields' do
        assert_same_elements ['account_id', 'registered_at'], @question.fields
      end
    end
    context "handle nested parens" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Simple query',
          :question_sql => "SELECT SUM(COALESCE(points, 0))
                            FROM accounts
                            WHERE registered > '2014-01-01'
                            LIMIT 10"
        }
        @question = Question.new(params)
      end

      should 'have the right fields' do
        assert_same_elements ['sum'], @question.fields
      end
    end
    context "handle ERB blocks" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Simple query',
          :question_sql => "select date_trunc('<%= group_by_range %>', registered_at) as <%= group_by_range %>
                            , Count(*)
                            from accounts
                            where registered_at between '<%= start_date %>' and '<%= end_date %>'
                            group by <%= group_by_range %>
                            order by <%= group_by_range %> desc"
        }
        @question = Question.new(params)
      end

      should 'have the right fields' do
        assert_same_elements ['group_by_range', 'count'], @question.fields
      end
    end
    context "total case" do
      setup do
        params = {
          :name => 'Test Query',
          :description => 'Worst query',
          :question_sql => "WITH temp_table as (
                              SELECT DISTINCT ON (account_id)
                              MAX(subject) OVER (PARTITION BY (account_id / 10)) AS fake_field
                              , coins AS fake_field2
                              FROM events
                              WHERE sent_at BETWEEN '<%= start_date %>' AND '<%= end_date %>'
                              ORDER BY account_id
                            )

                            SELECT SUBSTRING(SUBSTRING(fake_field FROM 'ofiaw')
                                             FROM 'owiej') AS <%= group_by_range %>
                            , COUNT(*) AS count
                            , COUNT(DISTINCT fake_field) AS dogblob
                            , fake_field2 AS blobdog
                            FROM temp_table
                            GROUP BY <%= group_by_range %>
                            ORDER BY <%= group_by_range %> DESC

                            UNION ALL

                            SELECT SUBSTRING(SUBSTRING(fake_field FROM 'ofiaw')
                                             FROM 'owiej') AS <%= group_by_range %>
                            , COUNT(*) AS count2
                            , COUNT(DISTINCT fake_field)
                            , temp_table2.fake_field2
                            FROM (
                              SELECT DISTINCT ON (account_id)
                              MAX(subject) OVER (PARTITION BY (account_id / 10)) AS fake_field
                              , coins AS fake_field2
                              FROM events
                              WHERE sent_at BETWEEN '<%= start_date %>' AND '<%= end_date %>'
                              ORDER BY account_id) temp_table2
                            GROUP BY <%= group_by_range %>
                            ORDER BY <%= group_by_range %> DESC"
        }
        @question = Question.new(params)
      end

      should "have the right fields" do
        assert_same_elements ['group_by_range', 'count2', 'count', 'fake_field2'], @question.fields
      end
    end
  end
  context "allow for optional clauses" do
    setup do
      params = {
        :name => "Test Query",
        :description => "Describe the query",
        :question_sql => "SELECT e.name as name
                          , e.created_at as created_at
                          FROM events e
                          WHERE e.created_at BETWEEN '<%= start_date %>' AND '<%= end_date %>'
                          <% if !name.empty? %>
                          AND e.name = '<%= name %>'
                          <% end %>
                          LIMIT <%= limit %>"

      }
      @question_with_options = Question.new(params)
    end

    should "build the sql correctly with the param" do
      inputs = {:start_date => '1/1/2013', :end_date => '2/1/2013', :limit => 10, :name => 'bob'}
      actual_sql = "SELECT e.name as name
                    , e.created_at as created_at
                    FROM events e
                    WHERE e.created_at BETWEEN '1/1/2013' AND '2/1/2013'
                    AND e.name = 'bob'
                    LIMIT 10"
      assert_equal actual_sql.gsub(/\s+/,""), @question_with_options.build_sql(inputs).gsub(/\s+/,"")
    end

    should "build the sql correctly without the param" do
      inputs = {:start_date => '1/1/2013', :end_date => '2/1/2013', :limit => 10, :name => ''}
      actual_sql = "SELECT e.name as name
                    , e.created_at as created_at
                    FROM events e
                    WHERE e.created_at BETWEEN '1/1/2013' AND '2/1/2013'
                    LIMIT 10"
      assert_equal actual_sql.gsub(/\s+/,""), @question_with_options.build_sql(inputs).gsub(/\s+/,"")
    end
  end
end
