require "test_helper"

class User::Me::TweetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_me_tweets_index_url
    assert_response :success
  end
end
