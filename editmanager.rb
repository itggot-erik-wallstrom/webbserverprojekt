require_relative './edit.rb'
require 'time'

class EditManager
	def initialize(db)
		@db = db
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
