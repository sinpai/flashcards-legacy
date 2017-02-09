class ActiveAdmin::PagePolicy < ApplicationPolicy
  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  def show?
    case record.name
    when 'Dashboard'
      user.has_role?(:admin)
    else
      Pundit::NotAuthorizedError
    end
  end
end
