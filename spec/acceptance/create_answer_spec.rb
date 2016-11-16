require 'rails_helper'

feature 'Create answer for question', %q{
  In order to help solve the problem
  As an authenticated user
  I want to be able to write answer for question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user can create answer for question', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'Answer body'
    click_on 'Post your answer'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'Answer body'
    end
  end

  scenario 'Authenticated user submit empty answer for the question' do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: ''
    click_on 'Post your answer'
    expect(current_path).to eq question_path(question)
    expect(page).to have_content "Field 'Body' must not be empty"
  end

  scenario 'Non-Authenticated user can not create answer for question' do
    visit question_path(question)
    expect(page).to_not have_link 'Post your answer'
  end
end