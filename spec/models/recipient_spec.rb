require 'spec_helper'

describe Recipient do
	before do
		@replier = FactoryGirl.create(:user)
		@recipient = FactoryGirl.create(:user)
		@reply = FactoryGirl.create(:micropost, user_id: @replier.id,
																content: "@#{@recipient}")
	end

	subject { @reply }

	it { should respond_to(:user_id) }
	it { should respond_to(:content) }

end
