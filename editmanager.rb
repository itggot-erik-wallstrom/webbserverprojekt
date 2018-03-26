require_relative './edit.rb'
require 'time'

# Manages all edits in the SQL database
class EditManager
	def initialize(db)
		@db = db
	end

	# Find an edit with the specified id
	# @param id [String] the id
	# @return [Array<String>] the SQL result or [Nil] if not found
	def find_with_id(id)
		result = @db.execute('SELECT * FROM edits WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result
		end
	end

	# Gets an edit with a specified id
	# @param id [String] the id
	# @return [Edit] the edit with the id
	def get_with_id(id)
		result = find_with_id(id)
		if(!result)
			raise 'Edit does not exist'
		end

		Edit.new(
			result[0][0], 
			result[0][1], 
			result[0][2], 
			result[0][3],
			result[0][4],
			result[0][5]
		)
	end

	private def parse_result(result)
		edits = []

		result.each_with_index do |value, i|
			edits[i] = Edit.new(
				value[0], 
				value[1], 
				value[2], 
				value[3],
				value[4],
				value[5]
			)
		end

		edits
	end

	# Gets all edits
	# @return [Array<Edit>] all edits
	def get_all
		result = @db.execute('SELECT * FROM edits')
		parse_result(result)
	end

	# Gets all edits with the specified user id
	# @param id [String] the user id
	# @return [Array<Edit>] all edits with the user id
	def get_all_with_user(id)
		result = @db.execute('SELECT * FROM edits WHERE user IS ?', id)
		parse_result(result)
	end

	# Gets all edits with the specified post id
	# @param id [String] the post id
	# @return [Array<Edit>] all edits with the post id
	def get_all_with_post(id)
		result = @db.execute('SELECT * FROM edits WHERE post IS ?', id)
		parse_result(result)
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
