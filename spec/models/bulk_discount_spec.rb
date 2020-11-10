require 'rails_helper'

describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_numericality_of :item_quantity}
    it { should validate_presence_of :merchant_id}
    it { should validate_numericality_of :percentage}
  end

  describe "relationships" do
    it { should belong_to :merchant }
  end
end
