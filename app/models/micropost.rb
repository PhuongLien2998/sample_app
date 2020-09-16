class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze

  belongs_to :user
  has_one_attached :image

  delegate :name, to: :user, prefix: true

  validates :user_id, presence: true
  validates :content, presence: true,
                      length: {maximum: Settings.micropost.content.length}
  validates :image, content_type: {in: Settings.image.types,
                                   message: I18n.t("models.micropost.mustva")},
                    size: {less_than: Settings.image.size.megabytes,
                           message: I18n.t("models.micropost.suggest_size")}

  scope :order_desc, ->{order created_at: :desc}

  def display_image
    image.variant resize_to_limit: [Settings.image.width, Settings.image.height]
  end
end
