require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should validate_presence_of(:body)}  
  it { should validate_presence_of(:question_id)}
  it { should validate_presence_of(:user_id)}


  describe "#mark_as_accepted" do

    let(:user){ create(:user) }
    let(:question) {create(:question, user: user)}
    let(:answer) {create(:answer, question: question, user: user)}

    it "answer mark as accepted" do
      answer.update(accepted:true)
      answer.save
      answer.reload
      expect(answer).to be_accepted
    end

    it "change accepted status from answer if other answer was accepted" do
      answer2 = create(:answer, question: question, user: user)
      
      answer.update(accepted: true)
      answer.save

      answer2.mark_as_accepted

      answer.reload
      answer2.reload

      expect(answer2).to be_accepted
      expect(answer).to_not be_accepted
    end
  end
end

