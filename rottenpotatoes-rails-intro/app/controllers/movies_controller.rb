class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.pluck('rating').uniq
    @sort_param = nil
    @filter_param = nil
    @Rating_from_filter = @all_ratings
    
    if(params[:sort] != nil)
      @sort_param = params[:sort]
    elsif session[:sort] !=nil
      @sort_param = session[:sort]
    else
      @sort_param = nil
    end
    
    if(params[:ratings] != nil)
        @filter_param = params[:ratings]
    elsif session[:ratings] !=nil
      @filter_param = session[:ratings]
    else
      @filter_param = nil
    end
    
    if @filter_param == nil
     @Rating_from_filter = @all_ratings
    else
     @Rating_from_filter = @filter_param
    end
    
    if(params[:ratings] == nil && session[:ratings] == nil )
      @movies = Movie.order(@sort_param)
    else
      @movies = Movie.where(:rating => @filter_param.keys).order(@sort_param)
  end

    session[:sort] = @sort_param
    session[:ratings] = @filter_param
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
