require_relative 'acceptance_helper'

feature 'User can sign out', %q{
  In order to use the site on public computers
  As signed-in User
  I want to sign out
} do
  given(:user) { create(:user) }

  scenario 'authenticated user can sign out' do
    sign_in(user)
    visit questions_path
    expect(page).to have_selector(:link_or_button, 'Sign out')
    expect(page).to_not have_selector(:link_or_button, 'Sign in')
    expect(page).to_not have_selector(:link_or_button, 'Sign up')
    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully.')
    expect(page).to have_selector(:link_or_button, 'Sign in')
    expect(page).to have_selector(:link_or_button, 'Sign up')
    expect(page).to_not have_selector(:link_or_button, 'Sign out')
  end
end