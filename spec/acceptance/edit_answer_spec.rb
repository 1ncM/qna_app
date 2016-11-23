require_relative 'acceptance_helper'

feature 'Editing answer', %q{
  In order to fix mastake
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user)}

scenario 'Unauthenticated user try to edit answer' do
  visit question_path(question)

  expect(page).to_not have_link 'Edit'
end

scenario 'Authenticated user try edit your answer', js: true do
  sign_in user

  visit question_path(question)

  within '.answers' do
    expect(page).to have_link 'Edit'
    fill_in 'Body', with: 'other answer'
    click_on 'Save'
    expect(current_path).to eq question_path(answer.question)
    expect(page).to have_content 'other answer'
  end

  # expect(current_path).to eq question_path(question)
  # expect(page).to have_content 'other answer' 
end

end 