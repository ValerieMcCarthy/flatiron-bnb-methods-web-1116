class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :host_same?
  validate :reservation_available, if: :filled_dates
  validate :reservation_dates, if: :filled_dates

  
	def duration
		checkout - checkin
	end

	def total_price
		listing.price * duration
	end

	  def host_same?
	  	#binding.pry
	  	#self.guest != listing.host
	  	if listing.host_id == guest_id
	      errors.add(:same_host_error, "You cannot make a reservation on your listing.")
	    end
	  end

  def filled_dates
  	!(checkout.nil? || checkin.nil?)
  end

  def reservation_available
  	# if !filled_dates
  	# 	errors.add(:no_date_error, "You must have checkin and checkout dates.")
  	# end
  	available = true
  	listing.reservations.each do |reservation|
  		if (checkin - reservation.checkout) * (reservation.checkin - checkout) >= 0
  			available = false
  			break
  		end
  	end
  	if !available
  		errors.add(:availability_error, "Listing is not available during these dates.")
  	end
  end


  def reservation_dates
  	if checkin >= checkout
  		errors.add(:date_errors, "Checkin date must be before checkout.")
  	end
  end

 

  

  

end
