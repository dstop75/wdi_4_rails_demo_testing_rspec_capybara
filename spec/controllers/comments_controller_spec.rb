require 'rails_helper'

RSpec.describe CommentsController do
  let(:article) { Article.create(title: "title", body: "body") }
  let(:valid_attributes) {
    { body: "Here's a comment body", article_id: article.id }
  }

  let(:invalid_attributes) {
    { body: nil }
  }

  describe 'GET index' do

    it 'has a 200 status code' do
      get :index, article_id: article.id
      expect(response.status).to eq 200
    end

    it 'renders the index template' do
      get :index, article_id: article.id
      expect(response).to render_template('index')
    end

    it 'assigns @comments' do
      comments = article.comments

      get :index, article_id: article.id
      expect(assigns(:comments)).to eq comments
    end
  end

  describe 'GET new' do

    it 'has a 200 status code' do
      get :new, article_id: article.id
      expect(response.status).to eq 200
    end

    it 'renders the new template' do
      get :new, article_id: article.id
      expect(response).to render_template('new')
    end

    it 'assigns @comment' do
      get :new, article_id: article.id
      expect(assigns(:comment)).to be_a_new Comment
    end
  end

  describe 'GET show' do
    it 'has a 200 status code' do
      comment = Comment.create!(valid_attributes)
      get :show, id: comment
      expect(response.status).to eq 200
    end

    it 'renders the show template' do
      comment = Comment.create!(valid_attributes)
      get :show, id: comment
      expect(response).to render_template('show')
    end

    it 'assigns @comment' do
      comment = Comment.create!(valid_attributes)
      get :show, id: comment
      expect(assigns(:comment)).to eq comment
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'saves a new comment' do
        expect {
          post :create, article_id: article.id, comment: valid_attributes
        }.to change(Comment, :count).by 1
      end

      it 'assigns @comment' do
        post :create, article_id: article.id, comment: valid_attributes
        expect(assigns(:comment)).to be_a Comment
        expect(assigns(:comment)).to be_persisted
      end

      it 'redirects to the created article' do
        post :create, article_id: article.id, comment: valid_attributes
        expect(response).to redirect_to(Comment.last)
      end
    end

    context 'with invalid attributes' do
      it 'assigns @comment, but does not save a new comment' do
        post :create, article_id: article.id, comment: invalid_attributes
        expect(assigns(:comment)).to be_a_new Comment
      end

      it 're-renders the new template' do
        post :create, article_id: article.id, comment: invalid_attributes
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'GET edit' do
    it 'has a 200 status code' do
      comment = Comment.create!(valid_attributes)
      get :edit, id: comment
      expect(response.status).to eq 200
    end

    it 'renders the edit template' do
      comment = Comment.create!(valid_attributes)
      get :edit, id: comment
      expect(response).to render_template('edit')
    end

    it 'assigns @comment' do
      comment = Comment.create!(valid_attributes)
      get :edit, id: comment
      expect(assigns(:comment)).to eq comment
    end
  end

  describe 'PATCH update' do
    context 'with valid attributes' do
      let(:new_attributes) { { body: 'a new body!' } }

      it 'updates the requested comment' do
        comment = Comment.create!(valid_attributes)
        patch :update, id: comment, comment: new_attributes
        comment.reload
        expect(comment.body).to eq new_attributes[:body]
      end

      it 'assigns @comment' do
        comment = Comment.create!(valid_attributes)
        patch :update, id: comment, comment: new_attributes
        expect(assigns(:comment)).to eq comment
      end

      it 'redirects to the comment' do
        comment = Comment.create!(valid_attributes)
        patch :update, id: comment, comment: new_attributes
        expect(response).to redirect_to comment
      end
    end

    context 'with invalid_attributes' do
      it 'assigns @comment' do
        comment = Comment.create!(valid_attributes)
        patch :update, id: comment, comment: invalid_attributes
        expect(assigns(:comment)).to eq comment
      end

      it 're-renders the edit template' do
        comment = Comment.create!(valid_attributes)
        patch :update, id: comment, comment: invalid_attributes
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'DELETE destroy' do
    it 'destroys the requested comment' do
      comment = Comment.create!(valid_attributes)
      expect {
        delete :destroy, id: comment
      }. to change(Comment, :count).by(-1)
    end

    it 'redirects to the comments list' do
      comment = Comment.create!(valid_attributes)
      article_id = comment.article_id
      delete :destroy, id: comment
      expect(response).to redirect_to article_comments_url(article_id)
    end
  end
end
