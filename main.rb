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
				redirect '/dashboard'
			else
				@msg = 'Wrong username or password'
				slim :error
			end
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/dashboard' do
		if(session[:logged_in])
			slim :dashboard
		else
			redirect '/login'
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
			@msg = 'Passwords do not match'
			return slim :error
		end

		begin
			@usermanager.add(username, password)
			'User creation was successful' #TODO: FIX LAYOUT
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/users' do
		@users = @usermanager.get_all
		slim :all_users
	end

	get '/users/:id' do
		begin 
			@user = @usermanager.get_with_id(params[:id])
			slim :one_user
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
			return redirect '/login'
		else
			creator = @usermanager.get_with_id(session[:logged_in]).id
		end

		begin
			@postmanager.add(title, text, creator)
			'Post creation was successful' #TODO: FIX LAYOUT
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/posts' do
		if(params['creator_name'])
			begin
				@posts = @postmanager.get_all_with_creator(
					@usermanager.get_with_name(params['creator_name']).id
				)
			rescue Exception => e
				@msg =  e.message
				return slim :error
			end
		elsif(params['creator_id'])
			@posts = @postmanager.get_all_with_creator(params['creator_id'])
		else
			@posts = @postmanager.get_all
		end

		slim :all_posts
	end

	get '/posts/:id' do
		begin 
			@post = @postmanager.get_with_id(params[:id])
			slim :one_post
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/posts/:id/edit' do
		if(params[:id])
			@post = @postmanager.get_with_id(params[:id])
			slim :edit_post
		else
			@msg = 'Server did not recieve a post id'
			slim :error
		end
	end

	patch '/posts/:id' do
		if(!session[:logged_in])
			redirect '/login'
		else
			#text = params['text']
		end
	end
end

