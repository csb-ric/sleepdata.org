class AddDataUserTypeToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :data_user_type, :string, null: false, default: "individual"
    add_index :users, :data_user_type
  end
end
