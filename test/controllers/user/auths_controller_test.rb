require "test_helper"

class User::AuthsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_auths_create_url
    assert_response :success
  end
end
