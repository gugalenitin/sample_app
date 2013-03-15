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
	end
end