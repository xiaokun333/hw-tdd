require 'rails_helper'


describe MoviesController, type: :controller do
  before(:all) do
    if Movie.where(director: "Tom Hooper").empty?
      Movie.create(title: "Les Misérables", director: "Tom Hooper", rating: "PG-13", release_date: "2012-12-25")
      Movie.create(title: "The Danish Girl", director: "Tom Hooper", rating: "R", release_date: "2016-01-01")
    end

    if Movie.where(title: "Cats").empty?
      Movie.create(title: "Cats",
                   rating: "PG", release_date: "1998-10-05", director: "David Mallet")
    end

    if Movie.where(title: "The Princess Bride").empty?
      Movie.create(title: "The Princess Bride",
                   rating: "PG", release_date: "1987-10-09")
    end
  end

  # add director to existing movie

  # find movies with siilar director

  describe 'find movie with same director' do
    it 'returns the correct matches for movies by the same director' do
      get :select_by_director, {:id => Movie.find_by_title("Les Misérables")}
      movie = Movie.find_by_title("Les Misérables")
      movie_by_director = Movie.search_directors(movie.director).where.not(title: "Les Misérables")

      expect(movie_by_director).to_not be_empty
      expect(movie_by_director.pluck(:title)).to eq(["The Danish Girl"])
      
      expect(response).to render_template "select_by_director"
    end

    it 'returns nothing if no match is found' do
      movie = Movie.find_by_title("Cats")
      movie_by_director = Movie.search_directors(movie.director).where.not(title: "Cats")
      expect(movie.director).not_to be_empty
      expect(movie_by_director).to be_empty
    end
  end

  describe "create movie" do 
    it "should return success after creating a valid movie" do
      get :create, {:movie => {:title => "Shrek", :director => "Vicky Jenson",
                    :rating => "PG", :release_date => "2001-04-22"}}
      expect(response).to redirect_to movies_path
      expect(flash[:notice]).to match(/Shrek was successfully created./)
      Movie.find_by(:title => "Shrek").destroy
    end
  end

  describe "edit leads to editing template" do 
    it "should direct to the edit page" do
      movie = Movie.create(:title => "Shrek 2", :rating => "PG", :release_date => "2004-05-19")
      id = movie.id
      expect(Movie).to receive(:find).and_return(movie)
      
      get :edit, id: id
      expect(response).to render_template(:edit)
      movie.destroy
    end

  end

  describe "update movie info" do 
    it "successfully updates movie given valid information" do
      movie = Movie.create(:title => "Shrek 2", :rating => "PG", :release_date => "2004-05-19")
      get :update, {:id => movie.id, :movie => {:director => "Conrad Vernon"}}
      
      expect(response).to redirect_to movie_path(movie)
      expect(flash[:notice]).to match(/Shrek 2 was successfully updated./)
      movie.destroy
    end
  end

  describe "delete movie" do
    it "deletes the movie selected" do
      movie = Movie.create(:title => "Shrek 2", :rating => "PG", :release_date => "2004-05-19")
      id = movie.id
      delete :destroy, id: id
      expect(flash[:notice]).to match(/Movie || deleted./)
      expect(response).to redirect_to(movies_path)
    end
  end
end