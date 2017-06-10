class PagesController < ApplicationController

  def index
    @pages = Template.find(params[:id]).pages
  end

end
