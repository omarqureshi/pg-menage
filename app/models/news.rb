class News < Article
  set_table_name "news"
  validates_presence_of :synopsis, :if => Proc.new {|c| c.published?}
end
