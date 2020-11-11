require 'rails_helper'

describe "As a merchant employee" do
  describe "When I visit my employer's bulk discounts index page" do
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
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3)
      @bulk_discount_1 = @brian.bulk_discounts.create(item_quantity: 10, percentage: 10)

      visit "/login"
      fill_in :email, with: @user_2.email
      fill_in :password, with: @user_2.password
      click_button "Log In"
    end

    it "has an delete button that deletes the discount" do
      visit merchant_merchant_bulk_discounts_path(@brian)

      within("#bulk-discount-#{@bulk_discount_1.id}") do
        expect(page).to have_content("Order #{@bulk_discount_1.item_quantity} of any item, get #{@bulk_discount_1.percentage}% off!")
        expect(page).to have_button("Delete Discount")
        click_button("Delete Discount")
      end

      expect(current_path).to eq(merchant_merchant_bulk_discounts_path(@brian))
      expect(page).to have_content("Discount deleted successfully.")
      expect(page).to have_content("You have no bulk discounts yet or all of them have been deleted.")
    end
  end
end
