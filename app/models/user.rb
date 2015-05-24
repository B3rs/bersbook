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
		# This is really ugly, I will figure out something
		#self.friendships.active.map(&:friend) + self.inverse_friendships.active.map(&:user)
		# Maybe this is better!
		User.where('"users"."id" IN 
	      (
	        SELECT "friendships"."user_id" FROM "friendships"
	        WHERE "friendships"."friend_id" = ? AND "friendships"."state" = "active"
	      )
	      OR "users"."id" IN
	      (
	        SELECT "friendships"."friend_id" FROM "friendships" 
	        WHERE "friendships"."user_id" = ? AND "friendships"."state" = "active"
	      )', self.id, self.id)
	end

	def pending_friend_requests_to
  		self.friendships.pending
  	end

  	def pending_friend_requests_from
	  	self.inverse_friendships.pending
	end

	def friendship_status(to_user)
		# Very ugly, does a query every time is called... better fix that later
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
