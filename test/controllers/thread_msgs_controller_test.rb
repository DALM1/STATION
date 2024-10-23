require "test_helper"

class ThreadMsgsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get thread_msgs_create_url
    assert_response :success
  end
end
