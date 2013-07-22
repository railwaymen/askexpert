module Indexable
  extend ActiveSupport::Concern

  included do
    after_commit :reindex_user
  end

  protected

  def reindex_user
    Sunspot.index!(user) if user
  end
end