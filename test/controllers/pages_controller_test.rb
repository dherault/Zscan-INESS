require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get admin_panel" do
    get :admin_panel
    assert_response :success
  end

end
