class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings

  def neighborhood_openings(start_date, end_date)
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
  	#knows neighborhood with highest ratio of reservations to listings
  	ratios = {}
  	Neighborhood.all.each do |neighborhood|
  		reservations = 0
  		if neighborhood.listings.count == 0
  			ratios[neighborhood] = 0
  		else
  			neighborhood.listings.each do |listing|
  				reservations += listing.reservations.count
  			end
  		end
  		ratios[neighborhood] ||= reservations.to_f/neighborhood.listings.count.to_f
  	end
  	ratios.max_by {|k, v| v}[0]
  end

 



  def self.most_res
  	#knows the neighborhood with the most reservations
  	res_counts = {}
  	Neighborhood.all.each do |neighborhood|
  		reservations = 0
  		neighborhood.listings.each do |listing|
  				reservations += listing.reservations.count
  			end
  		res_counts[neighborhood] = reservations
  	end
  	res_counts.max_by {|k, v| v}[0]
  end



end
