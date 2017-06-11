class PagesController < ApplicationController
  require 'zip'
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
    render :json => @articles
  end

  def export
    web = params[:web]
    input_filenames = []
    web.each do |page|
      @articles = ""
      page[1].each do |article|
        page_article = Article.find(article)
        @articles << "<div>#{page_article.content}</div>"
      end
      web_page = Page.find(page[0])
      web_page.content.gsub!(/%ARTICLE%/, @articles)

      File.open("#{Rails.root}/public/output/#{web_page.name}.html", 'w+') do |f|
        f.write(web_page)
      end
      input_filenames << "#{web_page.name}.html"
    end
    folder = "#{Rails.root}/public/output"
    zipfile_name = "#{Rails.root}/public/output/archive.zip"
    File.delete(zipfile_name) if File.exist?(zipfile_name)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        # Two arguments:
        # - The name of the file as it will appear in the archive
        # - The original file, including the path to find it
        zipfile.add(filename, folder + '/' + filename)
      end
    end
    render :json => {:url => zipfile_name}
  end

  def download
    send_file(params[:file_path])
  end
end
