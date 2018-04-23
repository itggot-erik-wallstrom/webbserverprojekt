require_relative './usermanager.rb'
require_relative './postmanager.rb'
require_relative './editmanager.rb'

# Main class
class Main < Sinatra::Base
	enable :sessions

	def initialize
		db = SQLite3::Database.open('db.sqlite')
		@usermanager = UserManager.new(db)
		@postmanager = PostManager.new(db)
		@editmanager = EditManager.new(db)
		super
	end

	before do
		if(!session[:logged_in])
			if( request.path_info != '/login'     && 
				request.path_info != '/users/new' && 
				request.path_info != '/' 		  &&
				(request.path_info != '/users' && 
					request.request_method != 'POST'))

				request.path_info = '/login'
			end
		end
	end

	get '/' do
		slim :main
	end

	get '/login' do
		slim :login
	end

	post '/login' do
		username = params['username']
		password = params['password']

		begin
			user = @usermanager.get_with(name: username)
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
		@user_id = session[:logged_in]
		slim :dashboard
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
			@msg = 'User creation was successful'
			@back = '/login'
			slim :success
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
			@user = @usermanager.get_with(id: params[:id])
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
		creator = @usermanager.get_with(id: session[:logged_in]).id

		begin
			@postmanager.add(title, text, creator)
			@msg = 'Post creation was successful'
			@back = '/posts'
			slim :success
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/posts' do
		if(params['creator_name'])
			begin
				@posts = @postmanager.get_all_with(
					creator: @usermanager.get_with(
						name: params['creator_name']
					).id
				)
			rescue Exception => e
				@msg =  e.message
				return slim :error
			end
		elsif(params['creator_id'])
			@posts = @postmanager.get_all_with(creator: params['creator_id'])
		else
			@posts = @postmanager.get_all
		end

		slim :all_posts
	end

	get '/posts/:id' do
		begin 
			@post = @postmanager.get_with(id: params[:id])
			slim :one_post
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end

	get '/posts/:id/edit' do
		@post = @postmanager.get_with(id: params[:id])
		slim :edit_post
	end

	patch '/posts/:id' do
		text = params['text']
		post_id = params[:id]
		user_id = session[:logged_in]
		post = @postmanager.get_with(id: post_id)

		@editmanager.add(text, user_id, post)
		post.update(text)
		@postmanager.update(post)

		redirect "/posts/#{post_id}"
	end

	get '/edits' do
		if(params['user_id'])
			@edits = @editmanager.get_all_with(user: params['user_id'])
		elsif(params['post_id'])
			@edits = @editmanager.get_all_with(post: params['post_id'])
		else
			@edits = @editmanager.get_all
		end

		slim :all_edits
	end

	get '/edits/:id' do
		begin 
			@edit = @editmanager.get_with(id: params[:id])
			slim :one_edit
		rescue Exception => e
			@msg = e.message
			slim :error
		end
	end
end

