require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render view index' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render view show' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render view new' do
      expect(response).to render_template :new
    end
  end

  # describe 'GET #edit' do
  #   sign_in_user

  #   before { get :edit, params: { id: question } }

  #   it 'assigns the requested question to @question' do
  #     expect(assigns(:question)).to eq question
  #   end

  #   it 'render view edit' do
  #     expect(response).to render_template :edit
  #   end
  # end

  describe 'POST #create' do
    sign_in_user

    context 'with valid attributes' do
      it 'save the new question in the database' do
        expect { post :create, params: { question: attributes_for(:question) }}.to change(Question,:count).by(1)
      end

      it 'redirect_to view show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
       it 'does not save the new question in the database' do
        expect { post :create, params: { question: attributes_for(:invalid_question) }}.to_not change(Question,:count)
      end

      it 'render view new' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end 

  describe 'PATCH #update' do

    describe 'Author try update question' do
    
      sign_in_user
      let!(:question) { create(:question, user: @user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: "new title", body: "new body" }, format: :js }
          question.reload
          expect(question.title).to eq "new title"
          expect(question.body).to eq "new body"
        end

        it 'redirects to the updated question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do
          patch :update, params: { id: question, question: { title: "new title", body: nil }, format: :js }
          question.reload
          expect(question.title).to eq question.title
          expect(question.body).to eq "MyText"      
        end

        it 're-renders edit view' do
          patch :update, params: { id: question, question: { title: "new title", body: nil }, format: :js }
          expect(response).to render_template :update
        end
      end
    end

    describe 'Non-author try update question' do
      sign_in_user
      let!(:question) { create(:question, user: create(:user)) }

        it 'assings the requested answer to @answer' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(assigns(:question)).to eq question
        end

        it 'try changes answer attributes' do
          old_body = question.body
          old_title = question.title
          patch :update, params: { id: question, question: {title: 'other title', body: "other question"}, format: :js }
          question.reload
          expect(question.body).to eq old_body
          expect(question.title).to eq old_title
        end

        it 'render update template' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }
          expect(response).to render_template :update
        end
    end
  end

  describe 'DELETE #destroy' do
    context 'author of question' do
      sign_in_user
      before { @question = create(:question, user: @user) }

      it 'delete question' do
        expect { delete :destroy, params: { id: @question }}.to change(Question,:count).by(-1)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'not an author of the question tries delete question' do
      sign_in_user
      before do
        @question = create(:question, user: @user)
        sign_out @user
        sign_in(create(:user))
      end

      it 'does not delete question' do
        expect { delete :destroy, params: { id: @question }}.to_not change(Question,:count)
      end

      it 'redirect to index view' do
        delete :destroy, params: { id: @question }
        expect(response).to redirect_to questions_path
      end
    end
  end
end
