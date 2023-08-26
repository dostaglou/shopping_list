class FriendshipsController < ApplicationController

  def index
    user_ids = Friendship.accepted.friendships_for(current_user.id).pluck(:inviter_id, :invited_id).flatten
    @friends = User.where(id: user_ids).where.not(id: current_user.id)
  end

  def invitations
    user_ids = Friendship.accepted.friendships_for(current_user.id).pluck(:inviter_id, :invited_id).flatten
    @friends = User.where(id: user_ids).where.not(id: current_user.id)
  end

  def show
  end

  def new
    @friendship = Friendship.new
  end

  def create
    email = friendship_params[:invited_email].strip
    invited_user = User.find_by_email(email)

    friendship = current_user.friendships.new(invited_email: email, invited_id: invited_user&.id)
    list_ids = current_user.lists.where(id: friendship_params[:shared_lists_attributes].to_h.dig("0", "list_id")).pluck(:id)

    list_ids.each do |id|
      friendship.shared_lists.new(list_id: id)
    end

    friendship.name = friendship_params[:name]

    if friendship.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to friendships_path }
      end
    else
      redirect_to friendships_path
    end
  end

  def edit

  end

  def update
  end

  def destroy
  end

  private

    def friendship_params
      params.require(:friendship).permit(:name, :invited_email, shared_lists_attributes: {})
    end
end
