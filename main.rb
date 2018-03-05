require_relative './usermanager.rb'
require_relative './postmanager.rb'

class Main < Sinatra::Base
	enable :sessions

	def initialize
		db = SQLite3::Database.open('db.sqlite')
		@usermanager = UserManager.new(db)
		@postmanager = PostManager.new(db)
		super
	end

	get '/' do
		redirect '/login'
	end

	get '/login' do
		slim :login
	end

	post '/login' do
		username = params['username']
		password = params['password']

		begin
			user = @usermanager.get_with_name(username)
			password_test = BCrypt::Password.new(user.password)

			if(password_test == password)
				session[:logged_in] = user.id
				slim :dashboard
			else
				"Wrong username or password"
			end
		rescue Exception => e
			e.message
		end
	end

	post '/logout' do
		session.delete :logged_in
		slim :logout
	end

	get '/users/new' do
		slim :new_user
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
		users = @usermanager.get_all

		result = ""
		users.each do |user|
			result += "#{user.id}: #{user.name} #{user.registration_date}<br>"
		end

		result
	end

	get '/users/:id' do
		begin 
			user = @usermanager.get_with_id(params[:id])
			"#{user.id}: #{user.name} #{user.registration_date}"
		rescue Exception => e
			e.message
		end
	end

	get '/posts/new' do
		slim :new_post
	end

	post '/posts' do
		title = params['title']
		text = params['text']

		if(!session[:logged_in])
			return "You must be logged in to submit a post"
		else
			creator = @usermanager.get_with_id(session[:logged_in]).id
		end

		begin
			@postmanager.add(title, text, creator)
			"Post creation was successful"
		rescue Exception => e
			e.message
		end
	end

	get '/posts' do
		posts = @postmanager.get_all

		result = ""
		posts.each do |post|
			result += "#{post.id}: #{post.title} #{post.creation_date}" +
				" #{post.modification_date}" + 
				" #{@usermanager.get_with_id(post.creator).name} <br>"
		end

		result
	end

	get '/posts/:id' do
		begin 
			post = @postmanager.get_with_id(params[:id])
			"#{post.id}: #{post.title} #{post.creation_date}" +
				" #{post.modification_date}" + 
				" #{@usermanager.get_with_id(post.creator).name} <br>" +
				" #{post.text}"
		rescue Exception => e
			e.message
		end
	end
end
