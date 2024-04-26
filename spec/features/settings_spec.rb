# typed: false

require "rails_helper"

RSpec.feature "Settings" do
  let!(:inactive_user) { create(:user, :inactive) }
  let(:user) { create(:user) }

  before(:each) { stub_login_as user }

  feature "deleting account" do
    scenario "and disowning" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 2
  feature "deleting account 2" do
    scenario "and disowning 2" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 2" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 2" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 3
  feature "deleting account 3" do
    scenario "and disowning 3" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 3" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 3" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 4
  feature "deleting account 4" do
    scenario "and disowning 4" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 4" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 4" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 5
  feature "deleting account 5" do
    scenario "and disowning 5" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 5" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 5" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 6
  feature "deleting account 6" do
    scenario "and disowning 6" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 6" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 6" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 7
  feature "deleting account 7" do
    scenario "and disowning 7" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 7" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 7" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 8
  feature "deleting account 8" do
    scenario "and disowning 8" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 8" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 8" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 9
  feature "deleting account 9" do
    scenario "and disowning 9" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 9" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 9" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end

  # 10
  feature "deleting account 10" do
    scenario "and disowning 10" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 1
      }

      expect(story.reload.user).to eq(inactive_user)
      expect(comment.reload.user).to eq(inactive_user)
      expect(user.stories_submitted_count).to eq(0)
      expect(user.comments_posted_count).to eq(0)
    end

    scenario "uncertain 10" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 0, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
    end

    scenario "certain without disown 10" do
      story = create :story, user: user
      comment = create :comment, user: user
      allow_any_instance_of(User).to receive(:authenticate).with("pass").and_return(true)

      page.driver.post "/settings/delete_account", user: {
        i_am_sure: 1, password: "pass", disown: 0
      }

      expect(user.reload.deleted_at).to_not be_nil
      expect(story.reload.user).to_not eq(inactive_user)
      expect(comment.reload.user).to_not eq(inactive_user)
      expect(user.stories_submitted_count).to_not eq(0)
      expect(user.comments_posted_count).to_not eq(0)
    end
  end
end
