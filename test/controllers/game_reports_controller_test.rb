require 'test_helper'

class GameReportsControllerTest < ActionController::TestCase
  setup do
    @game_report = game_reports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_reports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_report" do
    assert_difference('GameReport.count') do
      post :create, game_report: { email: @game_report.email, location: @game_report.location, message: @game_report.message, radius: @game_report.radius }
    end

    assert_redirected_to game_report_path(assigns(:game_report))
  end

  test "should show game_report" do
    get :show, id: @game_report
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_report
    assert_response :success
  end

  test "should update game_report" do
    patch :update, id: @game_report, game_report: { email: @game_report.email, location: @game_report.location, message: @game_report.message, radius: @game_report.radius }
    assert_redirected_to game_report_path(assigns(:game_report))
  end

  test "should destroy game_report" do
    assert_difference('GameReport.count', -1) do
      delete :destroy, id: @game_report
    end

    assert_redirected_to game_reports_path
  end
end
