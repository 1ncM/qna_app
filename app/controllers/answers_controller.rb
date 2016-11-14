class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question
    else
      flash[:notice] = "Field 'Body' must not be empty"
      redirect_to question_path(@answer.question)
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
    if current_user.author_of?(@answer)
      @answer.destroy 
      redirect_to question_path(@answer.question)
    else
      redirect_to question_path(@answer.question), error: 'You can delete only your answer'
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
