# frozen_string_literal: true

class UsersController < AuthorizationController


  def show
    if current_user
      render 'users/show'
    else
      render :not_found, status: :not_found
    end
  end

  def edit; end

  def update
    if params[:avatar].present?
      current_user.avatar.attach(params[:avatar])
      current_user.avatar_url = rails_blob_path(current_user.avatar)
      current_user.save!
    end
    if current_user.update(user_params)
      render 'users/show'
    else
      render :error, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :description, :avatar, :avatar_url, :gender, :birthday)
  end
end
