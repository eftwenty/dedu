class CreateTheories < ActiveRecord::Migration[5.0]
  def change
    create_table :theories do |t|
      t.references :course, foreign_key: true
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
