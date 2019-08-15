# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Projects', type: :feature do
  scenario 'user create a new project' do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    expect do
      click_link 'New Project'
      fill_in 'Name', with: 'Test Project'
      fill_in 'Description', with: 'Trying out Capybara'
      click_button 'Create Project'

      expect(page).to have_content 'Project was successfully created'
      expect(page).to have_content 'Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end.to change(user.projects, :count).by(1)
  end
end
