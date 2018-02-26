require_relative './user.rb'
require 'time'

class UserManager
	def initialize(db)
		@db = db
	end

	def exists_with_id(id)
		result = @db.execute('SELECT * FROM users WHERE id IS ?', id)
		if(result.size == 0)
			false
		else
			true
		end
	end

	def exists_with_name(name)
		result = @db.execute('SELECT * FROM users WHERE name IS ?', name)
		if(result.size == 0)
			false
		else
			true
		end
	end

	def find_with_id(id)
		result = @db.execute('SELECT * FROM users WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result
		end
	end

	def find_with_name(name)
		result = @db.execute('SELECT * FROM users WHERE name IS ?', name)
		if(result.size == 0)
			nil
		else
			result
		end
	end

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

	def get_all
		result = @db.execute('SELECT * FROM users')
		users = []

		result.each_with_index do |value, i|
			users[i] = User.new(value[0], value[1], value[2], value[3])
		end

		users
	end

	def get_with_id(id)
		result = find_with_id(id)
		if(!result)
			raise "User does not exist"
		end

		User.new(result[0][0], result[0][1], result[0][2], result[0][3])
	end

	def get_with_name(name)
		result = find_with_name(name)
		if(!result)
			raise "User does not exist"
		end

		User.new(result[0][0], result[0][1], result[0][2], result[0][3])
	end
end
