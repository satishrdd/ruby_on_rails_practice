class User < ApplicationRecord
    has_many :microposts, dependent: :destroy 
    has_many :active_relationships , class_name: "Relationship" , foreign_key: "follower_id" , dependent: :destroy
    has_many :passive_relationships , class_name: "Relationship" , foreign_key: "followed_id" , dependent: :destroy 
    has_many :following ,through: :active_relationships, source: :followed 
    has_many :followers ,through: :passive_relationships, source: :follower  
	attr_accessor :remember_token
	before_save {email.downcase!}
	validates :name,presence:true,length: {maximum:50}
	validates :email,presence:true,length: {maximum:250},format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password,presence: true,length: {minimum: 6}
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
    	SecureRandom.urlsafe_base64
    end

    def feed
        Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id) 
    end
    def remember
    	self.remember_token = User.new_token
    	update_attribute(:remember_digest,User.digest(remember_token))
    end

    def authenticated?(remember_token)
    	return false if remember_digest.nil?
    	BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	def forget
		update_attribute(:remember_digest,nil)
	end

    def follow(other_user)
        following << other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end

    def following?(other_user)
        following.include?(other_user)
    end
end
