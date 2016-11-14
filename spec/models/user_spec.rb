require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many :answers }
  it { should have_many :questions }

  let(:user){ create(:user) }
  let(:question) {create(:question, user: user) }
  
  context 'Validate authority of question' do
    it 'from user who created question (is author)' do
      expect(user).to be_author_of(question)
    end

    it 'from user who did not create question (is not author)' do
      not_author = create(:user)
      expect(not_author).to_not be_author_of(question)
    end
  end
end
