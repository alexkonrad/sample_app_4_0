require 'spec_helper'

describe "Static pages:" do
	subject { page }
	let(:base_title) { "Ruby on Rails Tutorial Sample App" }
	describe "The Home page" do
		before { visit root_path }
		it { should have_content('Sample App') }
		it { should have_title(full_title('')) }
		it { should_not have_title('| Home') }
	end
	describe "The Help page" do
		before { visit help_path }
		it { should have_content('Help') }
		it { should have_title('Help') }
	end
	describe "The About page" do
		before { visit about_path }
		it { should have_content('About') }
		it { should have_title('About') }
	end
	describe "The Contact page" do
		before { visit contact_path }
		it { should have_content('Contact') }
		it { should have_title('Contact') }
	end
end