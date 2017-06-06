class AddAttachmentDocumentToTheories < ActiveRecord::Migration
  def self.up
    change_table :theories do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :theories, :document
  end
end
