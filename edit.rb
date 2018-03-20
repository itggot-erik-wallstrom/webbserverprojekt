class Edit
	attr_reader :id, :date, :new_text, :old_text, :user, :post

	def initialize(id, date, new_text, old_text, user, post)
		@id = id
		@date = date
		@new_text = new_text
		@old_text = old_text
		@user = user
		@post = post
	end
end
