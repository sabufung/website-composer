class AddContentToTemplate < ActiveRecord::Migration
  def change
    add_column :templates, :content, :string
  end
end
