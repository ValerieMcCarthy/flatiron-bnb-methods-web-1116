class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods


 def city_openings(start_date, end_date)
  	#knows all available listings given a date range
  	open_listings = []
  	start_date = start_date.to_date
  	end_date = end_date.to_date
  	
  	listings.each do |listing|
  		available = true
  		listing.reservations.each do |reservation|
  			if (start_date - reservation.checkout) * (reservation.checkin - end_date) >= 0
  				available = false
  				break
  			end
  		end
  		open_listings << listing if available
  	end
  	open_listings
  end



 

  def self.highest_ratio_res_to_listings
  	#knows city with highest ratio of reservations to listings
  	ratios = {}
  	City.all.each do |city|
  		reservations = 0
  		city.listings.each do |listing|
  			reservations += listing.reservations.count
  		end
  		ratios[city] = reservations.to_f/city.listings.count.to_f
  	end
  	ratios.max_by {|k, v| v}[0]
  end



  def self.most_res
  	#knows the city with the most reservations
  	res_counts = {}
  	City.all.each do |city|
  		reservations = 0
  		city.listings.each do |listing|
  			reservations += listing.reservations.count
  		end
  		res_counts[city] = reservations
  	end
  	res_counts.max_by {|k, v| v}[0]
  	
  end


end

