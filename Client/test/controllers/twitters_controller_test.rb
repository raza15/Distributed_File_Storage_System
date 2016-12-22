require 'test_helper'

class TwittersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @twitter = twitters(:one)
  end

  test "should get index" do
    get twitters_url
    assert_response :success
  end

  test "should get new" do
    get new_twitter_url
    assert_response :success
  end

  test "should create twitter" do
    assert_difference('Twitter.count') do
      post twitters_url, params: { twitter: { email: @twitter.email, twitteremail: @twitter.twitteremail, twitterpass: @twitter.twitterpass } }
    end

    assert_redirected_to twitter_url(Twitter.last)
  end

  test "should show twitter" do
    get twitter_url(@twitter)
    assert_response :success
  end

  test "should get edit" do
    get edit_twitter_url(@twitter)
    assert_response :success
  end

  test "should update twitter" do
    patch twitter_url(@twitter), params: { twitter: { email: @twitter.email, twitteremail: @twitter.twitteremail, twitterpass: @twitter.twitterpass } }
    assert_redirected_to twitter_url(@twitter)
  end

  test "should destroy twitter" do
    assert_difference('Twitter.count', -1) do
      delete twitter_url(@twitter)
    end

    assert_redirected_to twitters_url
  end
end
