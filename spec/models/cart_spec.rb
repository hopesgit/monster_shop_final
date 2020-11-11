require 'rails_helper'

RSpec.describe Cart do
  describe 'Instance Methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )

      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)

      @cart.add_item(@giant.id.to_s)
      @megan.bulk_discounts.create!(item_quantity: 3, percentage: 5)

      expect(@cart.grand_total).to eq(162.5)

      @cart.add_item(@giant.id.to_s)
      @megan.bulk_discounts.create!(item_quantity: 4, percentage: 10)

      expect(@cart.grand_total).to eq(200)


    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      @cart.contents[@ogre.id.to_s] = 4

      expect(@cart.limit_reached?(@ogre.id)).to eq(false)

      @cart.add_item(@ogre.id.to_s)

      expect(@cart.limit_reached?(@ogre.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.discounted_subtotal()' do
      @megan.bulk_discounts.create!(item_quantity: 3, percentage: 5)
      @megan.bulk_discounts.create!(item_quantity: 4, percentage: 10)

      expect(@cart.subtotal_of(@giant.id)).to eq(100)

      @cart.add_item(@giant.id.to_s)

      expect(@cart.subtotal_of(@giant.id)).to eq(150)
      expect(@cart.discounted_subtotal(@giant.id, @cart.contents[@giant.id.to_s])).to eq(142.5)

      @cart.add_item(@giant.id.to_s)

      expect(@cart.subtotal_of(@giant.id)).to eq(200)
      expect(@cart.discounted_subtotal(@giant.id, @cart.contents[@giant.id.to_s])).to eq(180)
    end

    it '.discounted_price()' do
      @megan.bulk_discounts.create!(item_quantity: 3, percentage: 5)
      @megan.bulk_discounts.create!(item_quantity: 4, percentage: 10)

      @cart.add_item(@giant.id.to_s)
      @cart.add_item(@giant.id.to_s)

      price_without_discount = @giant.price * @cart.contents[@giant.id.to_s]
      price_with_discount = @cart.discounted_price(@giant.id, @cart.contents[@giant.id.to_s]) * @cart.contents[@giant.id.to_s]

      expect(price_without_discount).to eq(200)
      expect(price_with_discount).to eq(180)
    end
  end
end
