class ActiveAdmin::CommentPolicy < ApplicationPolicy
  class Scope
    super
  end

  def show?
    user.has_role?(:admin)
  end
end
