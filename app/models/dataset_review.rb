# frozen_string_literal: true

# Allows users to rate and review a dataset.
class DatasetReview < ApplicationRecord
  # Validations
  validates :rating, presence: true
  validates :dataset_id, uniqueness: { scope: :user_id }
  validates :rating, inclusion: { in: 1..5, message: "must be between 1 and 5 stars" }

  # Relationships
  belongs_to :dataset, touch: true
  belongs_to :user
  has_many :notifications

  # Methods

  def create_notification!
    notification = dataset.user.notifications
                          .where(dataset_id: dataset_id, dataset_review_id: id)
                          .first_or_create
    notification.mark_as_unread!
  end

  def destroy
    notifications.destroy_all
    super
  end
end
