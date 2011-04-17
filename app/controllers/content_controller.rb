class ContentController < ApplicationController

  def new
    @content = Content.new
  end

  def create
    @content = Content.new(params[:content])
    @content = @content.becomes(@content.kind.constantize)
    if @content.save
      flash[:success] = "#{@content.kind} created"
      redirect_to edit_content_path(@content)
    else
      flash.now[:error] = "Could not create content"
      render :action => "new"
    end
  end

  def edit
    @content = Content.find(params[:id])
    @content = @content.get_origin_type
  end

end
