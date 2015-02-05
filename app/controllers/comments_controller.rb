class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @article = Article.find(params[:article_id])
    @comment = @article.comments.new
  end

  def edit
    @comment = Comment.find(params[:id])
  end

  def create
    article = Article.find(params[:article_id])
    @comment = article.comments.new(comment_params)

    if @comment.save
      flash[:success] = 'Comment successfully created.'
      redirect_to comment_url(@comment)
    else
      render :new
    end
  end

  def update
    @comment = Comment.find(params[:id])

    if @comment.update(comment_params)
      flash[:success] = 'Comment successfully created.'
      redirect_to comment_url(@comment)
    else
      render :edit
    end
  end

  def destroy
    article_id = Comment.find(params[:id]).article_id
    Comment.find(params[:id]).destroy
    flash[:success] = 'Comment successfully deleted.'
    redirect_to article_comments_url(article_id)
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end
end
