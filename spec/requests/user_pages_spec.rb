require 'spec_helper'

describe "User pages" do

	subject { page }

	describe "index" do
		let(:user) { FactoryGirl.create(:user) }

		before(:all) { 30.times { FactoryGirl.create(:user) } }
		after(:all) { User.delete_all }

		before(:each) do
			valid_sign_in user
 			visit users_path	
		end

		it { should have_selector('title', 	text: 'All Users') }
		it { should have_selector('h1', 		text: 'All Users') }

		describe "pagination" do
			it "should list each user" do
				# per_page need to be same as in users_controller.
				User.paginate(page: 1, per_page: 5).each do |user|
					# Test for a link(a) inside li
					page.should have_selector('li>a', text: user.name)
				end
			end

			it { should have_selector('div.pagination') }
		end

		describe "delete links" do
		  it { should_not have_link('delete') }

		  describe "as an admin user" do
		  	let(:admin) { FactoryGirl.create(:admin) }
		  	before do
		  		 valid_sign_in admin
		  		 visit users_path
		  	end

				it { should have_link('delete', href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect { click_link('delete') }.to change(User, :count).by(-1)	  	  
				end	  
				it { should_not have_link('delete', href: user_path(admin)) }	
		  end
		end
	end

	describe "Signup page" do
		before { visit signup_path }
				
		it { should have_selector('h1', 		text: 'Sign Up') }
		it { should have_selector('title', 	text: full_title('Sign Up')) }
	end

	describe "Profile page" do
		let(:test_user) { FactoryGirl.create(:user) }

		before { visit user_path(test_user) }
		
		it { should have_selector('h1', 		text: test_user.name) }
		it { should have_selector('title', 	text: test_user.name) }
	end

	describe "Signup" do
		before { visit signup_path }

		let(:submit) { "Create my account" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_selector('title', test: 'Sign up') }
				it { should have_content('error') }
				it { should_not have_content('Password digest') }
			end 
		end

		describe "with valid information" do

			before do
				fill_in "Name", with: "Example User"
				fill_in "Email", with: "user@example.com"
				fill_in "Password", with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)				
			end 
			
			describe "after saving a user" do
				before { click_button submit }
	
				let(:user) { User.find_by_email("user@example.com") }

				it { should have_selector('title', text: user.name) }
				it { should have_selector('div.alert.alert-success', text: 'Welcome') }
				it { should have_link('Sign Out', href: signout_path) }
			end
		end
	end

	describe "edit" do
		before do
			valid_sign_in user
			visit edit_user_path(user)
		end

		let(:user) { FactoryGirl.create(:user) }
		let(:save) { "Save changes" }

		describe "page" do
			it { should have_selector('h1', text: 'Update your profile') }
			it { should have_selector('title', text: full_title('Edit User')) }
			it { should have_link('change', href: 'http://gravatar.com/emails') }
		end

		describe "with invalid information" do
			before { click_button save }
			it { should have_content('error') }
		end

		describe "with valid information" do
			let(:new_name) { "New Name" }
			let(:new_email) { "new@email.com" }

			before do
				fill_in "Name", 						with: new_name
				fill_in "Email", 						with: new_email
				fill_in "Password", 				with: user.password
				fill_in "Confirm Password", with: user.password
				click_button save
			end

			it { should have_selector('title', text: new_name) }
			it { should have_link('Sign Out', href: signout_path) }
			it { should have_selector('div.alert.alert-success', text: 'Profile updated') }
			specify { user.reload.name.should == new_name }
			specify { user.reload.email.should == new_email }
		end
	end
end
