require File.dirname(__FILE__) + '/../spec_helper'

describe Moderator::TopicsController do
  
  fixtures :topics, :users, :forums, :moderations
  before do
    login_as(:moderator)
    @admin_topic = topics(:admin)
    @moderator_topic = topics(:moderator)
    @topic = mock(:topic)
    @forum = mock(:forum)
    @moderation = mock(:moderation)
    @moderations = [@moderation]
  end
  
  
  describe Moderator::TopicsController, "as moderator" do
    
    def find_topic_mock
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(false)
      @topic.should_receive(:moderations).and_return(@moderations)
      @moderations.should_receive(:for_user).and_return(@moderations)
      @moderation.should_receive(:destroy).and_return(@moderation)
    end
    
    def not_allowed
      flash[:notice].should eql("You are not allowed to access that topic.")
      response.should redirect_to(moderator_moderations_path)
    end
    
  
    it "should not be able to toggle the locked status any topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:toggle!)
      put 'toggle_lock', { :id => @admin_topic.id }
      not_allowed
    end
  
    it "should not be able to toggle the stickied status any topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:toggle!)
      put 'toggle_sticky', { :id => @admin_topic.id }
      not_allowed
    end
    
    it "should not be able to delete a topic in the admin forum" do
      find_topic_mock
      @topic.should_not_receive(:destroy)
      delete 'destroy', { :id => @admin_topic.id }
      not_allowed
    end
    
    it "should be allowed to delete a topic in the moderator forum" do
      Topic.should_receive(:find).and_return(@topic)
      @topic.should_receive(:forum).and_return(@forum)
      @forum.should_receive(:viewable?).and_return(true)
      @topic.should_receive(:destroy).and_return(@topic)
      delete 'destroy', { :id => @moderator_topic.id }
      flash[:notice].should_not be_nil
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to lock topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:lock!).and_return(@moderation)
      put 'moderate', { :commit => "Lock", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been locked.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to unlock topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:unlock!).and_return(@moderation)
      put 'moderate', { :commit => "Unlock", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been unlocked.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to delete topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:destroy!).and_return(@moderation)
      put 'moderate', { :commit => "Delete", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been deleted.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to sticky topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:sticky!).and_return(@moderation)
      put 'moderate', { :commit => "Sticky", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been stickied.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    it "should be able to unsticky topics for moderations selected on the moderations page" do
      Moderation.should_receive(:for_user).and_return(@moderations)
      @moderations.should_receive(:topics).and_return(@moderations)
      @moderations.should_receive(:find).and_return(@moderations)
      @moderation.should_receive(:unsticky!).and_return(@moderation)
      put 'moderate', { :commit => "Unsticky", :moderation_ids => [1,2,3] }
      flash[:notice].should eql("All selected topics have been unstickied.")
      response.should redirect_to(moderator_moderations_path)
    end
    
    
    
    
  end
end