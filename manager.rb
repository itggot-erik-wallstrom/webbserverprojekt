# Base class for all managers for the SQL database
class Manager 
	def initialize(db, table, item_class)
		@db = db
		@table = table
		@item_class = item_class
		@columns = []
	end

	# Creates a new table in the database
	def create
		sql = "CREATE TABLE `#{@table}` ("
		@columns.each do |column|
			sql += "`#{column[:name]}` #{column[:type]}"
			if(column[:not_null])
				sql += ' NOT NULL'
			end

			if(column[:primary_key])
				sql += ' PRIMARY KEY'
			end

			if(column[:auto_increment])
				sql += ' AUTOINCREMENT'
			end

			if(column[:unique])
				sql += ' UNIQUE'
			end
			sql += ','
		end
		sql.chop! # Remove trailing ','
		sql += ');'
		p sql
		@db.execute(sql)
	end

	# Check if column exists
	# @param column [String] the column to check
	# @return [Hash] found column if it exists, raises error if not
	def check_column(column)
		@columns.each do |test|
			p test[:name], column
			if(column == test[:name])
				return test
			end
		end

		raise "#{column} does not exist"
	end

	# Adds a new row to the table
	# @param hash [Hash] all values that should be set
	def add(hash)
		arr = []
		hash.each do |k, v|
			column = check_column(k.to_s)
			if(column[:unique])
				if(exists_with({k => v}))
					raise "#{k} #{v} already exists"
				end
			end
			arr << [k, v]
		end

		sql = "INSERT INTO #{@table} ("
		arr.each do |a|
			sql += "#{a[0]},"
		end

		sql.chop! # Remove trailing ','
		sql += ' VALUES ('
		arr.each do |a|
			sql += "#{a[1]},"
		end

		sql.chop! # Remove trailing ','
		sql += ');'
		@db.execute(sql)
	end

	# Check if the row exists
	# @param hash [Hash] the column and value to filter, eg name: 'Erik'
	# @return [Boolean] if the row exists or not
	def exists_with(hash)
		column = hash.keys.first
		check_column(column.to_s)
		value = hash[column]
		result = @db.execute(
			"SELECT * FROM #{@table} WHERE #{column.to_s} IS ?", 
			value
		)

		if(result.size == 0)
			false
		else
			true
		end
	end

	# Find the specified row 
	# @param hash [Hash] the column and value to filter, eg name: 'Erik'
	# @return [Boolean] nil if not found or the row
	def find_with(hash)
		column = hash.keys.first
		check_column(column.to_s)
		value = hash[column]
		result = @db.execute(
			"SELECT * FROM #{@table} WHERE #{column.to_s} IS ?", 
			value
		)

		if(result.size == 0)
			nil
		else
			result[0]
		end
	end

	# Get all rows
	# @return [Object[]] A list of all rows
	def get_all
		result = @db.execute("SELECT * FROM #{@table}")
		items = []

		result.each_with_index do |value, i|
			items[i] = @item_class.new(*value)
		end

		items
	end

	# Get all rows
	# @param hash [Hash] the column and value to filter, eg name: 'Erik'
	# @return [Object[]] A list of all rows
	def get_all_with(hash)
		column = hash.keys.first
		check_column(column.to_s)
		value = hash[column]
		result = @db.execute(
			"SELECT * FROM #{@table} WHERE #{column.to_s} IS ?", 
			value
		)

		items = []
		result.each_with_index do |value_, i|
			items[i] = @item_class.new(*value_)
		end

		items
	end

	# Get row with specifications
	# @param hash [Hash] the column and value to filter, eg name: 'Erik'
	# @return [Object] The row
	def get_with(hash)
		column = hash.keys.first
		check_column(column.to_s)
		value = hash[column]

		result = find_with(hash)
		if(!result)
			raise "#{@table} does not contain an item where #{column.to_s} is" + 
				  " #{value}"
		end

		@item_class.new(*result)
	end
end
