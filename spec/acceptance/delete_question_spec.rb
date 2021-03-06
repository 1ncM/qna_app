require_relative 'acceptance_helper'

feature 'author can delete your question', %q{
  In order to don't be ashamed for asked question
  An a asker
  I want to be able delete question
} do
  given!(:user) { create(:user) }

  before(:each) do
    sign_in(user)
    @question = create(:question, user: user)
  end

  scenario 'Asker can delete your question' do
    visit question_path(@question)
    expect(page).to have_link 'Delete question'

    click_on 'Delete question'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content @question.title
  end 

  scenario 'Authenticated user can not delete question asked by other user' do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)
    expect(page).to_not have_link 'Delete question'
  end

  scenario 'Non-authenticated user can not see the Delete question link' do
    sign_out
    visit question_path(@question)
    expect(page).to_not have_link 'Delete question'
  end
end