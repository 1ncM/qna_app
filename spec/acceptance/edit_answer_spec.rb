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
  expect(page).to have_link 'Edit'
  click_on 'Edit'
  within '.answers' do
    fill_in 'Answer', with: 'edited answer'
    click_on 'Save'
    expect(current_path).to eq question_path(answer.question)
    expect(page).to_not have_content answer.body
    expect(page).to have_content 'edited answer'
    expect(page).to_not have_selector 'textarea'
  end

end

scenario 'Authenticated user try edit other user answer', js: true do
  sign_in(create(:user))
  visit question_path(question)
  expect(page).to_not have_link 'Edit'
end

end 