class AddAddictionalToUsers < ActiveRecord::Migration
	# No need to up and down, rails knows how to rollback
	def change
		add_column :users, :bio, :text
		add_column :users, :age, :integer
		add_column :users, :gender, :string
	end
end
