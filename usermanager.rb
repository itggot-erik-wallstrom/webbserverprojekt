require_relative './user.rb'
require 'time'

# Manages all users in the SQL database
class UserManager
	def initialize(db)
		@db = db
	end

	# Checks if a user with the specified id exists
	# @param id [String] the id to check
	# @return [Boolean] if the user exists or not
	def exists_with_id(id)
		result = @db.execute('SELECT * FROM users WHERE id IS ?', id)
		if(result.size == 0)
			false
		else
			true
		end
	end

	# Checks if a user with the specified name exists
	# @param name [String] the name to check
	# @return [Boolean] if the user exists or not
	def exists_with_name(name)
		result = @db.execute('SELECT * FROM users WHERE name IS ?', name)
		if(result.size == 0)
			false
		else
			true
		end
	end

	# Find a user with the specified id
	# @param id [String] the id
	# @return [Array<String>] the SQL result or [Nil] if not found
	def find_with_id(id)
		result = @db.execute('SELECT * FROM users WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result[0]
		end
	end

	# Find a user with the specified name
	# @param name [String] the name
	# @return [Array<String>] the SQL result or [Nil] if not found
	def find_with_name(name)
		result = @db.execute('SELECT * FROM users WHERE name IS ?', name)
		if(result.size == 0)
			nil
		else
			result[0]
		end
	end

	# Adds a new user to the database
	# @param username [String] the username
	# @param password [String] the password
	def add(username, password)
		hash = BCrypt::Password.create(password)
		if(exists_with_name(username))
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

	# Gets all users
	# @return [Array<User>] all users
	def get_all
		result = @db.execute('SELECT * FROM users')
		users = []

		result.each_with_index do |value, i|
			users[i] = User.new(value[0], value[1], value[2], value[3])
		end

		users
	end

	# Gets a user with a specified id
	# @param id [String] the id
	# @return [User] the user with the id
	def get_with_id(id)
		result = find_with_id(id)
		if(!result)
			raise 'User does not exist'
		end

		User.new(result[0], result[1], result[2], result[3])
	end

	# Gets a user with a specified name
	# @param name [String] the name
	# @return [User] the user with the name
	def get_with_name(name)
		result = find_with_name(name)
		if(!result)
			raise 'User does not exist'
		end

		User.new(result[0], result[1], result[2], result[3])
	end
end
