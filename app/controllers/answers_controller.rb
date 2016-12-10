class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_answer, only: [:update, :destroy, :accept]

  def create
    @question = Question.find(params[:question_id])    
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def accept
    if current_user.author_of?(@answer)
      @question = @answer.question
      @answer.mark_as_accepted
    end
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
