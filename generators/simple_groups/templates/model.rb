class <%= class_name %> < ActiveRecord::Base
  has_many :memberships
  has_many :members, :through => :memberships, :source => :user, :conditions => 'accepted_at IS NOT NULL'
  has_many :pending_members, :through => :memberships, :source => :user, :conditions => 'accepted_at IS NULL'
  has_many :mods, :through => :memberships, :source => :user, :conditions => ['admin_role = ?', true]
  
  def membership(user)
    Membership.find(:first, :conditions => ['group_id = ? AND user_id = ?', self.id, user.id])
  end
  
  def accept_member(user)
    self.membership(user).update_attribute(:accepted_at, Time.now)
  end
  
  def pending_and_accepted_members
    self.pending_members + self.members
  end
  
  def kick(user)
    self.membership(user).destroy if user.is_member_of?(self)
  end
  
  def mods_online
    self.mods.find(:all, :conditions => ['users.updated_at > ?', 50.seconds.ago])
  end
  
  def members_online
    self.members.find(:all, :conditions => ['users.updated_at > ?', 70.seconds.ago])
  end
  
  def members_offline
    self.members - self.members_online
  end
  
  def has_member?(user)
    self.members.include?(user)
  end
end
