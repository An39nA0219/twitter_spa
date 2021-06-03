require "test_helper"

class User::TweetsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_tweets_index_url
    assert_response :success
  end

  test "should get show" do
    get user_tweets_show_url
    assert_response :success
  end
end
