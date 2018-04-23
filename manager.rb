# Base class for all managers for the SQL database
class Manager 
	def initialize(db, table, item_class)
		@db = db
		@table = table
		@item_class = item_class
	end

	# Check if the row exists
	# @param hash [Hash] the column and value to filter, eg name: 'Erik'
	# @return [Boolean] if the row exists or not
	def exists_with(hash)
		column = hash.keys.first
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
		value = hash[column]

		result = find_with(hash)
		if(!result)
			raise "#{@table} does not contain an item where #{column.to_s} is" + 
				  " #{value}"
		end

		@item_class.new(*result)
	end
end
