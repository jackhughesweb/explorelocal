require 'rails_helper'

describe "locations" do
  it "returns a JSON object of Wikipedia articles" do
    page.driver.browser.authorize 'admin', 'admin'
    visit "/locations/wikisearch.json?search=Worcester%20Cathedral"
    expect(page).to have_http_status(:success)
  end
  it "returns a JSON object of Wikipedia text" do
    page.driver.browser.authorize 'admin', 'admin'
    visit "/locations/wikitext.json?search=Worcester%20Cathedral"
    expect(page).to have_http_status(:success)
  end
end
