class Moderation < ActiveRecord::Base
  belongs_to :moderated_object, :polymorphic => true
  belongs_to :user
  belongs_to :forum
  named_scope :for_user, lambda { |user_id| { :conditions => ["user_id = ?", user_id] } }
  named_scope :topics, :conditions => "moderated_object_type = 'Topic'"
  named_scope :posts, :conditions => "moderated_object_type = 'Post'"
  
  alias_method :topic, :moderated_object
  alias_method :post, :moderated_object
  
  def lock!
    moderated_object.lock!
    destroy
  end
  
  def unlock!
    moderated_object.unlock!
    destroy
  end
  
  def sticky!
    moderated_object.sticky!
    destroy
  end
  
  def unsticky!
    moderated_object.unsticky!
    destroy
  end
  
  def destroy!
    moderated_object.destroy
    destroy
  end
  
  def move!(new_forum_id)
    moderated_object.move!(new_forum_id)
    destroy
  end
end
