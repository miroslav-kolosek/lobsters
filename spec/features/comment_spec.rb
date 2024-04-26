# typed: false

require "rails_helper"

# uses page.driver.post because we're not running a full js engine,
# so the call can't just be click_on('delete'), etc.

RSpec.feature "Commenting" do
  let(:user) { create(:user) }
  let(:story) { create(:story, user: user) }

  before(:each) { stub_login_as user }

  scenario "posting a comment" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments" do
    scenario "deleting a comment" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments" do
    scenario "disowning a comment" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments" do
    scenario "upvote merged story comments" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list" do
    scenario "viewing user's threads" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  scenario "posting a comment 2" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 2" do
    scenario "deleting a comment 2" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 2" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 2" do
    scenario "disowning a comment 2" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 2" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments2 " do
    scenario "upvote merged story comments 2" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 2" do
    scenario "viewing user's threads2 " do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 3
  scenario "posting a comment 3" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 3" do
    scenario "deleting a comment 3" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 3" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 3" do
    scenario "disowning a comment 3" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 3" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 3" do
    scenario "upvote merged story comments 3" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 3" do
    scenario "viewing user's threads 3" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 4
  scenario "posting a comment 4" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 4" do
    scenario "deleting a comment 4" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 4" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 4" do
    scenario "disowning a comment 4" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 4" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 4" do
    scenario "upvote merged story comments 4" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 4" do
    scenario "viewing user's threads 4" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 5
  scenario "posting a comment 5" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 5" do
    scenario "deleting a comment 5" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 5" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 5" do
    scenario "disowning a comment 5" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 5" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 5" do
    scenario "upvote merged story comments 5" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 5" do
    scenario "viewing user's threads 5" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 6
  scenario "posting a comment 6" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 6" do
    scenario "deleting a comment 6" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 6" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 6" do
    scenario "disowning a comment 6" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 6" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 6" do
    scenario "upvote merged story comments 6" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 6" do
    scenario "viewing user's threads 6" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 7
  scenario "posting a comment 7" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 7" do
    scenario "deleting a comment 7" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 7" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 7" do
    scenario "disowning a comment 7" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 7" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 7" do
    scenario "upvote merged story comments 7" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 7" do
    scenario "viewing user's threads 7" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 8
  scenario "posting a comment 8" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 8" do
    scenario "deleting a comment 8" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 8" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 8" do
    scenario "disowning a comment 8" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 8" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 8" do
    scenario "upvote merged story comments 8" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 8" do
    scenario "viewing user's threads 8" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 9
  scenario "posting a comment 9" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 9" do
    scenario "deleting a comment 9" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 9" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 9" do
    scenario "disowning a comment 9" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 9" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 9" do
    scenario "upvote merged story comments 9" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 9" do
    scenario "viewing user's threads 9" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end

  # 10
  scenario "posting a comment 10" do
    visit "/s/#{story.short_id}"
    expect(page).to have_button("Post")
    fill_in "comment", with: "An example comment"
    click_on "Post"
    visit "/s/#{story.short_id}"
    expect(page).to have_content("example comment")
  end

  feature "deleting comments 10" do
    scenario "deleting a comment 10" do
      comment = create(:comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      visit "/s/#{story.short_id}"
      expect(page).to have_link("undelete")
      comment.reload
      expect(comment.is_deleted?).to be(true)
    end

    scenario "trying to delete old comments 10" do
      comment = create(:comment, user: user, story: story, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("delete")

      page.driver.post "/comments/#{comment.short_id}/delete"
      comment.reload
      expect(comment.is_deleted?).to be(false)
    end
  end

  feature "disowning comments 10" do
    scenario "disowning a comment 10" do
      # bypass validations to create inactive-user:
      create(:user, :inactive)

      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 90.days.ago)
      visit "/s/#{story.short_id}"
      expect(page).to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).not_to eq(user)
      visit "/s/#{story.short_id}"
      expect(page).to have_content("inactive-user")
    end

    scenario "trying to disown recent comments 10" do
      comment = create(:comment, user_id: user.id, story_id: story.id, created_at: 1.day.ago)
      visit "/s/#{story.short_id}"
      expect(page).not_to have_link("disown")

      page.driver.post "/comments/#{comment.short_id}/disown"
      comment.reload
      expect(comment.user).to eq(user)
    end
  end

  feature "Merging story comments 10" do
    scenario "upvote merged story comments 10" do
      reader = create(:user)
      hot_take = create(:story)

      comment = create(
        :comment,
        user_id: user.id,
        story_id: story.id,
        created_at: 90.days.ago,
        comment: "Cool story."
      )
      visit "/settings"
      click_on "Logout"

      stub_login_as reader
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment .comment_text")).to have_content("Cool story.")
      expect(comment.score).to eq(1)
      page.driver.post "/comments/#{comment.short_id}/upvote"
      comment.reload
      expect(comment.score).to eq(2)

      story.update(merged_stories: [hot_take])
      visit "/s/#{story.short_id}"
      expect(page.find(:css, ".comment.upvoted .score")).to have_content("2")
    end
  end

  feature "user threads list 10" do
    scenario "viewing user's threads 10" do
      poster = create(:user)
      parent = create(:comment, story: story, user: poster)
      reply = create(:comment, story: story, user: user, parent_comment: parent)

      visit "/threads/#{user.username}"
      expect(page).to have_content(parent.comment)
      expect(page).to have_content(reply.comment)
    end
  end
end
