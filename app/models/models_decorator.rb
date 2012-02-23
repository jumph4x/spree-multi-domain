Spree::Product.class_eval do
  has_and_belongs_to_many :stores
  scope :by_store, lambda {|store| joins(:stores).where("products_stores.store_id = ?", store)}
end

Spree::Order.class_eval do
  belongs_to :store
  scope :by_store, lambda { |store| where(:store_id => store.id) }
end

Spree::Taxonomy.class_eval do
  belongs_to :store
end

Spree::Tracker.class_eval do
  belongs_to :store

  def self.current(domain)
    trackers = Spree::Tracker.find(:all, :conditions => {:active => true, :environment => ENV['RAILS_ENV']})
    trackers.select { |t| t.store_id == Spree::Store.current(domain).try(:id) }.first
  end
end
