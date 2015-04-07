class User < ActiveRecord::Base
  has_many :job_users
  has_many :jobs, through: :job_users

  def self.create_with_omniauth(auth)
    @user = User.find_by(uid: auth_hash(auth)[:uid]) || User.create(auth_hash(auth))
  end

private
  def self.auth_hash(auth)
    {:provider => auth["provider"], :uid => auth["uid"], :name => auth["info"]["name"], :email => auth["info"]["email"], :img_url => auth["info"]["image"]}
  end

end

