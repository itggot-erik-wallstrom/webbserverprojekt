require_relative './post.rb'
require 'time'

# Manages all posts in the SQL database
class PostManager
	def initialize(db)
		@db = db
	end

	private def check_result(result)
		if(result.size == 0)
			false
		else
			true
		end
	end

	# Checks if a post with the specified id exists
	# @param id [String] the id to check
	# @return [Boolean] if the post exists or not
	def exists_with_id(id)
		result = @db.execute('SELECT * FROM posts WHERE id IS ?', id)
		check_result(result)
	end

	# Checks if a post with the specified title exists
	# @param name [String] the title to check
	# @return [Boolean] if the post exists or not
	def exists_with_title(name)
		result = @db.execute('SELECT * FROM posts WHERE title IS ?', name)
		check_result(result)
	end

	# Find a post with the specified id
	# @param id [String] the id
	# @return [Array<String>] the SQL result or [Nil] if not found
	def find_with_id(id)
		result = @db.execute('SELECT * FROM posts WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result[0]
		end
	end

	# Find a post with the specified title
	# @param title [String] the title
	# @return [Array<String>] the SQL result or [Nil] if not found
	def find_with_title(title)
		result = @db.execute('SELECT * FROM posts WHERE title IS ?', title)
		if(result.size == 0)
			nil
		else
			result[0]
		end
	end

	# Adds a new post to the database
	# @param title [String] the title
	# @param text [String] the text content
	# @param creator [String] the user id of the creator
	def add(title, text, creator)
		if(exists_with_title(title))
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

	private def parse_result(result)
		posts = []

		result.each_with_index do |value, i|
			posts[i] = Post.new(
				value[0], 
				value[3], 
				value[4], 
				value[5],
				value[1],
				value[2]
			)
		end

		posts
	end

	# Gets all posts
	# @return [Array<Post>] all posts
	def get_all
		result = @db.execute('SELECT * FROM posts')
		parse_result(result)
	end

	# Gets all posts with a specified creator
	# @param id [String] the id of the creator
	# @return [Array<Post>] all posts with the creator
	def get_all_with_creator(id)
		result = @db.execute('SELECT * FROM posts WHERE creator IS ?', id)
		parse_result(result)
	end

	# Gets a post with a specified id
	# @param id [String] the id
	# @return [Post] the post with the id
	def get_with_id(id)
		result = find_with_id(id)
		if(!result)
			raise 'Post does not exist'
		end

		Post.new(
			result[0], 
			result[3], 
			result[4], 
			result[5],
			result[1],
			result[2]
		)
	end

	# Gets a post with a specified title
	# @param title [String] the title
	# @return [Post] the post with the title
	def get_with_title(title)
		result = find_with_title(title)
		if(!result)
			raise 'Post does not exist'
		end

		Post.new(
			result[0], 
			result[3], 
			result[4], 
			result[5],
			result[1],
			result[2]
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
