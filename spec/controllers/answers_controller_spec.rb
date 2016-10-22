require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question) }
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirect to view show' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question } }.to_not change(Answer, :count)
      end

      it 'render view new' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question }
        expect(response).to render_template :new
      end      
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author delete your answer' do
      it 'deletes the answer' do
        expect { delete :destroy, params: { id: @answer, question_id: @question }}.to change(Answer, :count).by(-1)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question }
        expect(response).to redirect_to @question
      end
    end

    context 'authenticated user can not delete answer other user' do
      before do
        sign_out(@user)
        sign_in create(:user)
      end

      it 'does not delete answer' do
        expect { delete :destroy, params: { id: @answer, question_id: @question }}.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question }
        expect(response).to redirect_to @question
      end
    end
  end
end
