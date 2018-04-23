require_relative './manager'
require_relative './post.rb'
require 'time'

# Manages all posts in the SQL database
class PostManager < Manager
	def initialize(db)
		super(db, 'posts', Post)
	end

	# Adds a new post to the database
	# @param title [String] the title
	# @param text [String] the text content
	# @param creator [String] the user id of the creator
	def add(title, text, creator)
		if(exists_with(title: title))
			raise 'Title already exists'
		end

		creation_date = DateTime.now.strftime('%Y-%m-%d %H:%M')
		@db.execute(
			'INSERT INTO posts (title, text, creator, creation_date)' +
				' VALUES (?, ?, ?, ?)', 
			title, 
			text,
			creator,
			creation_date
		)
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
