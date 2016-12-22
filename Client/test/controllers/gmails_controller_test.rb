require 'test_helper'

class GmailsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @gmail = gmails(:one)
  end

  test "should get index" do
    get gmails_url
    assert_response :success
  end

  test "should get new" do
    get new_gmail_url
    assert_response :success
  end

  test "should create gmail" do
    assert_difference('Gmail.count') do
      post gmails_url, params: { gmail: { email: @gmail.email, gmailemail: @gmail.gmailemail, gmailpass: @gmail.gmailpass } }
    end

    assert_redirected_to gmail_url(Gmail.last)
  end

  test "should show gmail" do
    get gmail_url(@gmail)
    assert_response :success
  end

  test "should get edit" do
    get edit_gmail_url(@gmail)
    assert_response :success
  end

  test "should update gmail" do
    patch gmail_url(@gmail), params: { gmail: { email: @gmail.email, gmailemail: @gmail.gmailemail, gmailpass: @gmail.gmailpass } }
    assert_redirected_to gmail_url(@gmail)
  end

  test "should destroy gmail" do
    assert_difference('Gmail.count', -1) do
      delete gmail_url(@gmail)
    end

    assert_redirected_to gmails_url
  end
end
