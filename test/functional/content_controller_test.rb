require 'test_helper'

class ContentControllerTest < ActionController::TestCase

  context "when requesting the new content page" do
    setup do
      get :new
    end
    should respond_with :success
    should render_template "new"
    should render_with_layout "application"
    should_not set_the_flash
    should assign_to :content
  end

end
