class FlaggableModel < ActiveRecord::Base
  make_flaggable
end

class FlaggerModel < ActiveRecord::Base
  make_flagger
end

class FlaggerOnceModel < ActiveRecord::Base
  make_flagger :flag_once => true
end

class InvalidFlaggableModel < ActiveRecord::Base
end

class AnotherFlaggableModel < ActiveRecord::Base
  make_flaggable
end

