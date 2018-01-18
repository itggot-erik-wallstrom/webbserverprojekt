require_relative './usermanager.rb'

class Main < Sinatra::Base
	enable :sessions
	def initialize
		@usermanager = Usermanager.new
		super
	end

	get '/' do
		"Hello World"
	end

	get '/users' do
		usermanager.get_all
	end
end
