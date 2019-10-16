class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.string :genre
      t.integer :user_id
    end
  end
end
