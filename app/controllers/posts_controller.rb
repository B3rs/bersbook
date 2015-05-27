class PostsController < ApplicationController

  before_action :get_post, only: [:update, :edit, :destroy]
  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        @post.create_activity key: 'post.created', owner: @post.user
        format.html { redirect_to :back, notice: "Post created" }
      else
        format.html { redirect_to :back, notice: "Something went wrong" }
      end
    end
  end

  def edit

  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to user_path(@post.user.username), notice: "Post updated" }
      else
        format.html { redirect_to user_path(@post.user.username), notice: "Something went wrong" }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to user_path(@post.user.username), notice: "Post removed" }
    end
  end

  private

  def get_post
    @post = current_user.posts.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content)
  end
end
