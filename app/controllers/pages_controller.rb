class PagesController < ApplicationController
  require 'zip'
  require 'tempfile'
  def index
    @template = Template.find(params[:id])
    @pages = Template.find(params[:id]).pages
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

  def export
    # web = params[:web]
    # input_filenames_path = []
    # web.each do |page|
    #   @articles = ""
    #   page[1].each do |article|
    #     page_article = Article.find(article)
    #     @articles << "<div>#{page_article.content}</div>"
    #   end
    #   web_page = Page.find(page[0])
    #   web_page.content.gsub!(/%ARTICLE%/, @articles)
    #   temp_file = Tempfile.new("#{web_page.name}.html")
    #   temp_file.write(web_page)
    #   temp_file.close
    #   # File.open("#{Rails.root}/app/public/assets/#{web_page.name}.html", 'w+') do |f|
    #   #   f.write(web_page)
    #   # end
    #   input_filenames_path << temp_file
    # end
    # folder = "#{Rails.root}/app/public/assets"
    # zipfile_name = "#{Rails.root}/app/public/assets/archive.zip"
    # File.delete(zipfile_name) if File.exist?(zipfile_name)
    #
    #   input_filenames_path.each do |file|
    #
    #
    #     #Read the binary data from the file
    #   end
    file = Tempfile.new([ 'foobar', '.html' ])
    file.write("<p>something</p>")
    file.close

    Zip::OutputStream.open(file)

    # Two arguments:
    # - The name of the file as it will appear in the archive
    # - The original file, including the path to find it
    #Add files to the zip file as usual
    Zip::File.open(file.path, Zip::File::CREATE) do |zip|
      #Put files in here

      zip.add("clgt.html", file.path)
    end
    zip_data = File.read(file.path)

    #Send the data to the browser as an attachment
    #We do not send the file directly because it will
    #get deleted before rails actually starts sending it
    # send_data(zip_data, :type => 'application/zip', :filename => "filename.zip")
    render :json => {:url => file.path}
    # render :json => {:url => zipfile_name}
  end

  def download
    zip_data = File.read(params[:file_path])
    send_data(zip_data, :type => 'application/zip', :filename => "archive.zip")
  end
end
