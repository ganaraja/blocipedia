require 'faker'

50.times do
user =  User.new(
    email: Faker::Internet.email,
    password:Faker::Internet.password
  )
  user.skip_confirmation!
  user.save
end

users = User.all

100.times do
  Wiki.create!(
    title: Faker::Name.name,
    body: Faker::Lorem.paragraph,
    user: users.sample
  )
end

wikis = Wiki.all

puts "Seeds finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"
