class Photo < ActiveRecord::Base
  has_attached_file :image, 
                    :styles => {:thumbnail => "100x100#"}
  
  
  def as_json(options = {})
    {
      :image_urls => {
        :original => "http://localhost:3000" + self.image.url, # TODO Remove Egregious Hack™
        :thumbnail => "http://localhost:3000" + self.image.url(:thumbnail)
      },
      :timestamp => self.created_at
    }
  end
end
