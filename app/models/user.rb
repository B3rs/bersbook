class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	     :recoverable, :rememberable, :trackable, :validatable

	validates_presence_of :username
	validates_uniqueness_of :username

	has_many :friendships, dependent: :destroy
	has_many :inverse_friendships, class_name: 'Friendship', foreign_key: :friend_id, dependent: :destroy

	def request_friendship(to_user)
		self.friendships.create(friend: to_user)
	end

	def active_friends
		self.friendships.active.map(&:friend) + self.inverse_friendships.active.map(&:user)
	end

	def pending_friend_requests_to
  		self.friendships.pending
  	end

  	def pending_friend_requests_from
	  	self.inverse_friendships.pending
	end

	def friendship_status(to_user)
		friendship = Friendship.where(user_id: [self.id,to_user.id], friend_id: [self.id,to_user.id]).first
		unless friendship
			return 'not_friends'
		else
			if friendship.state == "active"
        		return "friends"
      		elsif friendship.user == self
          		return "pending"
        	else
          		return "requested"
          	end
        end
	end

end
