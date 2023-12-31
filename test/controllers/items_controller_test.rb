require "test_helper"

class ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get item_index_url
    assert_response :success
  end

  test "should get new" do
    get item_new_url
    assert_response :success
  end

  test "should get create" do
    get item_create_url
    assert_response :success
  end

  test "should get edit" do
    get item_edit_url
    assert_response :success
  end

  test "should get update" do
    get item_update_url
    assert_response :success
  end

  test "should get destroy" do
    get item_destroy_url
    assert_response :success
  end
end
