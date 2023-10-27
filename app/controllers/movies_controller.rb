class MoviesController < ApplicationController

  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def select_by_director
    #select movie by director
    # @movie = Movie.find(params[:id])
    # @director = @movie.director
    # other_movies = Movie.search_directors(@movie.director).where.not(title: @movie.title)
    # if other_movies.search_directors(@director).length == 0
    #   flash[:warning] = "'#{@movie.title}' has no director info" 
    #   redirect_to movies_path
    # end
    @movie = Movie.find(params[:id])
    if @movie.director.blank?
      flash[:notice] = "'#{@movie.title}' has no director info"
      redirect_to movies_path
    else
      @movies = Movie.search_directors(@movie.director) 
    end
    @movie = Movie.find(params[:id])
    
    # if @movie.director.blank?
    #   flash[:notice] = "'#{@movie.title}' has no director info."
    #   redirect_to root_path
    # else
    #   @movies_with_same_director = Movie.where(director: @movie.director)
  
    #   if @movies_with_same_director.any?
    #     redirect_to search_directors_path
    #   end
    # end

  end
  
  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end

end
