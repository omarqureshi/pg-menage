module PgArelHack
  extend ActiveSupport::Concern

  module ClassMethods
    def arel_table
      @arel_table ||= Arel::PgArelHack.new(table_name, arel_engine)
    end
  end

end

class Arel::PgArelHack < Arel::Table
  def primary_key
    @primary_key ||= self[:id]
  end

  def table_exists?
    true
  end
end
