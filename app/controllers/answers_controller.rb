class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy 
      redirect_to @answer.question
    else
      redirect_to @answer.question, error: 'You can delete only your answer'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])    
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
