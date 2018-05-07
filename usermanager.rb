require_relative './sqlitetypes.rb'
require_relative './manager.rb'
require_relative './user.rb'

# Manages all users in the SQL database
class UserManager < Manager
	def initialize(db)
		super(db, 'users', User)
		@columns << {
			name: 'id', 
			type: SQLiteType::INTEGER,
			not_null: true, 
			primary_key: true,
			auto_increment: true,
			unique: true
		}
		@columns << {
			name: 'name', 
			type: SQLiteType::TEXT, 
			not_null: true, 
			unique: true
		}
		@columns << {name: 'password', type: SQLiteType::TEXT, not_null: true}
		@columns << {
			name: 'registration_date', 
			type: SQLiteType::TEXT, 
			not_null: true
		}
	end
end
