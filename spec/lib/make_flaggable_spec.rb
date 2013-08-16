require File.expand_path('../../spec_helper', __FILE__)

describe "Make Flaggable" do
  before(:each) do
    @flaggable = FlaggableModel.create(:name => "Flaggable 1")
    @flagger = FlaggerModel.create(:name => "Flagger 1")
    @flagger_once = FlaggerOnceModel.create(:name => "Flagger Once 1")
  end

  it "should create a flaggable instance" do
    @flaggable.class.should == FlaggableModel
    @flaggable.class.flaggable?.should == true
  end

  it "should create a flagger instance" do
    @flagger.class.should == FlaggerModel
    @flagger.class.flagger?.should == true

    @flagger_once.class.should == FlaggerOnceModel
    @flagger_once.class.flagger?.should == true
  end

  it "should have flaggings" do
    @flagger.flaggings.length.should == 0
    @flagger.flag!(@flaggable)
    @flagger.flaggings.reload.length.should == 1
  end

  describe "flagger" do
    describe "flag" do
      it "should create a flagging" do
        @flaggable.flaggings.length.should == 0
        @flagger.flag!(@flaggable)
        @flaggable.flaggings.reload.length.should == 1
      end

      it "should store the reason" do
        @flagger.flag!(@flaggable, "The reason.")
        reason = @flaggable.flaggings[0].reason
        reason.should == "The reason."
      end

      it "should only allow to flag a flaggable per flagger once with rasing an error" do
        @flagger_once.flag!(@flaggable)
        lambda { @flagger_once.flag!(@flaggable) }.should raise_error(MakeFlaggable::Exceptions::AlreadyFlaggedError)
        MakeFlaggable::Flagging.count.should == 1
      end

      it "should only allow to flag a flaggable per flagger once without rasing an error" do
        @flagger_once.flag(@flaggable)
        lambda { @flagger_once.flag(@flaggable) }.should_not raise_error
        MakeFlaggable::Flagging.count.should == 1
      end
    end

    describe "unflag" do
      it "should unflag a flagging" do
        @flagger.flag!(@flaggable)
        @flagger.flaggings.length.should == 1
        @flagger.unflag!(@flaggable).should == true
        @flagger.flaggings.reload.length.should == 0
      end

      it "should unflag multiple flaggings" do
        @flagger.flag!(@flaggable)
        @flagger.flag!(@flaggable)
        @flagger.flaggings.length.should == 2
        @flagger.unflag!(@flaggable).should == true
        @flagger.flaggings.reload.length.should == 0
      end

      it "normal method should return true when successfully unflagged" do
        @flagger.flag(@flaggable)
        @flagger.unflag(@flaggable).should == true
      end

      it "should raise error if flagger not flagged the flaggable with bang method" do
        lambda { @flagger.unflag!(@flaggable) }.should raise_error(MakeFlaggable::Exceptions::NotFlaggedError)
      end

      it "should not raise error if flagger not flagged the flaggable with normal method" do
        lambda {
          @flagger.unflag(@flaggable).should == false
        }.should_not raise_error
      end
    end

    describe "flagged?" do
      it "should check if flagger is flagged the flaggable" do
        @flagger.flagged?(@flaggable).should == false
        @flagger.flag!(@flaggable)
        @flagger.flagged?(@flaggable).should == true
        @flagger.unflag!(@flaggable)
        @flagger.flagged?(@flaggable).should == false
      end
    end
  end

  describe "flaggable" do
    it "should have flaggings" do
      @flaggable.flaggings.length.should == 0
      @flagger.flag!(@flaggable)
      @flaggable.flaggings.reload.length.should == 1
    end

    it "should check if flaggable is flagged" do
      @flaggable.flagged?.should == false
      @flagger.flag!(@flaggable)
      @flaggable.flagged?.should == true
      @flagger.unflag!(@flaggable)
      @flaggable.flagged?.should == false
    end
  end
end
