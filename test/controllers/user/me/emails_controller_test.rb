require "test_helper"

class User::Me::EmailsControllerTest < ActionDispatch::IntegrationTest
  test "should get auth" do
    get user_me_emails_auth_url
    assert_response :success
  end

  test "should get update" do
    get user_me_emails_update_url
    assert_response :success
  end
end
