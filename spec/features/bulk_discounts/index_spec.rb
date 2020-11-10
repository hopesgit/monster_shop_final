require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit my employer's page" do
    before :each do
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user_2 = User.create!(name: "Alex",
                            address: "1041 Circle Cir",
                            city: "Denver",
                            state: "CO",
                            zip: 80012,
                            email: "alex@example.com",
                            password: "Trade Seekrit",
                            role: 1,
                            merchant_id: @brian.id)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)

      visit "/login"
      fill_in :email, with: @user_2.email
      fill_in :password, with: @user_2.password
      click_button "Log In"
    end

    it "I see a link to access that merchant's discounts" do
      visit merchant_path(@brian)
      expect(page).to have_link("Go to Bulk Discounts")
      click_link("Go to Bulk Discounts")
      expect(current_path).to eq("/merchant/merchants/#{@brian.id}/bulk_discounts")
    end

    it "the index has these properties" do
      visit merchant_path(@brian)
      click_link("Go to Bulk Discounts")

      expect(page).to have_link("New Bulk Discount")
      expect(page).to have_content("Discounts")
      expect(page).to have_content("You have no bulk discounts yet or all of them have been deleted.")
      click_link("New Bulk Discount")

      expect(current_path).to eq(new_merchant_merchant_bulk_discount_path(@brian))
      expect(page).to have_content("New Bulk Discount")
    end

    it "the index shows discounts once they've been made" do
      visit merchant_merchant_bulk_discounts_path(@brian)

      expect(page).to have_content("You have no bulk discounts yet or all of them have been deleted.")
      
      visit new_merchant_merchant_bulk_discount_path(@brian)

      fill_in "Minimum Quantity", with: 5
      fill_in "Percent off (ex: input 5 for 5% off)", with: 5
      click_button "Create Bulk discount"

      last_discount = BulkDiscount.last

      within("#bulk-discount-#{last_discount.id}") do
        expect(page).to have_content("Order #{last_discount.item_quantity} of any item, get #{last_discount.percentage} off!")
      end
    end
  end
end
