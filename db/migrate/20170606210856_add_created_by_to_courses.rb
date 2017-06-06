class AddCreatedByToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :created_by, :integer
  end
end
