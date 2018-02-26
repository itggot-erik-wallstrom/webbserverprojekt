class User
	attr_reader :id, :name, :password, :registration_date

	def initialize(id, name, password, registration_date)
		@id = id
		@name = name
		@password = password
		@registration_date = registration_date
	end
end
