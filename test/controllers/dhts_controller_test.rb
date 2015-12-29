require 'test_helper'

class DhtsControllerTest < ActionController::TestCase
  setup do
    @dht = dhts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dhts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dht" do
    assert_difference('Dht.count') do
      post :create, dht: { chipid: @dht.chipid, description: @dht.description, humidity: @dht.humidity, location: @dht.location, temperature: @dht.temperature }
    end

    assert_redirected_to dht_path(assigns(:dht))
  end

  test "should show dht" do
    get :show, id: @dht
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dht
    assert_response :success
  end

  test "should update dht" do
    patch :update, id: @dht, dht: { chipid: @dht.chipid, description: @dht.description, humidity: @dht.humidity, location: @dht.location, temperature: @dht.temperature }
    assert_redirected_to dht_path(assigns(:dht))
  end

  test "should destroy dht" do
    assert_difference('Dht.count', -1) do
      delete :destroy, id: @dht
    end

    assert_redirected_to dhts_path
  end
end
