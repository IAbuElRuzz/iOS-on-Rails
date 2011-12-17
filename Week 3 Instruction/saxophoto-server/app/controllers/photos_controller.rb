class PhotosController < ApplicationController
  
  respond_to :json
  
  def create
    @photo = Photo.create(params[:photo])
    
    respond_with(@photo)
  end
  
end
