class ListPolicy < ApplicationPolicy
  class Scope < Scope
    def user_scope
      @scope.where({ lists: { user_id: @user.id }}).order(position: :asc)
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
