require_relative './edit.rb'
require 'time'

class EditManager
	def initialize(db)
		@db = db
	end

	def find_with_id(id)
		result = @db.execute('SELECT * FROM edits WHERE id IS ?', id)
		if(result.size == 0)
			nil
		else
			result
		end
	end

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

	def get_all
		result = @db.execute('SELECT * FROM edits')
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

	def get_all_with_user(id)
		result = @db.execute('SELECT * FROM edits WHERE user IS ?', id)
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

	def get_all_with_post(id)
		result = @db.execute('SELECT * FROM edits WHERE post IS ?', id)
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
