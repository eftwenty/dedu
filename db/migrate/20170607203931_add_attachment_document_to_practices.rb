class AddAttachmentDocumentToPractices < ActiveRecord::Migration
  def self.up
    change_table :practices do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :practices, :document
  end
end
