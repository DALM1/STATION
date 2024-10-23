require "test_helper"

class DirectMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get direct_messages_index_url
    assert_response :success
  end

  test "should get create" do
    get direct_messages_create_url
    assert_response :success
  end
end
