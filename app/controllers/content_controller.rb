class ContentController < ApplicationController

  def new
    @content = Content.new
  end

end
