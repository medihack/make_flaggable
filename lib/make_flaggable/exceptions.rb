module MakeFlaggable
  module Exceptions
    class AlreadyFlaggedError < StandardError
      def initialize
        super "The flaggable was already flagged by this flagger."
      end
    end

    class NotFlaggedError < StandardError
      def initialize
        super "The flaggable was not flagged by the flagger."
      end
    end

    class InvalidFlaggableError < StandardError
      def initialize
        super "Invalid flaggable."
      end
    end
  end
end
