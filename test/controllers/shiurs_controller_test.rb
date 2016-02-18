require 'test_helper'

class ShiursControllerTest < ActionController::TestCase
  setup do
    @shiur = shiurs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:shiurs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create shiur" do
    assert_difference('Shiur.count') do
      post :create, shiur: { category_id: @shiur.category_id, description: @shiur.description, location_link: @shiur.location_link, magid_id: @shiur.magid_id, name: @shiur.name, shiur_date: @shiur.shiur_date, subcat_id: @shiur.subcat_id }
    end

    assert_redirected_to shiur_path(assigns(:shiur))
  end

  test "should show shiur" do
    get :show, id: @shiur
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @shiur
    assert_response :success
  end

  test "should update shiur" do
    patch :update, id: @shiur, shiur: { category_id: @shiur.category_id, description: @shiur.description, location_link: @shiur.location_link, magid_id: @shiur.magid_id, name: @shiur.name, shiur_date: @shiur.shiur_date, subcat_id: @shiur.subcat_id }
    assert_redirected_to shiur_path(assigns(:shiur))
  end

  test "should destroy shiur" do
    assert_difference('Shiur.count', -1) do
      delete :destroy, id: @shiur
    end

    assert_redirected_to shiurs_path
  end
end
