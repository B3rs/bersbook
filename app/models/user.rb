class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	validates_presence_of :username
	validates_uniqueness_of :username

	def request_friendship(to_user)
		self.friendships.create(friend: to_user)
	end
end
