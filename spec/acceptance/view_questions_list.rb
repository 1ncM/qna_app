require 'rails_helper'

feature 'view questions list', %{
  In order to view the whole question and existing answers to it
  As any user
  I want to be able to see the question details view with answers
} do
  scenario 'Any user can view questions list' do
    q1, q2 = create_list(:question, 2)
    visit questions_path
    expect(page).to have_content q1.title
    expect(page).to have_content q2.title
  end
end