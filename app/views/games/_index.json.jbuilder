json.array!(@games) do |game|
  json.extract! game, :id, :slug, :location1, :location2, :location3, :location4
  json.url game_url(game, format: :json)
end
