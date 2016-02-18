class User < ActiveRecord::Base
  validates :name, :presence => true, :length => {:minimum => 5}
  validates :password, :presence => true, :length => {:minimum => 6} #, :format => //
  validates :email, :presence => true, :uniqueness => true
  has_one :api_key
  has_many :contacts
  def self.genereate_token(e)
      Digest::MD5.hexdigest(e)
  end
  def self.authenticate(user)
    @user = User.where(user).last
    if @user && @user.email_varify
      @user
    else
      nil
    end
 end
end

