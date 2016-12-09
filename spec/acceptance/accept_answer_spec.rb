require_relative 'acceptance_helper'

feature 'Select Best Answer', %q{
  In order to indicate best Answer
  As author of the question
  I want to be able to pick the best Answer
} do

  describe 'Author of the question' do

    before(:each) do
      author = create(:user)
      @question = create(:question, user: author)
      @answer = create_list(:answer, 3, question: @question, user: create(:user))
      sign_in(author)
    end

    scenario 'can see accept answer button for answer' do
      visit question_path(@question)
      expect(page).to have_css('.accept-link', count: 3)
    end

    scenario 'mark accepted answer', js: true do

    end

    scenario 'can unmark accepted answer', js: true do

    end

    scenario 'accepted answer displayd first', js: true do

    end
  end

  describe 'Non-autor of the question' do

  end 

end
