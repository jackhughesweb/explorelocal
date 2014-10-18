# Controller to manage game reports
class GameReportsController < ApplicationController
  before_action :set_game_report, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /game_reports
  # GET /game_reports.json
  def index
    @game_reports = GameReport.all
  end

  # GET /game_reports/1
  # GET /game_reports/1.json
  def show
  end

  # GET /game_reports/new
  def new
    @game_report = GameReport.new
  end

  # GET /game_reports/1/edit
  def edit
  end

  # POST /games/report
  def report
    @game_report = GameReport.new

    @game_report.location = params[:game_report_location]
    @game_report.radius = params[:game_report_radius]
    @game_report.message = params[:game_report_message]
    @game_report.name = params[:game_report_name]
    @game_report.email = params[:game_report_email]

    respond_to do |format|
      if @game_report.save
        format.json { render action: 'show', status: :created, location: @game_report }
      else
        format.json { render json: @game_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /game_reports
  # POST /game_reports.json
  def create
    @game_report = GameReport.new(game_report_params)

    respond_to do |format|
      if @game_report.save
        format.html { redirect_to @game_report, notice: 'Game report was successfully created.' }
        format.json { render action: 'show', status: :created, location: @game_report }
      else
        format.html { render action: 'new' }
        format.json { render json: @game_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /game_reports/1
  # PATCH/PUT /game_reports/1.json
  def update
    respond_to do |format|
      if @game_report.update(game_report_params)
        format.html { redirect_to @game_report, notice: 'Game report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_reports/1
  # DELETE /game_reports/1.json
  def destroy
    @game_report.destroy
    respond_to do |format|
      format.html { redirect_to game_reports_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game_report
      @game_report = GameReport.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_report_params
      params.require(:game_report).permit(:location, :radius, :message, :email)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["EL_USERNAME"] && password == ENV["EL_PASSWORD"]
      end
    end
end
