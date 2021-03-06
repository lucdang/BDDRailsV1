require "rails_helper"
RSpec.feature "Users can view tickets" do
  before do
    author = FactoryGirl.create(:user, :admin)
    sublime = FactoryGirl.create(:project, name: "Sublime Text 3")
    ie = FactoryGirl.create(:project, name: "Internet Explorer")

    FactoryGirl.create(:ticket, project: sublime, author: author, name: "Make it shiny!", description: "Gradients! Starbursts! Oh my!")
    FactoryGirl.create(:ticket, project: ie, author: author, name: "Standards compliance", description: "Isn't a joke.")

    assign_role! author, :viewer, sublime
    assign_role! author, :viewer, ie
    login_as author
    visit admin_projects_path
  end
  scenario "for a given project" do
    click_link "Sublime Text 3"
    expect(page).to have_content "Make it shiny!"
    expect(page).to_not have_content "Standards compliance"
    click_link "Make it shiny!"
    within("#ticket") do
      expect(page).to have_content "Make it shiny!"
    end
    expect(page).to have_content "Gradients! Starbursts! Oh my!"
  end
end
