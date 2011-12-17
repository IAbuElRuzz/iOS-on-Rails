class AddGeolocationFieldsToPhotos < ActiveRecord::Migration
  def change
    add_column :photos, :lat, :decimal, :precision => 15, :scale => 10
    add_column :photos, :lng, :decimal, :precision => 15, :scale => 10
  end
end
