# Model for Locations
class Location < ActiveRecord::Base
  reverse_geocoded_by :latitude, :longitude

  # Location Search
  # Accessed by calling Location.search
  def self.search(search)
    if search
      self.where("name like ?", "%" + search + "%")
    else
      self.all
    end
  end
end
