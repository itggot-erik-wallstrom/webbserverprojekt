require_relative './manager.rb'
require_relative './user.rb'
require 'time'

# Manages all users in the SQL database
class UserManager < Manager
	def initialize(db)
		super(db, 'users', User)
	end

	# Adds a new user to the database
	# @param username [String] the username
	# @param password [String] the password
	def add(username, password)
		hash = BCrypt::Password.create(password)
		if(exists_with(name: username))
			raise 'Username already exists'
		end

		registration_date = DateTime.now.strftime('%Y-%m-%d %H:%M')
		@db.execute(
			'INSERT INTO users (name, password, registration_date)' +
				' VALUES (?, ?, ?)', 
			username, 
			hash,
			registration_date
		)
	end
end
