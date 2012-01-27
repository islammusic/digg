class User < ActiveRecord::Base
  attr_accessor :password
  
  attr_accessible :name, :surname, :email, :password,
                  :password_confirmation
  
  has_many :posts
  
  validates :surname,   :presence => true,
                        :length => {  :maximum => 30}
  validates :email,     :presence => true,
                        :uniqueness => true
                        
  validates :password,  :presence => true,
                        :length => { :within => 6..40},
                        :confirmation => true
                        
  
  
  def self.authenticate(email, pass)
    user = find_by_email(email)
    if user.nil?
      nil
    else 
      if user.hash_password == encrypt(pass)
        user
      else 
        nil
      end
    end
  end
  
  before_save :convert_password  
  
  private
  def convert_password
    self.hash_password = encrypt(password)
  end
  
  def encrypt(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def self.encrypt(string)
    Digest::SHA2.hexdigest(string)
  end
  
end
