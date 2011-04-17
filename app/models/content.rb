class Content < ActiveRecord::Base

  scope :published, :conditions => "start_date <= now()::date and (end_date is null or end_date > now()::date) and published"
  
  validates_presence_of :title
  validates_presence_of :start_date

  attr_accessor :kind

  cattr_accessor :children
  
  def get_origin_type
    connection.select_value(
    "select p.relname
     from content c, pg_class p
     where c.tableoid = p.oid and c.id = #{id}"
     ).classify.constantize.find(id)
  end
  
  def self.children
    unless @@children
      main_oid = connection.select_value("select attrelid from pg_attribute where attrelid = '#{self.to_s.tableize}'::regclass limit 1;")
      @@children = []
      add_children(main_oid)
    end
    @@children
  end

  def self.add_children(parent_oid)
    inherited_children = connection.select_values("select inhrelid from pg_inherits where inhparent = #{parent_oid};")
    inherited_children.each do |child|
      child_name = connection.select_value("select relname from pg_class where oid = #{child}")
      @@children << child_name.classify.constantize
      add_children(child)
    end
  end

end
