require 'test_helper'

class UploadFileToServersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @upload_file_to_server = upload_file_to_servers(:one)
  end

  test "should get index" do
    get upload_file_to_servers_url
    assert_response :success
  end

  test "should get new" do
    get new_upload_file_to_server_url
    assert_response :success
  end

  test "should create upload_file_to_server" do
    assert_difference('UploadFileToServer.count') do
      post upload_file_to_servers_url, params: { upload_file_to_server: { email: @upload_file_to_server.email, filename: @upload_file_to_server.filename } }
    end

    assert_redirected_to upload_file_to_server_url(UploadFileToServer.last)
  end

  test "should show upload_file_to_server" do
    get upload_file_to_server_url(@upload_file_to_server)
    assert_response :success
  end

  test "should get edit" do
    get edit_upload_file_to_server_url(@upload_file_to_server)
    assert_response :success
  end

  test "should update upload_file_to_server" do
    patch upload_file_to_server_url(@upload_file_to_server), params: { upload_file_to_server: { email: @upload_file_to_server.email, filename: @upload_file_to_server.filename } }
    assert_redirected_to upload_file_to_server_url(@upload_file_to_server)
  end

  test "should destroy upload_file_to_server" do
    assert_difference('UploadFileToServer.count', -1) do
      delete upload_file_to_server_url(@upload_file_to_server)
    end

    assert_redirected_to upload_file_to_servers_url
  end
end
