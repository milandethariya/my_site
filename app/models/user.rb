class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token, :reset_token;
	before_save {self.email = email.downcase }
	before_create :create_activation_digest
	validates :name, presence: true, length: {maximum: 50}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 50}, format: {with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password,  presence: true, length: { minimum: 6 }, allow_nil: true

	def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def User.new_token
		SecureRandom.urlsafe_base64
	end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
  	update_attribute(:remember_digest, nil)
	end

	def create_activation_digest
		self.activation_token = User.new_token
		self.activation_digest =  User.digest(activation_token)
	end

	def authenticated_activate?(activation_token)
    BCrypt::Password.new(activation_digest).is_password?(activation_token)
  end

  def authenticated_reset?(reset_token)
    BCrypt::Password.new(reset_digest).is_password?(reset_token)
  end



  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

end
