require 'rails_helper'

describe "locations" do
  it "returns a JSON object of Wikipedia articles" do
    visit "/locations/wikisearch.json?search=Worcester%20Cathedral"
    expect(page).to have_http_status(:success)
  end
end
