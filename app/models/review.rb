class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :real_review?, if: [:reservation]

  private

  def real_review?
  	#binding.pry
  	unless Date.today > reservation.checkout
      errors.add(:checkout_state, "Guest much checkout before leaving a review")
    end
  end




end
