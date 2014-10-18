# Controller to manage game creation and plays
class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate, only: [:index, :edit, :update, :destroy]
  before_filter :check_game_valid, only: [:create, :check_game]

  # GET /games
  # GET /games.json
  def index
    @games = Game.all
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @location1 = Location.find(@game.location1)
    @location2 = Location.find(@game.location2)
    @location3 = Location.find(@game.location3)
    @location4 = Location.find(@game.location4)

    require 'flickraw'

    FlickRaw.api_key = ENV["EL_FLICKR_API"]
    FlickRaw.shared_secret = ENV["EL_FLICKR_API_SECRET"]

    flickr = FlickRaw::Flickr.new
    info = flickr.photos.getInfo(:photo_id => @location1.clue_flickr)
    @location1_flickr_url = FlickRaw.url_b(info)
    @location1_flickr_page = info.urls[0]._content

    info = flickr.photos.getInfo(:photo_id => @location2.clue_flickr)
    @location2_flickr_url = FlickRaw.url_b(info)
    @location2_flickr_page = info.urls[0]._content

    info = flickr.photos.getInfo(:photo_id => @location3.clue_flickr)
    @location3_flickr_url = FlickRaw.url_b(info)
    @location3_flickr_page = info.urls[0]._content

    info = flickr.photos.getInfo(:photo_id => @location4.clue_flickr)
    @location4_flickr_url = FlickRaw.url_b(info)
    @location4_flickr_page = info.urls[0]._content
  end

  # GET /games/new
  def new
    @game = Game.new
  end

  # POST /games
  def create   
    if (@locations_nearby_count > 3)
      @locations = Location.near(params[:game_new_location], params[:game_new_radius])

      @game = Game.new

      @game.latitude = Geocoder.search(params[:game_new_location])[0].latitude
      @game.longitude = Geocoder.search(params[:game_new_location])[0].longitude
      @game.radius = params[:game_new_radius]

      offset = (0..(@locations.count(:all) - 1)).to_a.sample(5)

      @game.location1 = @locations[offset[0]].id
      @game.location2 = @locations[offset[1]].id
      @game.location3 = @locations[offset[2]].id
      @game.location4 = @locations[offset[3]].id
      @game.slug = "#{(0...3).map { ('a'..'z').to_a[rand(26)] }.join}#{Game.count + 1}#{(0...2).map { ('a'..'z').to_a[rand(26)] }.join}"

      respond_to do |format|
        if @game.save
          format.html { redirect_to @game, notice: 'Game was successfully created.' }
          format.json { render action: 'show', status: :created, location: @game }
        else
          format.html { render action: 'new' }
          format.json { render json: @game.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to new_game_path, notice: 'Not enough locations to create a game.' }
        format.json { render json: { :error => 'Search scope too small'}, status: :unprocessable_entity }
      end
    end
  end

  # GET /games/1/edit
  # Used before creating a new game to check if the new game would be valid
  def check_game
    if (@locations_nearby_count > 3)
      @message = true
    else 
      @message = false
    end
  end

  # GET /games/1/edit
  def edit
  end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def game_params
      params.require(:game)
      # .permit(:slug, :location1, :location2, :location3, :location4)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == ENV["EL_USERNAME"] && password == ENV["EL_PASSWORD"]
      end
    end

    def check_game_valid
      locations_nearby = Location.near(params[:game_new_location], params[:game_new_radius])
      @locations_nearby_count = locations_nearby.count(:all)
    end
end
