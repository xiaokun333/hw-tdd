class Movie < ActiveRecord::Base
  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      Movie.where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.search_directors(director) 
    Movie.where(:director => director)
  end

end
