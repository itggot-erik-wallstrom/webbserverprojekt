class Manager
	def initialize(db, table_name)
		@db = db
		@table_name = table_name
	end

	def exists(options)
	end

	def add(options)
	end

	def get_all
		@db.execute("SELECT * FROM #{table_name}")
	end

	def get_with(options)
	end
end
