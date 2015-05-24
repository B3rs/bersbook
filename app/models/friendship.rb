class Friendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: 'User'

	scope :active, -> {where(state: 'active')}
	scope :pending, -> {where(state: 'active')}

	def accept_friendship
		self.update_attributes(state: 'active', friended_at: Time.now)
	end

	def deny_friendship
		self.destroy
	end

	alias_method :cancel_friendship, :deny_friendship
end