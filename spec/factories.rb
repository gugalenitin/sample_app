FactoryGirl.define do
	
	factory :user do
		sequence(:name) { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@test.com" }
		#name "Nitin Gugale"
		#email "nitinngugale21@gmail.com"
		password "test123"
		password_confirmation "test123"

		factory :admin do
			admin true
		end
	end
end
