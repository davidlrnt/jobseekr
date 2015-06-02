class CreateJobUsers < ActiveRecord::Migration
  def change
    create_table :job_users do |t|
      t.references :user, index: true
      t.references :job, index: true
      t.boolean :applied, default: false

      t.timestamps null: false
    end
  end
end
