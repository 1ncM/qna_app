require_relative 'acceptance_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user)}

  scenario 'Authenticated user try edit your question', js: true do
    sign_in user
    visit question_path(question)
    expect(page).to have_link 'Edit question'
    click_on 'Edit question'
    fill_in 'question_title', with: 'edit title'
    fill_in 'question_body', with: 'edit body'
    click_on 'Save'

    expect(page).to have_content 'edit title'
    expect(page).to have_content 'edit body'
    expect(page).to_not have_content question.body
    expect(page).to_not have_content question.title
    within '.question' do
      expect(page).to_not have_selector 'textarea'
      expect(page).to_not have_selector 'textfield'
    end
  end 

end
