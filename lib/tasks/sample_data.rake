namespace :db do
	desc "Fill database with sample data"
	task populate: :environment  do
		admin = User.create!(	name: "Nitin Gugale",
													email: "nitinngugale21@gmail.com",
													password: "test123",
													password_confirmation: "test123")
		admin.toggle!(:admin)
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@test.com"
			password = "test123"
			User.create!(	name: name, email: email, password: password,
										password_confirmation: password)
		end
		
		users = User.all(limit: 5)
		50.times do
			content = Faker::Lorem.sentence(5)
			users.each { |user|  user.microposts.create!(content: content) }
		end
	end
end