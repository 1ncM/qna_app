require_relative 'acceptance_helper'

feature 'Delete answer', %q{
  In order to don't be ashamed for your answer
  As as author of answer
  I want to be able to delete my answer
} do
  given!(:user) { create(:user) }

  before(:each) do
    sign_in(user)
    @question = create((:question), user: user)
    @answer = create(:answer, question: @question, user: user)
  end

  scenario 'Asker can delete your answer', js: true do
    visit question_path(@question)
    click_on "Delete answer"
    expect(current_path).to eq question_path(@question)
    expect(page).to_not have_content(@answer.body)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Authenticated user can not delete answer asked by other user', js: true do
    sign_out
    sign_in(create(:user))
    visit question_path(@question)
    expect(page).to have_content(@answer.body)
    expect(page).to_not have_link 'Delete answer'
  end

  scenario 'Non-authenticated user can not delete answer', js: true do
    sign_out
    visit question_path(@question)
    expect(page).to have_content(@answer.body)
    expect(page).to have_no_link("Delete answer", href: answer_path(@answer))
  end
end