class Job < ActiveRecord::Base
  belongs_to :city
  has_many :job_users
  has_many :users, through: :job_users

  # validates :name, :position, :description, :url, presence: true
end
