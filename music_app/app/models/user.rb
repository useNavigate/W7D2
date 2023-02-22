# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

#step 1. do basic validations for (email,session_token) and password_digest

#step 2. explicitly make password getter and setter by using attr_reader and custom setter for password
###step 2A-1 def password=(password)
###step 2A-2. password_digest != self.password_digest => need to put self at the front becase other wise this is just conisdered as reg.variable rail cannot find it
###step 2A-3  we need to store BCrypt version of password_digest
###step 2A-4  make sure to make @password instance for getter to find it other wise it will cause an error.

#step 2-B.make is_it_password? to define if its password.
###step 2B-1 need to convert "password_digest" to BCrypt class to compare
###step 2B-2 we can use BCrypt built in method called ".is_password(arg)" to check

#step 3.def ensure_session_token
###step 3A-1 def generate_unique_session_token

#step 4.before_validation :ensure_session_token

#step 5.User::find_by_credentials(email, password)
#step 6 when user sign up or log in we need to make sure to reset the token to new token

class User < ApplicationRecord

  #Step 1
  validates :email, :session_token, presence: true, uniqueness: true
  validates :password_digest, length: { minimum: 6 }, allow_nil: true

  #Step 2
  attr_reader :password

  #step 4
  before_validation :ensure_session_token

  #Step 2A
  def password=(password)
    #assign password_digest to crypted version
    self.password_digest = BCrypt::Password.create(password)
    #make sure to assign password instance variable for getter and setter oher wise it errors
    @password = password
  end

  #Step 2B
  def is_it_password?(password)
    #1. convert the password_digest to bcrypt object
    bcrypt_obj = BCrypt::Password.new(self.password_digest)
    #2. check if its the password by either using is_password? or double = sign as ==
    bcrypt_obj.is_password?(password)
  end

  #Step 3
  def ensure_session_token
    #if it already has session_token other wise generate new one
    self.session_token ||= generate_unique_session_token
  end

  #Step 3A-1
  def generate_unique_session_token
    #generate new token
    token = SecureRandom::urlsafe_base64
    #make sure it's unique one other wise generate till its unique
    while User.exists?(session_token: token)
      token = SecureRandom::urlsafe_base64
    end
    #return the unique token
    token
  end

  #step 5
  def self.find_by_credentials(email, password)
    #user is trying to login.  need to find user based on their input
    #remember we do not have password. and username is unique so we need to find the user based on their userame first
    user = User.find_by(email: email)
    if user && user.is_it_password?(password) #password is user input and is_password give us boolean return
      user #user is logged in !
    else
      nil #not going to return anything because this person needs to sign up first
    end
  end

  #step6
  # i need this part to log in
  def reset_session_token!
    self.session_token = generate_unique_session_token
    self.save!
    self.session_token
  end
end
