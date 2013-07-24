class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:public_show]
  before_action :set_post, only: [:edit, :update, :destroy]
  layout "unauthenticated", only: [:public_show]

  def show
    @post = current_user.visible_posts.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
    @comment = @post.comments.build
  end

  def public_show
    @post = Post.find(params[:id])
    @comments = @post.comments.order(created_at: :desc)
  end

  def index
    @post = current_user.posts.build
    @posts = current_user.visible_posts
  end

  def edit
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to posts_path, notice: 'Post was successfully created.'
    else
      @posts = Post.all
      render action: 'index'
    end
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'Post was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_url
  end

  private

  def set_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :tag_list)
  end
end
