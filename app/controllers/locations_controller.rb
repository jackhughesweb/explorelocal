class LocationsController < ApplicationController
  before_action :set_location, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate

  include ActionView::Helpers::SanitizeHelper

  # GET /locations
  # GET /locations.json
  def index
    @locations = Location.search(params[:search]).paginate(:page => params[:page], :per_page => 3)
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

  # GET /locations/flickr.json
  def flickr
    require 'flickraw'

    FlickRaw.api_key = ENV["EL_FLICKR_API"]
    FlickRaw.shared_secret = ENV["EL_FLICKR_API_SECRET"]

    @page = params[:page] || 1;

    flickr = FlickRaw::Flickr.new
    @search = flickr.photos.search(:text => params[:search], :license => '1,2,3,4,5,6,7', :sort => 'relevance', :per_page => 10, :page => @page)
  end

  def wikisearch
    # url = HTTParty.get("https://en.wikipedia.org/w/api.php",
    #     :headers => { 'ContentType' => 'application/json' }, :query => {:action => 'opensearch', :search => params[:search], :limit => 5, :namespace => 0, :format => 'json'} )
    # response = JSON.parse(url.body)
    # @articles = response[1]

    url = HTTParty.get("https://en.wikipedia.org/w/api.php",
        :headers => { 'ContentType' => 'application/json' }, :query => {:action => 'query', :list => 'search', :srsearch => params[:search], :srlimit => 5, :format => 'json'} )
    response = JSON.parse(url.body)
    @articles = response["query"]["search"]
  end

  def wikitext
    url = HTTParty.get("https://en.wikipedia.org/w/api.php",
        :headers => { 'ContentType' => 'application/json' }, :query => {:action => 'query', :titles => params[:search], :prop => 'extracts|info', :inprop => 'url', :format => 'json'} )
    response = JSON.parse(url.body)
    @query = response["query"]["pages"][response["query"]["pages"].first(1)[0][0]]
    @url = @query["fullurl"]

    require 'nokogiri'
    doc = Nokogiri::HTML(@query["extract"])

    @htmltext = ''

    doc.css('p').each do |para|
      @htmltext << para.content
      @htmltext << ' '
    end
    @text = sanitize(@htmltext, :tags=>[]).gsub(/[t]he #{params[:search]}/, '[the location]').gsub(/[T]he #{params[:search]}/, '[The location]').gsub(/\. #{params[:search]}/, '. [The location]').gsub(/^#{params[:search]}/, '[The location]').gsub(/#{params[:search]}/, '[the location]').truncate(1000, separator: '.', omission: '.')
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
