require_relative './sqlitetypes.rb'
require_relative './manager.rb'
require_relative './edit.rb'
require 'time'

# Manages all edits in the SQL database
class EditManager < Manager
	def initialize(db)
		super(db, 'edits', Edit)
		@columns << {
			name: 'id', 
			type: SQLiteType::INTEGER, 
			not_null: true, 
			primary_key: true,
			auto_increment: true,
			unique: true
		}
		@columns << {name: 'date', type: SQLiteType::TEXT, not_null: true}
		@columns << {name: 'new_text', type: SQLiteType::TEXT, not_null: true}
		@columns << {name: 'old_text', type: SQLiteType::TEXT}
		@columns << {name: 'user', type: SQLiteType::INTEGER, not_null: true}
		@columns << {name: 'post', type: SQLiteType::INTEGER, not_null: true}
	end
end
