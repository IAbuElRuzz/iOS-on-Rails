class Photo < ActiveRecord::Base
  has_attached_file :image, 
                    :styles => {:thumbnail => "100x100#"}
  
end
