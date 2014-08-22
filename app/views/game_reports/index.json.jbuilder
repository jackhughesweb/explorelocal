json.array!(@game_reports) do |game_report|
  json.extract! game_report, :id, :location, :radius, :message, :email
  json.url game_report_url(game_report, format: :json)
end
