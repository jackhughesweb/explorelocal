class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

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

    FlickRaw.api_key = "420f3c8d48675ad2a67c191f7a126edf"
    FlickRaw.shared_secret = "121932a6dd63cfea"

    flickr = FlickRaw::Flickr.new
    info = flickr.photos.getInfo(:photo_id => @location1.clue_flickr)
    @location1_flickr_url = FlickRaw.url_b(info)

    info = flickr.photos.getInfo(:photo_id => @location2.clue_flickr)
    @location2_flickr_url = FlickRaw.url_b(info)

    info = flickr.photos.getInfo(:photo_id => @location3.clue_flickr)
    @location3_flickr_url = FlickRaw.url_b(info)

    info = flickr.photos.getInfo(:photo_id => @location4.clue_flickr)
    @location4_flickr_url = FlickRaw.url_b(info)
  end

  # GET /games/new
  def new
    @game = Game.new

    offset = (0..(Location.count - 1)).to_a.sample(5)
    @game.location1 = Location.first(:offset => offset[0]).id
    @game.location2 = Location.first(:offset => offset[1]).id
    @game.location3 = Location.first(:offset => offset[2]).id
    @game.location4 = Location.first(:offset => offset[3]).id
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
  end

  # GET /games/1/edit
  # def edit
  # end

  # PATCH/PUT /games/1
  # PATCH/PUT /games/1.json
  # def update
  #   respond_to do |format|
  #     if @game.update(game_params)
  #       format.html { redirect_to @game, notice: 'Game was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: 'edit' }
  #       format.json { render json: @game.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /games/1
  # DELETE /games/1.json
  # def destroy
  #   @game.destroy
  #   respond_to do |format|
  #     format.html { redirect_to games_url }
  #     format.json { head :no_content }
  #   end
  # end

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
end