class ActiveAdmin::CardPolicy < ApplicationPolicy
  class Scope
    super
  end

  def show?
    user.has_role?(:admin)
  end
end
