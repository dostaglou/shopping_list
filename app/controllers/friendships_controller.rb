class FriendshipsController < ApplicationController
  def index
<<<<<<< HEAD
    @friendships = Friendship.accepted.friendships_for(current_user.id)
=======
    @friendships = Friendship.friendships_for(current_user.id)
>>>>>>> friendships
  end

  def invitations
    user_ids = Friendship.pending.friendships_for(current_user.id).pluck(:inviter_id, :invited_id).flatten
    @friends = User.where(id: user_ids).where.not(id: current_user.id)
  end

  def show
  end

  def new
    @friendship = Friendship.new
    @shareable_lists = current_user.lists
  end

  def create
    email = friendship_params[:invited_email].strip
    invited_user = User.find_by_email(email)

    friendship = current_user.friendships.new(invited_email: email, invited_id: invited_user&.id, name: friendship_params[:name])
    list_ids = current_user.lists.where(id: params.dig(:shared_list, :list_id))

    list_ids.each { |list| friendship.shared_lists.new(list_id: list.id) }

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
<<<<<<< HEAD
    @friendship = Friendship.find(params[:id])
    puts "\n\n\nHERE\n\n\n"
=======
    @friendship = Friendship.includes(:shared_lists).find(params[:id])

    list_ids = current_user.list_ids + @friendship.shared_lists.pluck(:list_id)
    @shareable_lists = List.where(id: current_user.list_ids + @friendship.shared_lists.pluck(:list_id))
>>>>>>> friendships
  end

  def update
    @friendship = Friendship.includes(:shared_lists).find(params[:id])
    @friendship.accepted! if @friendship.pending? && @friendship.invited_id == current_user.id

    list_ids = (params.dig(:shared_list, :list_id) || []).map(&:to_i)
    user_lists = current_user.lists

    user_lists.each do |list|
      if list_ids.include?(list.id)
        @friendship.shared_lists.find_or_create_by(list_id: list.id)
      else
        sl = @friendship.shared_lists.find_by(list_id: list.id)
        sl.destroy if sl.present?
      end
    end
  end

  def destroy
    @friendship = Friendship.find(params[:id])
    @friendship.destroy!
    flash[:notice] = "Friendship has been destroyed"
    redirect_to friendships_path
  end

  private

    def friendship_params
      params.require(:friendship).permit(:name, :invited_email, shared_lists_attributes: {})
    end
end
