class AbilityDecorator
  include CanCan::Ability
  def initialize(user)
    if user.respond_to?(:has_spree_role?) && user.has_spree_role?('vendedor')
      can [:admin, :index,:edit, :update], Spree::Order
      can [:admin, :update], Spree::LineItem
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)