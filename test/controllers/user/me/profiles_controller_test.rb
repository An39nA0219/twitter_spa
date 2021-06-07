require "test_helper"

class User::Me::ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_me_profiles_index_url
    assert_response :success
  end
end
