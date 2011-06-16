require 'make_flaggable/flagging'
require 'make_flaggable/flaggable'
require 'make_flaggable/flagger'
require 'make_flaggable/exceptions'

module MakeFlaggable
  def flaggable?
    false
  end

  def flagger?
    false
  end

  # Specify a model as flaggable.
  # Optional option :once_per_flagger when only on flag per flagger is allowed.
  #
  # Example:
  # class Article < ActiveRecord::Base
  #   make_flaggable :once_per_flagger => true
  # end
  def make_flaggable
    include Flaggable
  end

  # Specify a model as flagger.
  #
  # Example:
  # class User < ActiveRecord::Base
  #   make_flagger
  # end
  def make_flagger(options = {})
    define_method(:flaggable_options) { options }
    include Flagger
  end
end

ActiveRecord::Base.extend MakeFlaggable
