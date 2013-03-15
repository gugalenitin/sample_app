include ApplicationHelper

def valid_sign_in(user)
	visit signin_path
	fill_in "Email", 	  with: user.email
	fill_in "Password", with: user.password
	click_button "Sign In"
	# Sign in when not using the Capybara.
	cookies[:remember_token] = user.remember_token
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end