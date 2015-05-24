class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	validates_presence_of :username
	validates_uniqueness_of :username

	has_many :friendships, dependent: :destroy
	has_many :inverse_friendships, dependent: :destroy

	def request_friendship(to_user)
		self.friendships.create(friend: to_user)
	end

	def active_friends
		# This is really ugly, I will figure out something
		self.friendships.active.map(&:friend) + self.inverse_friendships.active.map(&:user)
	end

	def pending_friend_requests_to
  		self.friendships.pending
  	end

  	def pending_friend_requests_from
	  	self.inverse_friendships.pending
	end
end
