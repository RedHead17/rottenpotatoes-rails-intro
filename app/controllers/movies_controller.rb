class MoviesController < ApplicationController

  @@SORTING_HASH = { "Movie Title" => {"sort" => "title", "col_id" => "title_header"}, 
                      "Rating" => {"sort" => "rating", "col_id" => "rating_header"}, 
                      "Release Date" => {"sort" => "release_date", "col_id" => "release_date_header"}, 
                      "More Info" => {"sort" => "title", "col_id" => "more_info_header"}}
  def self.SORTING_HASH
    return @@SORTING_HASH
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # Perform filtering if needed.
    # TODO: use redirection instead of session param explicitly
    @sorting_hash = @@SORTING_HASH
    @all_ratings = Movie.MOVIE_RATINGS
    @sel_ratings = params[:ratings]
    replace_ratings = false;
    if(@sel_ratings.nil?)
      @movies = Movie.all
      replace_ratings = !session[:ratings].nil?
      if(replace_ratings)
        params[:ratings] = session[:ratings]
      end
    else
      @movies = Movie.with_ratings(@sel_ratings)
      session[:ratings] = @sel_ratings
    end
    
    # Perform sorting and apply class to column header if needed
    @selected_class = "hilite bg-warning"
    @sel_col = "none"
    sort_by = params[:sort]
    
    # Take from the session hash if sort by is nil
    replace_sorting = sort_by.nil? && !session[:sort].nil?;
    if(replace_sorting)
      params[:sort] = session[:sort]
      params[:col_id] = session[:col_id]
    end
    
    if(!sort_by.nil?)
      @movies.order!(sort_by)
      @sel_col = params[:col_id]
      session[:sort] = sort_by
      session[:col_id] = @sel_col
    end
    
    if(replace_ratings || replace_sorting)
      flash.keep
      redirect_to movies_path(params)
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
