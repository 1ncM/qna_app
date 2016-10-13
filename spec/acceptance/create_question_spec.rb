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
    fill_in :title, with: 'text title'
    fill_in :body, with: 'text body'
    click_on 'Post your question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'text title'
    expect(page).to have_content 'text body'
  end

end