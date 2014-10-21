require 'rails_helper'

describe "locations" do
  it "returns a JSON object of Wikipedia articles" do
    visit "/locations/wikisearch.json?search=Worcester%20Cathedral"
    authorize 'admin', 'admin'
    expect(page).to have_http_status(:success)
  end
  it "returns a JSON object of Wikipedia text" do
    visit "/locations/wikitext.json?search=Worcester%20Cathedral"
    authorize 'admin', 'admin'
    expect(page).to have_http_status(:success)
  end
end
