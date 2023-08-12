class Comment < ApplicationRecord
  include Markdownable
  include MeiliSearch::Rails

  belongs_to :user
  belongs_to :post, touch: true
  has_many :comment_reactions, dependent: :destroy
  has_many_attached :images

  scope :latest, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }

  meilisearch do
    attribute :body

    attribute :user do
      user.name
    end

    attribute :username do
      user.username
    end
  end
end
