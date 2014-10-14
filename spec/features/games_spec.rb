require 'rails_helper'

describe "games" do
  it "allows a game to be created" do
    location1 = Location.create!(:name => "location1", :latitude => 0.1, :longitude => 0.1, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location2 = Location.create!(:name => "location2", :latitude => 0.2, :longitude => 0.2, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location3 = Location.create!(:name => "location3", :latitude => 0.3, :longitude => 0.3, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location4 = Location.create!(:name => "location4", :latitude => 0.4, :longitude => 0.4, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location1.save
    location2.save
    location3.save
    location4.save

    game = Game.create!(:latitude => 0.1, :longitude => 0.1, :radius => 1000, :location1 => location1.id, :location2 => location2.id, :location3 => location3.id, :location4 => location4.id, :slug => "#{(0...3).map { ('a'..'z').to_a[rand(26)] }.join}#{Game.count + 1}#{(0...2).map { ('a'..'z').to_a[rand(26)] }.join}")
    game.save
  end
  it "should display JSON data" do
    location1 = Location.create!(:name => "location1", :latitude => 0.1, :longitude => 0.1, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location2 = Location.create!(:name => "location2", :latitude => 0.2, :longitude => 0.2, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location3 = Location.create!(:name => "location3", :latitude => 0.3, :longitude => 0.3, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location4 = Location.create!(:name => "location4", :latitude => 0.4, :longitude => 0.4, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location1.save
    location2.save
    location3.save
    location4.save

    game = Game.create!(:latitude => 0.1, :longitude => 0.1, :radius => 1000, :location1 => location1.id, :location2 => location2.id, :location3 => location3.id, :location4 => location4.id, :slug => "#{(0...3).map { ('a'..'z').to_a[rand(26)] }.join}#{Game.count + 1}#{(0...2).map { ('a'..'z').to_a[rand(26)] }.join}")
    game.save

    visit "/games/#{game.slug}.json"
    expect(page).to have_http_status(:success)
  end
end
