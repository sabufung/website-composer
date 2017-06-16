class PagesController < ApplicationController
  require 'zip'
  require 'tempfile'
  def index
    @template = Template.find(params[:id])
    @pages = @template.pages
    @articles = Article.all
  end

  def previewajax
    @templateId = params[:templateId]
    @pageId = params[:pageId]
    @ids = params[:articleIds]
    @articles = Array.new
    @ids.each do |id|
      @article = Article.find(id)
      @articles << @article
    end

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

  def appendPage
    @pageContent = Page.find(params[:pageId]).content

    jsonRes = {
        :succes => true,
        :content => @pageContent
    }

    render :json => jsonRes
  end

  def appendArticle
    @article = Article.find(params[:articleId])

    jsonRes = {
        :success => true,
        :content => @article.content
    }

    render :json => jsonRes
  end

  def export
    web = params[:web]
    input_filenames_path = []
    web.each do |page|
      @articles = ""
      page[1].each do |article|
        page_article = Article.find(article)
        @articles << "<div>#{page_article.content}</div>"
      end
      web_page = Page.find(page[0])
      web_page.content.gsub!(/%ARTICLE%/, @articles)
      File.open("#{Rails.root}/tmp/#{web_page.name}.html", 'w+') do |f|
        f.write(web_page.content)
      end


      input_filenames_path << "#{web_page.name}.html"


      # Two arguments:
      # - The name of the file as it will appear in the archive
      # - The original file, including the path to find it
      #Add files to the zip file as usual

      # input_filenames_path << temp_file
    end
    temp_file = Tempfile.new(["archive"])
    input_filenames_path.each do |file|
      # Zip::OutputStream.open("#{Rails.root}/tmp/#{file}")
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zip|
        #Put files in here
        zip.add(File.basename("#{Rails.root}/tmp/#{file}"), "#{Rails.root}/tmp/#{file}")
      end

    end
    render :json => {:url => temp_file.path}
  end

  def download
    zip_data = File.read(params[:file_path])
    send_data(zip_data, :type => 'application/zip', :filename => "archive.zip")
  end
end
