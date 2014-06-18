require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  context "Index" do

    should  "be successful" do
      get :index
      assert_response :success
    end    
  end
end