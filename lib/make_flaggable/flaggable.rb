module MakeFlaggable
  module Flaggable
    extend ActiveSupport::Concern

    included do
      has_many :flaggings, :class_name => "MakeFlaggable::Flagging", :as => :flaggable
      attr_accesor :unflag
      before_save :remove_flags?
    end

    module ClassMethods
      def flaggable?
        true
      end
    end

    def flagged?
      flaggings.count > 0
    end

    def flagged_by?(flagger)
      flagger.flagged?(self)
    end

    def remove_flags?()
      flaggings.destory_all if unflag
    end

  end
end
