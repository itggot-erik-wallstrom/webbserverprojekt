class UserManager
	def initialize(db)
		@db = db
	end

	def user_exists(options)
		if(options[:id])
			result = @db.execute(
				'SELECT * FROM users WHERE id IS ?', 
				options[:id]
			)

			if(result.size == 0)
				return false
			end
		end

		if(options[:name])
			result = @db.execute(
				'SELECT * FROM users WHERE name IS ?', 
				options[:name]
			)
			
			if(result.size == 0)
				return false
			end
		end

		true
	end

	def add(username, password)
		hash = BCrypt::Password.create(password)
		if(user_exists(name: username))
			raise 'Username already exists'
		end

		@db.execute(
			'INSERT INTO users (name, password) VALUES (?, ?)', 
			username, 
			hash
		)
	end

	def get_all
		@db.execute('SELECT name FROM users')
	end

	def get_with_id(id)
		if(!user_exists(id: id))
			raise "User does not exist"
		end

		@db.execute('SELECT name FROM users WHERE id IS ?', id)
	end
end
