require 'rails_helper'

describe "locations" do
  it "allows a location to be created" do
    location = Location.create!(:name => "location1", :latitude => 0.1, :longitude => 0.1, :clue_flickr => "text", :clue_wikipedia_link => "text", :clue_wikipedia_text => "text")
    location.save
  end
  it "returns a JSON object of Wikipedia articles" do
    page.driver.browser.authorize('admin', 'admin')
    visit "/locations/wikisearch.json?search=Worcester%20Cathedral"
    expect(page).to have_http_status(:success)
  end
  it "returns a JSON object of Wikipedia text" do
    page.driver.browser.authorize('admin', 'admin')
    visit "/locations/wikitext.json?search=Worcester%20Cathedral"
    expect(page).to have_http_status(:success)
  end
end
