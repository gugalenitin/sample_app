include ApplicationHelper

# Method def should come before the RSpec::Matchers defined below
def valid_signin(user)
	fill_in "Email", 	  with: user.email
	fill_in "Password", with: user.password
	click_button signin
end

RSpec::Matchers.define :have_error_message do |message|
	match do |page|
		page.should have_selector('div.alert.alert-error', text: message)
	end
end
