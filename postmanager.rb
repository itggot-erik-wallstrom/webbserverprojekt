require_relative './post.rb'
require 'time'

class PostManager
	def initialize(db)
		@db = db
	end

	def exists_with_id(id)
		result = @db.execute('SELECT * FROM posts WHERE id IS ?', id)
		if(result.size == 0)
			false
		else
			true
		end
	end

	def exists_with_title(name)
		result = @db.execute('SELECT * FROM posts WHERE title IS ?', name)
		if(result.size == 0)
			false
		else
			true
		end
	end

	def find_with_id(id)
		result = @db.execute('SELECT * FROM posts WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result
		end
	end

	def find_with_title(name)
		result = @db.execute('SELECT * FROM posts WHERE title IS ?', name)
		if(result.size == 0)
			nil
		else
			result
		end
	end

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

	def get_all
		result = @db.execute('SELECT * FROM posts')
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

	def get_all_with_creator(id)
		result = @db.execute('SELECT * FROM posts WHERE creator IS ?', id)
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

	def get_with_id(id)
		result = find_with_id(id)
		if(!result)
			raise 'Post does not exist'
		end

		Post.new(
			result[0][0], 
			result[0][3], 
			result[0][4], 
			result[0][5],
			result[0][1],
			result[0][2]
		)
	end

	def get_with_title(title)
		result = find_with_title(title)
		if(!result)
			raise 'Post does not exist'
		end

		Post.new(
			result[0][0], 
			result[0][3], 
			result[0][4], 
			result[0][5],
			result[0][1],
			result[0][2]
		)
	end

	def update(post)
		@db.execute(
			'UPDATE posts SET text = ?, modification_date = ? WHERE id is ?',
			post.text, 
			post.modification_date, 
			post.id
		)
	end
end
