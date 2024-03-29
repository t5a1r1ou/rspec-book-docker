# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notes', type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:project) do
    FactoryBot.create(:project,
                      name: 'RSpec tutorial',
                      owner: user)
  end

  it 'user uploads an attachment' do
    sign_in user
    visit project_path(project)
    click_link 'Add Note'
    fill_in 'Message', with: 'My Book Cover'
    attach_file 'Attachment', "#{Rails.root}/spec/files/attachment.jpg"
    click_button 'Create Note'
    expect(page).to have_content 'Note was successfully created'
    expect(page).to have_content 'My Book Cover'
    expect(page).to have_content 'attachment.jpg (image/jpeg'
  end
end
describe
