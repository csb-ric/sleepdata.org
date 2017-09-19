class CreateLegalDocumentVariables < ActiveRecord::Migration[5.1]
  def change
    create_table :legal_document_variables do |t|
      t.integer :legal_document_id
      t.integer :legal_document_page_id
      t.integer :position
      t.string :name
      t.string :variable_type
      t.string :display_name
      t.text :description
      t.string :field_note
      t.boolean :required
      t.boolean :deleted
      t.index :legal_document_id
      t.index :legal_document_page_id
      t.index :position
      t.index :name
      t.index :deleted
      t.timestamps
    end
  end
end