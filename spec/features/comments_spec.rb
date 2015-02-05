require 'rails_helper'

RSpec.feature 'Managing comments' do
  scenario 'List all comments' do
    article = Article.create!(title: 'One Stupid Trick', body: "You won't believe what they did next...")
    Comment.create!(body: 'some text', article: article)
    Comment.create!(body: 'some text', article: article)
    Comment.create!(body: 'some text', article: article)

    visit "/articles/#{article.id}/comments"

    expect(page).to have_content 'Comments'
    expect(page).to have_selector 'p', count: 3
  end

  scenario 'Create a comment' do
    article = Article.create!(title: 'One Stupid Trick', body: "You won't believe what they did next...")
    visit "/articles/#{article.id}/comments/new"

    fill_in 'Body', with: 'Comment Body'
    click_on 'Create Comment'

    expect(page).to have_content(/success/i)
  end

  scenario 'Read a comment' do
    article = Article.create!(title: 'One Stupid Trick', body: "You won't believe what they did next...")
    comment = article.comments.create!(body: 'this comment')

    visit "/comments/#{comment.id}"

    expect(page).to have_content 'this comment'
  end

  scenario 'Update a comment' do
    article = Article.create!(title: 'One Stupid Trick', body: "You won't believe what they did next...")
    comment = article.comments.create!(body: "I don't believe it")

    visit "/comments/#{comment.id}/edit"

    fill_in 'Body', with: 'Much disbelief. Wow.'
    click_on 'Update Comment'

    expect(page).to have_content(/success/i)
    expect(page).to have_content 'Much disbelief. Wow.'
  end

  scenario 'Delete a comment' do
    article = Article.create!(title: 'One Stupid Trick', body: "You won't believe what they did next...")
    comment = article.comments.create!(body: 'no comment...')

    visit "/comments/#{comment.id}/edit"

    click_on 'Delete Comment'

    expect(page).to have_content(/success/i)
  end
end
