require File.dirname(__FILE__) + '/../spec_helper'
describe Topic, "in general" do
  fixtures :topics, :forums
  before do
    @topic = mock("topic")
    @forum = mock("forum")
    @invalid_topic = topics(:invalid)
    @valid_topic = topics(:user_3)
    @another_valid_topic = topics(:user_2)
    @everybody = forums(:everybody)
    @sub_of_everybody = forums(:sub_of_everybody)
    @admins_only = forums(:admins_only)
    # Remove the call to reverse for an interesting failing test
    @posts = @valid_topic.posts.reverse
  end
  
  it "should validate everything" do
    #length of subject
    @invalid_topic.subject = "Srt"
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:subject).should_not be_empty
    
    #presence of subject
    @invalid_topic.subject = nil
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:subject).should_not be_empty
    
    #presence of forum_id
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:forum_id).should_not be_empty
    
    #presence of user_id
    
    @invalid_topic.save.should be_false
    @invalid_topic.errors_on(:user_id).should_not be_empty
    
    # And now... for the obvious:
    
    @valid_topic.should be_valid
    
  end
  
  it "should be able to find the last 10 posts" do
    @valid_topic.last_10_posts.should eql(@posts)
  end
  
  it "should be able to show the string version" do
    @valid_topic.to_s.should eql("Fifth topic!")
  end
  
  it "should be able to lock a topic" do
    @valid_topic.should_not be_locked
    @valid_topic.lock!
    @valid_topic.should be_locked
  end
  
  it "should be able to unlock a topic" do
    @valid_topic.lock!
    @valid_topic.should be_locked
    @valid_topic.unlock!
    @valid_topic.should_not be_locked
  end
  
  it "should be able to sticky a topic" do
    @valid_topic.should_not be_sticky
    @valid_topic.sticky!
    @valid_topic.should be_sticky
  end
  
  it "should be able to unsticky a topic" do
    @valid_topic.sticky!
    @valid_topic.should be_sticky
    @valid_topic.unsticky!
    @valid_topic.should_not be_sticky
  end
  
  it "should be able to move a topic" do
    @valid_topic.move!(@sub_of_everybody.id)
    @valid_topic.forum_id.should eql(@sub_of_everybody.id)
  end
  
  it "should be able to move a topic that was the last posted to topic" do
    @another_valid_topic.move!(@sub_of_everybody.id)
    @another_valid_topic.forum_id.should eql(@sub_of_everybody.id)
    @everybody.last_post.should_not eql(@another_valid_topic.posts.last)
  end
  
end
