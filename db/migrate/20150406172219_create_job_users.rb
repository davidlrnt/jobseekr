class CreateJobUsers < ActiveRecord::Migration
  def change
    create_table :job_users do |t|
      t.references :user, index: true
      t.references :job, index: true
      t.boolean :applied, default: false

      t.timestamps null: false
    end
    # add_foreign_key :job_users, :users
    # add_foreign_key :job_users, :jobs
  end
end
