class UserManager
	def initialize
		@db = SQLite3::DataBase.open('db/db.sqlite')
	end

	def add(username, password)
		
	end

	def get_all
		
	end
end
