require 'rails_helper'

feature 'author can delete your question', %q{
  ...
  An a asker
  I want to be able delete question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) } 

  scenario 'Asker can delete your question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_link 'Delete question'

    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question.title
  end 

  scenario 'Asker can not delete question asked by other user' do

  end

end