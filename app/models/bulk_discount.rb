class BulkDiscount < ApplicationRecord
  belongs_to :merchant
  validates :item_quantity, numericality: { greater_than: 0}
  validates :percentage, numericality: { greater_than: 0}
  validates_presence_of :merchant_id
end
