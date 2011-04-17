require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  context "with a published article" do
    subject { FactoryGirl.build(:article, :published => true) }
    should validate_presence_of :title
    should validate_presence_of :start_date
    should validate_presence_of :body
  end

  context "with a non-published article" do 
    should validate_presence_of :title
    should validate_presence_of :start_date
    should_not validate_presence_of :body
  end
    
  context "when creating content" do
    setup do
      @content = []
      @content << FactoryGirl.create(:content, :title => "Content A", :start_date => 1.week.ago.to_date, :published => true)
      @content << FactoryGirl.create(:article, :title => "Content B", :start_date => 1.week.ago.to_date, :published => true)
    end
    
    should "not get confused with content when querying published articles" do
      published_articles = Article.published
      assert_equal published_articles.size, 1
      assert_equal published_articles.first.title, "Content B"
    end
  end

end
