class PhotosController < ApplicationController
  
  respond_to :json
  
  def index
    @photos = Photo.all
    
    respond_with({:photos => @photos}.as_json)
  end
  
  def create
    @photo = Photo.create(params[:photo])
    
    respond_with(@photo)
  end
  
end
