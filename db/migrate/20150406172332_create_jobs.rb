class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.float :lat
      t.float :long
      t.string :company
      t.string :position
      t.string :country
      t.string :state
      t.string :url
      t.references :city, index: true
      t.date :date_posted
      t.text :description 
      t.string :job_key
      t.integer :creator_id

      t.timestamps null: false
    end
    add_foreign_key :jobs, :cities
  end
end
