class PagesController < ApplicationController

  def index
    @pages = Template.find(params[:id]).pages
    @articles = Article.all
  end

  def export
    
  end

end
