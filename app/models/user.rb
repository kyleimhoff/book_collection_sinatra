class User < ActiveRecord::Base
    has_secure_password
    validates :username, presence: true, uniqueness:true
    has_many :books, foreign_key: "user_id"
end
