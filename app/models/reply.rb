class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :content, presence: true, allow_blank: false

  #scope
  default_scope ->{order('created_at desc')}

  def published_time
    self.created_at.strftime('%Y-%m-%d %H:%M')
  end

end