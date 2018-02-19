require_relative './usermanager.rb'

class Main < Sinatra::Base
	enable :sessions

	def initialize
		db = SQLite3::Database.open('db.sqlite')
		@usermanager = UserManager.new(db)
		super
	end

	get '/' do
		"Hello World"
	end

	get '/users/new' do
		slim :register
	end

	post '/users' do
		username = params['username']
		password = params['password']
		confirm_password = params['confirm_password']

		if(password != confirm_password)
			return "Passwords do not match"
		end

		begin
			@usermanager.add(username, password)
			"User creation was successful"
		rescue Exception => e
			e.message
		end
	end

	get '/users' do
		result = ""
		users = @usermanager.get_all
		users.each do | user |
			result += "#{user[0]}<br>"
		end

		result
	end

	get '/users/:id' do
		begin 
			user = @usermanager.get_with_id(params[:id])
			user[0]
		rescue Exception => e
			e.message
		end
	end
end
