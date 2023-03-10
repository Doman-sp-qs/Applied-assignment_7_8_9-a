class Book < ApplicationRecord
  
  belongs_to :user
  
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  
  has_many :favorited_users, through: :favorites, source: :user
  
  validates :title, presence: true
  validates :body, presence: true, length:{maximum: 200}
  
  
  scope :created_this_week, -> {where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day)}
  
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
  
end
