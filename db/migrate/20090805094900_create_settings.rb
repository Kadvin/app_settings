class CreateSettings < ActiveRecord::Migration

  def self.up
    create_table :settings, :force => true, :comment=>"系统配置" do |t|
      t.string "key",   :null => false, :comment=>"键", :default => ""
      t.string "value", :null => true,  :comment=>"值", :default => ""
      t.string "description", :comment=>"描述"
    end
    add_index :settings, ["key"], :name => "index_settings_on_key", :unique => true
  end

  def self.down
    drop_table :settings
  end

end