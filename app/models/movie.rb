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

  def self.movies_with_same_director(director)
    other_movies = Movie.where(:director => director)
    other_movies.reject { |m| m.id == movie.id }
  end
  
end
