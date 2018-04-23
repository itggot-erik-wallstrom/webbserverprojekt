require_relative './manager.rb'
require_relative './edit.rb'
require 'time'

# Manages all edits in the SQL database
class EditManager < Manager
	def initialize(db)
		super(db, 'edits', Edit)
	end

	# Adds a new edit to the database
	# @param text [String] the text 
	# @param user [String] the user id
	# @param post [Post] the post
	def add(text, user, post)
		date = DateTime.now.strftime('%Y-%m-%d %H:%M')
		@db.execute(
			'INSERT INTO edits (date, new_text, old_text, user, post)' +
				' VALUES (?, ?, ?, ?, ?)', 
			date, 
			text,
			post.text,
			user,
			post.id
		)
	end
end
