require 'rails_helper'

feature 'User can sign up', %q{
  In order to be able to use features that requires authentication
  As non-registered User
  I want to be able to sign up
} do

  scenario 'Unregistered user tries to sign up and success' do
    visit questions_path

    click_on 'Sign up'

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistered user tries to sign up, but passwords are not match' do
    visit questions_path

    click_on 'Sign up'

    fill_in 'Email', with: 'test@email.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: 'uncorrect_pass'

    click_button 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Unregistered user tries to sign up, but email is already used' do
    visit questions_path

    click_on 'Sign up'

    fill_in 'Email', with: create(:user).email
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'

    click_button 'Sign up'
    expect(page).to have_content "Email has already been taken"
  end
end