module MakeFlaggable
  module Flaggable
    extend ActiveSupport::Concern
    
    attr_accessor :unflag
    
    included do
      has_many :flaggings, :class_name => "MakeFlaggable::Flagging", :as => :flaggable, :dependent => :destroy
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

    def remove_flags?
      flaggings.destroy_all if unflag == '1'
    end

  end
end
