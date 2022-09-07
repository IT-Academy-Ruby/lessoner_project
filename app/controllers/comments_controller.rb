# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :lesson_find, only: %i[create edit update]

  def create
    @comment = current_user.comments.create(comment_params.merge(lesson: @lesson))
    flash[:success] = if @comment.save
                        'Comment successfully added'
                      else
                        'Comment not posted'
                      end
    redirect_to lesson_path(@lesson)
  end

  def edit; end

  def update
    if @comment.update(comment_params)
      redirect_to lesson_path(@lesson)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @lesson = Lesson.find(params[:lesson_id])
    @comment = @lesson.comment.find(params[:id])
    return render file: 'public/403.html', status: :unauthorized if @comment.user != current.user

    @comment.destroy
    redirect_to lesson_path(@lesson), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:commenter, :body)
  end

  def lesson_find
    @lesson = Lesson.find(params[:id])
  end
end
