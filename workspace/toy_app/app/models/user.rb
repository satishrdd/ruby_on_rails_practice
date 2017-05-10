class User < ApplicationRecord
	before_save {email.downcase!}
	validates :name,presence:true,length: {maximum:50}
	validates :email,presence:true,length: {maximum:250},format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i},uniqueness: {case_sensitive: false}
	has_secure_password
	validates :password,presence: true,length :{minimum: 6}
end
