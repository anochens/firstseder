require 'test_helper'

class MagidsControllerTest < ActionController::TestCase
  setup do
    @magid = magids(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:magids)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create magid" do
    assert_difference('Magid.count') do
      post :create, magid: { name: @magid.name }
    end

    assert_redirected_to magid_path(assigns(:magid))
  end

  test "should show magid" do
    get :show, id: @magid
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @magid
    assert_response :success
  end

  test "should update magid" do
    patch :update, id: @magid, magid: { name: @magid.name }
    assert_redirected_to magid_path(assigns(:magid))
  end

  test "should destroy magid" do
    assert_difference('Magid.count', -1) do
      delete :destroy, id: @magid
    end

    assert_redirected_to magids_path
  end
end
