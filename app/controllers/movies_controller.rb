class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings]
	@selected_rating = params[:ratings].keys
 	session[:ratings] = @selected_rating
    elsif session[:ratings]
	@selected_rating = session[:ratings]
    else
	 @selected_rating = @all_ratings
    end
    sort = params[:sort] || session[:sort]
    if sort == "title"
	@title_class = "hilite"
  	@movies = Movie.filter(@selected_rating).order("title")
    	session[:sort] = "title"
    elsif sort == "release"
	@release_class = "hilite"
	@movies = Movie.filter(@selected_rating).order("release_date")
	session[:sort] = "release"
    else
	@movies = Movie.filter(@selected_rating)
    end
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

end
