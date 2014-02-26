class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    if(@checked != nil)
      @movies = @movies.find_all{ |m| @checked.has_key?(m.rating) and  @checked[m.rating]==true}      
    end
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @sort = session[:sort]
      redirect = true
    else
      @sort = nil
    end
    if params[:commit] == "Refresh" and params[:ratings].nil?
      @ratings = nil
      session[:ratings] = nil
    elsif params[:ratings]
      @ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif session[:ratings]
      @ratings = session[:ratings]
      redirect = true
    else
      @ratings = nil
    end
    
    if redirect
      flash.keep
      redirect_to movies_path :sort=>@sort, :ratings=>@ratings
    end
    
    if @ratings and @sort
      @movies = Movie.where(:rating => @ratings.keys).find(:all, :order => (@sort))
    elsif @ratings
      @movies = Movie.where(:rating => @ratings.keys)
    elsif @sort
      @movies = Movie.find(:all, :order => (@sort))
    else
      @movies = Movie.all
    end
    if !@ratings
      @ratings = Hash.new
    end
    @checked = {}
    @all_ratings =  ['G','PG','PG-13','R']
    @all_ratings.each { |rating|
      if params[:ratings] == nil
        @checked[rating] = false
      else
        @checked[rating] = params[:ratings].has_key?(rating)
      end
    }
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end
   
  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
