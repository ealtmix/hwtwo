class Movie < ActiveRecord::Base
  def self.get_rating
  
    rating = Hash.new
    self.find(:all).each do |rate|
      
      rating[rate.rating] = 1
      
    end
    rating.keys
  end

end
