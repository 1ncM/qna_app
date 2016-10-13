require 'rails_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do 
  given(:user) { create(:user) }
  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'text title'
    fill_in 'Body', with: 'text body'
    click_on 'Post your question'

    expect(page).to have_content 'text title'
    expect(page).to have_content 'text body'
  end

  scenario 'Non-Authenticated user creates question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end