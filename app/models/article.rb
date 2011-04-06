class Article < Content
  set_table_name "articles"

  validates_presence_of :body
end
