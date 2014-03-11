#!/usr/bin/env jruby
require 'rubygems'
require 'bundler/setup'
require 'diametric'

require 'sinatra'
if development?
  require 'sinatra/reloader' # Shotgun and Reload do not work on JVM; use this instead
  set :bind, '0.0.0.0' # This is so I can access the development server on a remote host
end

# _App-wide settings_
# set is like attr_accessor for settings class
# e.g, settings.app_name to call from anywhere
set :app_name, "PizzaBase"
# _Datomic settings_
set :db_name, "sample"
set :db_uri, "datomic:free://localhost:4334/#{settings.db_name}"

# Connect to database
@conn = Diametric::Persistence::Peer.connect(settings.db_uri)

# _Load models_ #
# Could load all in /models but we'll do each one explicitly for now.
# I would also be okay with one models.rb file, but convention seems
#   to be to put each entity in its own file.
require 'models/person' # Person
require 'models/town' # Town
require 'models/pizza_shop'# PizzaShop

# _Handlers_
get '/' do
  @title = "Hello"
  @pizza_shop = PizzaShop.all.first
  erb :index
end

get '/view/pizza-shops' do
  @title = "Pizza Shops"
  @pizza_shops = PizzaShop.all
  erb :view_pizza_shops
end

get '/add/pizza-shop' do
  @title = "Add Pizza Shop"
  erb :add_pizza_shop
end

# post '/' do
#   @first_name, @last_name = params[:post].values_at(:first_name, :last_name)
#   @title = "#{@first_name}"
#   erb :hello
# end

__END__
@@ index
<% if @pizza_shop %>
<p> <%= "There's a good place called #{@pizza_shop.name}" %> </p>
<% else %>
<p> <%= "Could not lookup pizza shops" %> </p>
<% end %>
