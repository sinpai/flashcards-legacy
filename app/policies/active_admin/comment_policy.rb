class ActiveAdmin::CommentPolicy < ApplicationPolicy
  class Scope
    super
  end

  def show?
    Pundit::NotAuthorizedError unless user.has_role?(:admin)
  end
end
