# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Projects', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user, name: 'Old Project') }
  it 'user creates a new project' do
    sign_in user
    visit root_path

    expect do
      visit_build_page 'New Project'
      fill_in_name_and_description
      determine_project 'Create Project'
      expect_build_done 'Project was successfully created.'
    end.to change(user.projects, :count).by(1)
  end

  it 'user update a project' do
    sign_in user
    visit project_path(project)

    expect do
      visit_build_page 'Edit'
      fill_in_name_and_description
      determine_project 'Update Project'
      expect_build_done 'Project was successfully updated.'
    end.to_not change(user.projects, :count)
  end

  it 'user completes a project' do
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    login_as user, scope: :user

    visit project_path(project)

    expect(page).to_not have_content 'Completed'

    click_button 'Complete'

    expect(project.reload.completed?).to be true
    expect(page).to have_content 'Congratulations, this project is complete!'
    expect(page).to have_content 'Completed'
    expect(page).to_not have_button 'Complete'
  end

  it 'toggle project status on the dashboard', :focus do
    # ユーザーを準備する
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: 'This is a Completed project.', completed: true, owner: user)
    FactoryBot.create(:project, name: 'This is a Incompleted project.', completed: nil, owner: user)
    # ユーザーはログインしている
    login_as user
    # ダッシュボードに完了済みのプロジェクトは表示されていない
    visit root_path
    aggregate_failures do
      expect(page).to_not have_content 'This is a Completed project.'
      # ダッシュボードに未完了のプロジェクトは表示されている
      expect(page).to have_content 'This is a Incompleted project.'
    end
  end

  def visit_build_page(name)
    click_link name
  end

  def fill_in_name_and_description
    fill_in 'Name', with: 'Feature Test Project'
    fill_in 'Description', with: 'Feature Test Project Description'
  end

  def determine_project(name)
    click_button name
  end

  def expect_build_done(name)
    aggregate_failures do
      expect(page).to have_content name
      expect(page).to have_content 'Feature Test Project'
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
end
