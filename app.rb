require 'pg'
require 'sinatra'
require 'pry'
require 'sinatra/reloader'

############################
#Methods
###########################

helpers do

  def db_connection
    begin
      connection = PG.connect(dbname: 'movies')

      yield(connection)

    ensure
      connection.close
    end
  end

  def fetch_data (command)
    data = db_connection do |conn|
      conn.exec(command)
    end
 data.to_a
  end

  def display_individual_data (command, selector)
    data = db_connection do |conn|
      conn.exec_params(command, [selector])
    end
  data.to_a
  end
end

#############################
#Rendering / Routing
#############################

#--------------DISPLAY actor list page----------------

get '/actors' do

  sql = "SELECT name FROM actors ORDER BY name;"
  @actors = fetch_data(sql)
  #@actors = [{"name"=>"\"Biff\" Henderson"}, {"name"=>"\"Gypsy\" Spheeris"}, ...]

  erb :'actors/index'

end

#--------------DISPLAY individual actor's page---------

get '/actors/:name' do

sql = "SELECT actors.name, cast_members.character, movies.title AS movie, movies.id FROM cast_members JOIN movies ON cast_members.movie_id = movies.id JOIN actors ON cast_members.actor_id = actors.id WHERE actors.name = $1;"

@actor_page = display_individual_data(sql, params[:name])

erb :'actors/show'

end

#------------DISPLAY list of movies page --------------

get '/movies' do

  sql = "SELECT movies.id, movies.title AS movie, movies.year, movies.rating, genres.name AS genre, studios.name AS studio FROM movies JOIN genres ON genres.id = movies.genre_id JOIN studios ON studios.id = movies.studio_id ORDER BY movies.title;"

  @movies = fetch_data(sql)

  erb :'movies/index'

end

#------------DISPLAY individual movie page---------------

get '/movies/:id' do

  sql = "SELECT movies.title AS movie, movies.year, movies.rating, genres.name AS genre, studios.name AS studio, actors.name AS actor, cast_members.character FROM movies JOIN genres ON genres.id=movies.genre_id JOIN studios ON studios.id = movies.studio_id JOIN cast_members ON cast_members.movie_id = movies.id JOIN actors ON cast_members.actor_id = actors.id WHERE movies.id = $1;"

  @movie_page = display_individual_data(sql, params[:id])

# @movie_page = [{"movie"=>"13 Assassins",
#   "year"=>"2011",
#   "rating"=>"96",
#   "genre"=>"Art House & International",
#   "studio"=>"Magnet Releasing",
#   "actor"=>"Koji Yakusho",
#   "character"=>"Shinzaemon Shimada"},
#  {"movie"=>"13 Assassins",
#   "year"=>"2011",
#   "rating"=>"96",
#   "genre"=>"Art House & International",
#   "studio"=>"Magnet Releasing",
#   "actor"=>"Takayuki Yamada",
#   "character"=>"Shinrokuro (Shinzaemon's Nephew)"},...]

  erb :'movies/show'
end

