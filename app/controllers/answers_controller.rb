class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy if current_user.author_of?(@answer)
  end

  private

  def set_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
