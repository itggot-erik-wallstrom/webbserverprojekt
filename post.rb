# A representation of a Post in the database
class Post
	attr_reader :id, :text, :title, :creator, :creation_date, 
		:modification_date

	def initialize(id, text, title, creator, creation_date, modification_date)
		@id = id
		@text = text
		@title = title
		@creator = creator
		@creation_date = creation_date
		@modification_date = modification_date
	end

	# Changes the text member
	# @param text [String] the new text
	def update(text)
		@modification_date = DateTime.now.strftime('%Y-%m-%d %H:%M')
		@text = text
	end
end
