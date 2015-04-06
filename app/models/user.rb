class User < ActiveRecord::Base
  has_many :job_users
  has_many :jobs, through: :job_users
end
