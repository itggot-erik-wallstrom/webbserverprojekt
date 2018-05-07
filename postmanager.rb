require_relative './sqlitetypes.rb'
require_relative './manager'
require_relative './post.rb'
require 'time'

# Manages all posts in the SQL database
class PostManager < Manager
	def initialize(db)
		super(db, 'posts', Post)
		@columns << {
			name: 'id', 
			type: SQLiteType::INTEGER, 
			not_null: true, 
			primary_key: true,
			auto_increment: true,
			unique: true
		}
		@columns << {
			name: 'creation_date', 
			type: SQLiteType::TEXT, 
			not_null: true
		}
		@columns << {name: 'modification_date', type: SQLiteType::TEXT}
		@columns << {name: 'text', type: SQLiteType::TEXT}
		@columns << {
			name: 'title', 
			type: SQLiteType::TEXT, 
			not_null: true, 
			unique: true
		}
		@columns << {name: 'creator', type: SQLiteType::INTEGER}
	end

	# Change a post in the database
	# @param post [Post] a post containing all the changes
	def update(post)
		@db.execute(
			'UPDATE posts SET text = ?, modification_date = ? WHERE id is ?',
			post.text, 
			post.modification_date, 
			post.id
		)
	end
end
