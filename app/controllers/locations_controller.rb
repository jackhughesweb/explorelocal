class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.paginate(:page => params[:page], :per_page => 3)
  end

  # GET /locations/1
  # GET /locations/1.json
  def show
    require 'flickraw'

    FlickRaw.api_key = ENV["EL_FLICKR_API"]
    FlickRaw.shared_secret = ENV["EL_FLICKR_API_SECRET"]

    flickr = FlickRaw::Flickr.new
    info = flickr.photos.getInfo(:photo_id => @location.clue_flickr)
    @location_flickr_url = FlickRaw.url_b(info)
  end

  # GET /locations/new
  def new
    @location = Location.new
  end

  # GET /locations/1/edit
  def edit
  end

  # POST /locations
  # POST /locations.json
  def create
    @location = Location.new(location_params)

    respond_to do |format|
      if @location.save
        format.html { redirect_to @location, notice: 'Location was successfully created.' }
        format.json { render action: 'show', status: :created, location: @location }
      else
        format.html { render action: 'new' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /locations/1
  # PATCH/PUT /locations/1.json
  def update
    respond_to do |format|
      if @location.update(location_params)
        format.html { redirect_to @location, notice: 'Location was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @location.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.json
  def destroy
    @location.destroy
    respond_to do |format|
      format.html { redirect_to locations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location = Location.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_params
      params.require(:location).permit(:latitude, :longitude, :name, :clue_flickr, :clue_wikipedia_link, :clue_wikipedia_text)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["EL_USERNAME"] && password == ENV["EL_PASSWORD"]
      end
    end
end
