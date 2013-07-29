require 'spec_helper'

describe Micropost do

	let(:user) { FactoryGirl.create(:user) }
	before { @micropost = user.microposts.build(content: "Lorem ipsum") }

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should respond_to(:user) }
	it { should respond_to(:reply?) }
	its(:user) { should eq user }

	it { should be_valid }

	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end
	
	describe "when user_id is not present" do
		before { @micropost.user_id = nil }
		it { should_not be_valid }
	end

	describe "with blank content" do
		before { @micropost.content = " " }
		it { should_not be_valid }
	end

	describe "with content that is too long" do
		before { @micropost.content = "a" * 141 }
		it { should_not be_valid }
	end

	#describe "when a reply is present" do
	#	before do
	#		@user_in_reply = Users.create(name: "user_in_reply")
	#		@micropost.content = "@user_in_reply this is a reply"
	#	end
	#	
	#	describe "matching reply" do
	#		expect(@micropost.send(:reply?)).not_to be_empty
	#	end
	
	#	describe "identify recipients" do
	#		expect(@micropost.send(:people_replied)).to include(@user_in_reply)
	#	end
#
#		describe "saving replies" do
#			before { @micropost.send(:save_recipients) }
#			
#			describe "should create a Recipient object" do
#				its(:recipients) { should_not be_empty }
#			end
#
#			describe "should store recipient" do
#				its(:recipients) { should include(@user_in_reply) }
#			end
#		end
#	end
end
