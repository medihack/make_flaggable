module MakeFlaggable
  module Flagger
    extend ActiveSupport::Concern

    included do
      has_many :flaggings, :class_name => "MakeFlaggable::Flagging", :as => :flagger
    end

    module ClassMethods
      def flagger?
        true
      end

      # Returns flaggers who have flagged any resource
      # If +flag_type+ is not set, returns flaggers of all resources
      # takes flaggable_klass as an argument
      def flaggers(flag_type = nil)
        res = select("#{self.table_name}.*").joins(:flaggings).group("#{self.table_name}.id")

        flag_type ? res.where('flaggings.flaggable_type LIKE ?', flag_type.to_s) : res
      end
    end

    # Flag a +flaggable+ using the provided +reason+.
    # Raises an +AlreadyFlaggedError+ if the flagger already flagged the flaggable and +:flag_once+ option is set.
    # Raises an +InvalidFlaggableError+ if the flaggable is not a valid flaggable.
    def flag!(flaggable, reason = nil)
      check_flaggable(flaggable)

      if (flaggable_options[:flag_once] && fetch_flaggings(flaggable).try(:first))
        raise MakeFlaggable::Exceptions::AlreadyFlaggedError.new
      end

      Flagging.create(:flaggable => flaggable, :flagger => self, :reason => reason)
    end

    # Flag the +flaggable+, but don't raise an error if the flaggable was already flagged and +:flag_once+ was set.
    # If +:flag_once+ was not set then this method behaves like +flag!+.
    # The flagging is simply ignored then.
    def flag(flaggable, reason = nil)
      begin
        flag!(flaggable, reason)
      rescue Exceptions::AlreadyFlaggedError
      end
    end

    def unflag!(flaggable)
      check_flaggable(flaggable)

      flaggings = fetch_flaggings(flaggable)

      raise Exceptions::NotFlaggedError if flaggings.empty?

      flaggings.destroy_all

      true
    end

    def unflag(flaggable)
      begin
        unflag!(flaggable)
        success = true
      rescue Exceptions::NotFlaggedError
        success = false
      end
      success
    end

    def flagged?(flaggable)
      check_flaggable(flaggable)

      fetch_flaggings(flaggable).try(:first) ? true : false
    end

    private

    def fetch_flaggings(flaggable)
      flaggings.where({
        :flaggable => flaggable
      })
    end

    def check_flaggable(flaggable)
      raise Exceptions::InvalidFlaggableError unless flaggable.class.flaggable?
    end
  end
end
