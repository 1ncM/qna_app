require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  describe 'POST #create' do
    sign_in_user
    let(:question) { create(:question) }
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js } }.to change(question.answers, :count).by(1)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js } }.to_not change(Answer, :count)
      end

      it 'render create template' do
        post :create, params: { answer: attributes_for(:invalid_answer), question_id: question, format: :js }
        expect(response).to render_template :create
      end      
    end
  end

  describe 'GET #accept' do
    sign_in_user

    before do
      @question = create(:question, user: @user)
      @answer = create(:answer, question: @question, user: @user)
    end

    context 'author of question' do

      before do
        @accepted = @answer.accepted
        get :accept, xhr: true, params: { id: @answer.id, question_id: @question.id, format: :js }
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq @answer
      end

      it 'change answer accepted status' do
        @answer.reload
        expect(@answer.accepted).to eq !@accepted
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new answer in the database' do
      end

      it 'render create template' do
      end      
    end
  end

  describe "PATCH #update" do

    describe 'author update your answer' do
      sign_in_user
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: @user)}

      context 'with valid attributes' do

        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, user_id: @user, format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          patch :update, params: { id: answer, answer: { body: "other answer" }, question_id: question, user_id: @user, format: :js }
          answer.reload
          expect(answer.body).to eq "other answer"
        end

        it 'render update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, user_id: @user, format: :js }
          expect(response).to render_template :update
        end

      end

      context 'with invalid attributes' do

        it 'assings the requested answer to @answer' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, user_id: @user, format: :js }
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          body = answer.body
          patch :update, params: { id: answer, answer: attributes_for(:invalid_answer), question_id: question, user_id: @user, format: :js }
          answer.reload
          expect(answer.body).to eq body
        end

        it 'render update template' do
          patch :update, params: { id: answer, answer: attributes_for(:answer), question_id: question, user_id: @user, format: :js }
          expect(response).to render_template :update
        end
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
        expect { delete :destroy, params: { id: @answer, question_id: @question, format: :js }}.to change(Answer, :count).by(-1)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'authenticated user can not delete answer other user' do
      before do
        sign_out(@user)
        sign_in create(:user)
      end
      
      it 'does not delete answer' do
        expect { delete :destroy, params: { id: @answer, question_id: @question, format: :js }}.to_not change(Answer, :count)
      end

      it 'redirect to question path' do
        delete :destroy, params: { id: @answer, question_id: @question, format: :js }
        expect(response).to render_template :destroy
      end
    end
  end
end
