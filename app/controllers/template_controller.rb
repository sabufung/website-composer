class TemplateController < ApplicationController

	def list
		@templates = Template.all;
	end

	def show
		@template = Template.find(params[:id]);
	end

end
