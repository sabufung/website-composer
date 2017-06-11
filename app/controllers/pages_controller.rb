class PagesController < ApplicationController

  def index
    @templateId = params[:id]
    @pages = Template.find(params[:id]).pages
    @articles = Article.all
  end

  def preview
    @ids = params[:articleIds]
    @articles = Array.new

    @ids.each do |id|
      @article = Article.find(id)
      @articles << @article
    end
  end
end
