class ListPolicy < ApplicationPolicy
  class Scope < Scope
    def user_scope
      @scope = List.left_outer_joins(shared_lists: :friendship).order("lists.position asc")
      @scope = @scope.where({lists: { user_id: @user.id } })
                     .or(@scope.where({ friendships: { inviter_id: @user.id } }))
                     .or(@scope.where({ friendships: { invited_id: @user.id } }))

      @scope

      # @scope.order("lists.position asc")
    end

    def visitor_scope # not logged in
      @scope.none
    end

    def resolve
      case @user
      when User
        user_scope
      else
        visitor_scope
      end
    end
  end
end
