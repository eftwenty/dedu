class CreateJoinTableGroupCourse < ActiveRecord::Migration[5.0]
  def change
    create_join_table :groups, :courses do |t|
      # t.index [:group_id, :course_id]
      t.index [:course_id, :group_id]
    end
  end
end
