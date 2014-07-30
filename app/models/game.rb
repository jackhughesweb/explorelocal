class Game < ActiveRecord::Base
  include FriendlyId
  friendly_id :slug
end
