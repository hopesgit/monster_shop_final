# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 500 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 300 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 300 )

# Users
user_1 = User.create!(name: "Melody",
                      address: "222 Song Ln",
                      city: "Harmony",
                      state: "CO",
                      zip: 80020,
                      email: "melody@example.com",
                      password: "Seekrit",
                      role: 0,
                      merchant_id: nil)
user_2 = User.create!(name: "Alex",
                      address: "1041 Circle Cir",
                      city: "Denver",
                      state: "CO",
                      zip: 80012,
                      email: "alex@example.com",
                      password: "Trade Seekrit",
                      role: 1,
                      merchant_id: brian.id)
user_3 = User.create!(name: "Hope",
                      address: "222 Song Ln",
                      city: "Harmony",
                      state: "CO",
                      zip: 80020,
                      email: "hope@example.com",
                      password: "Server Seekrit",
                      role: 2,
                      merchant_id: nil)
