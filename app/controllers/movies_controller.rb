class MoviesController < ApplicationController
  protect_from_forgery
  before_filter :set_var
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @allratings = Movie.get_rating#['G','PG','PG-13','R']
    @cur_string = ''
###############################################################
#        Is this best put in the view or the controller or
#           just bad ruby (it preserves the prior URI)?
#                                                              
#
#    if(params[:ratings].nil? != true)
#      @currents.each_key do |rating|
#        if(params[:ratings].has_key?(rating))
#          @currents[rating] = 1
#          @cur_string = @cur_string+"ratings[%s]=1&" % rating
#        else
#          if(@currents.has_key?(rating))
#            @currents.delete(rating)
#          end
#        end
#      end
#    end
###############################################################
    @movies = Movie.where(:rating => @currents.keys).all
    if(params[:sort] == '1' || @title_sort)
      session[:sort] = 'title'
      @movies = Movie.where(:rating => @currents.keys).order("title ASC").all
      @date_sort = false
      @title_sort = true
    elsif(params[:sort] == '2' || @date_sort)
      session[:sort] = 'date'
      @movies = Movie.where(:rating => @currents.keys).order("release_date ASC").all
      @date_sort = true
      @title_sort = false
    elsif(session[:sort] == 'title')
      @movies = Movie.where(:rating => @currents.keys).order("title ASC").all
      @date_sort = false
      @title_sort = true
      session[:sort] = 'title'
    elsif(session[:sort] == 'date')
      @movies = Movie.where(:rating => @currents.keys).order("release_date ASC").all
      @date_sort = true 
      @title_sort = false
      session[:sort] = 'date'
    end
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
  def set_var
    if(params[:ratings].nil? && session[:ratings].nil?)
      @currents = {'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
      session[:ratings]=@current
    elsif(params[:ratings].nil?)
      @currents = session[:ratings]
    else
      @currents = params[:ratings]#{'G'=>1,'PG'=>1,'PG-13'=>1,'R'=>1}
      session[:ratings] = @currents
    end
    @date_sort = false
    @title_sort = false
  end
end
