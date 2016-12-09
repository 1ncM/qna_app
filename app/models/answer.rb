class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, :question_id, :user_id, presence: true

  default_scope { order(accepted: :desc) }
end
