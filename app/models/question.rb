class Question < ApplicationRecord
  # Model Validation
  validates :name, :challenge_id, presence: true
  validates :name, uniqueness: { scope: [:challenge_id, :deleted], case_sensitive: false }

  # Model Relationships
  belongs_to :challenge
  has_many :answers
end
