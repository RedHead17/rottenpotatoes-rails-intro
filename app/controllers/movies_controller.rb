class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @sorting_hash = { "Movie Title" => {"sort" => "title", "col_id" => "title_header"}, 
                      "Rating" => {"sort" => "rating", "col_id" => "rating_header"}, 
                      "Release Date" => {"sort" => "release_date", "col_id" => "release_date_header"}, 
                      "More Info" => {"sort" => "title", "col_id" => "more_info_header"}}
    
    @all_ratings = Movie.MOVIE_RATINGS
    @selected_class = "hilite bg-warning"
    @movies = Movie.all
    @sel_col = "none"
    sort_by = params[:sort]
    if(!sort_by.nil?)
      @movies.order!(sort_by)
      @sel_col = params[:col_id]
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
