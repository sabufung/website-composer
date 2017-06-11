class PagesController < ApplicationController

  def index
    @templateId = params[:id]
    @pages = Template.find(params[:id]).pages
    @articles = Article.all
  end

  def previewajax
    @templateId = params[:templateId]
    @pageId = params[:pageId]
    @ids = params[:articleIds]
    @articles = [] #load html dc r ne
    
    @ids.each do |id|
      @article = Article.find(id)
      @articles << @article
    end

    p "debug ne"
    p @articles

    flash[:template_id] = @templateId
    flash[:page_id] = @pageId
    flash[:selected_articles] = @articles

    jsonRes = {
        :success => true,
    }

    render :json => jsonRes
  end

  def preview
    @template = Template.find(flash[:template_id])
    @page = Page.find(flash[:page_id])
    @articles = flash[:selected_articles]


  end

end
