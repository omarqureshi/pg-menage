require 'test_helper'

class ContentTest < ActiveSupport::TestCase
  should validate_presence_of :title
  should validate_presence_of :start_date

  context "when dealing with children of content" do
    setup do
      @content = []
      @content << FactoryGirl.create(:article, :title => "Content A", :start_date => 1.week.ago.to_date, :published => true)
    end

    should "be able to see them" do
      assert_equal Content.published.size, 1
    end
  end

  context "when dealing with a stack of existing content" do
    setup do
      @content = []
      @content << FactoryGirl.create(:content, :title => "Content A", :start_date => 1.week.ago.to_date, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content B", :start_date => 1.week.from_now.to_date, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content C", :start_date => Date.today, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content D", :start_date => Date.today, :end_date => 1.week.from_now.to_date, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content E", :start_date => 1.week.ago.to_date, :end_date => 1.day.ago.to_date, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content F", :start_date => 1.week.ago.to_date, :end_date => Date.today, :published => true)
      @content << FactoryGirl.create(:content, :title => "Content G", :start_date => 1.week.ago.to_date, :published => false)
    end

    should "be able to see content from last week with no end date in the published content" do
      assert Content.published.where("title = ?", "Content A").first
    end

    should "not be able to see content which is to be published in the future" do
      assert_nil Content.published.where("title = ?", "Content B").first
    end

    should "be able to see content which is to be published today" do
      assert Content.published.where("title = ?", "Content C").first
    end

    should "be able to see content which has an end date in the future" do
      assert Content.published.where("title = ?", "Content D").first
    end

    should "not be able to see content has an end date that has passed" do
      assert_nil Content.published.where("title = ?", "Content E").first
    end

    should "not be able to see content which has an end date of today" do
      assert_nil Content.published.where("title = ?", "Content F").first
    end

    should "not be able to see otherwise publishable content that has a published flag value of false" do
      assert_nil Content.published.where("title = ?", "Content G").first
    end
  end

  should "be able to see children" do
    assert Content.children.include?(Article)
  end

end
