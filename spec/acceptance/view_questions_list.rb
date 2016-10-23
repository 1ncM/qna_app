require 'rails_helper'

feature 'view questions list', %{
  In order to view the whole question and existing answers to it
  As any user
  I want to be able to see the question details view with answers
} do
  given(:question) {create(:question)}
  scenario 'Any user can view questions list' do
    a1, a2 = create_list(:answer, 2, question: question)
    visit questions_path
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content a1.body
    expect(page).to have_content a2.body
  end
end