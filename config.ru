#Use bundler to load gems
require 'bundler'

#Load gems from Gemfile
Bundler.require

use Rack::MethodOverride

#Load the app
require_relative 'main.rb'

#Run the application
run Main
