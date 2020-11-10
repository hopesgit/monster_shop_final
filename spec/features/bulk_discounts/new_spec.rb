require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit the new discount page" do
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

    it "has a form to create a new bulk discount" do
      visit new_merchant_merchant_bulk_discount_path(@brian)

      expect(page).to have_content("Minimum Quantity")
      expect(page).to have_content("Percent off (ex: input 5 for 5% off)")
      expect(page).to have_button("Create Bulk discount")

      fill_in "Minimum Quantity", with: 5
      fill_in "Percent off (ex: input 5 for 5% off)", with: 5
      click_button "Create Bulk discount"

      expect(page).to have_content("Bulk discount created.")

      last_discount = BulkDiscount.last
      expect(last_discount.merchant_id).to eq(@brian.id)
    end

    it "has a flash message for when the fields aren't filled out correctly" do
      visit new_merchant_merchant_bulk_discount_path(@brian)

      fill_in "Minimum Quantity", with: 5
      fill_in "Percent off (ex: input 5 for 5% off)", with: "five percent"
      click_button "Create Bulk discount"

      expect(page).to have_content("Form not filled out completely.")
    end
  end
end
