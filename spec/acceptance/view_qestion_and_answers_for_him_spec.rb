require_relative 'acceptance_helper'

feature 'View question and answers', %q{
   In order to view the whole question and existing answers to it
  As any user
  I want to be able to see the question details view with answers
} do
  given(:question) { create(:question) }
  
  scenario 'Any user can view question and answers for him' do
    a1, a2 = create_list(:answer, 2, question: question)

    visit question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content a1.body
    expect(page).to have_content a2.body
  end
end