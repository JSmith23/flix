class Movie < ApplicationRecord
  RATINGS = %w(G PG PG-13 R NC-17)
  validates_presence_of :title, :released_on, :duration 
  validates_length_of :description, minimum: 25
  validates_numericality_of :total_gross, greater_than_or_equal_to: 0
  validates :rating, inclusion: { in: RATINGS }
  validates :image_file_name, allow_blank: true, format: {
  with:    /\w+\.(gif|jpg|png)\z/i,
  message: "must reference a GIF, JPG, or PNG image"
  }
  has_many :reviews, dependent: :destroy

  def self.released
    where("released_on <= ?", Time.now).order("released_on desc")
  end

  def self.hits
    where('total_gross >= 300000000').order(total_gross: :desc)
  end

  def self.flops
    where('total_gross < 50000000').order(total_gross: :asc)
  end

  def self.recently_added
    order('created_at desc').limit(3)
  end

  def flop?
    total_gross.blank? || total_gross < 50000000
  end

  def average_stars 
    reviews.average(:stars)
  end 
end
