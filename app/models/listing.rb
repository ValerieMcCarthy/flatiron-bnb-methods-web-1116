class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true

  after_create :user_becomes_host
  after_destroy :if_last_listing_host_becomes_user





  def user_becomes_host
 
    host.host = true
    host.save
  end

  def if_last_listing_host_becomes_user
    if host.listings.empty?
      host.host = false
      host.save
    end
  end

  def average_review_rating
    #binding.pry
    #reviews.average(:rating)
    total_rating = 0
    self.reviews.each do |review|
      total_rating += review.rating
    end
    total_rating.to_f/self.reviews.count.to_f
  end


end
