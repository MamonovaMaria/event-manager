class Room < ApplicationRecord
  include DateValidators
  include ActiveModel::Validations

  has_many :orders, dependent: :destroy
  has_and_belongs_to_many :events

  # проверка на присутствие
  validates :title, :begin_work_time, :end_work_time, presence: true

  validates_with RoomValidator
end
