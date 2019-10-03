class Batch
  include Mongoid::Document
  validates_uniqueness_of :name, scope: :start

  field :key,       type: String
  field :category,  type: String
  field :type,      type: String
  field :for,       type: String
  field :name,      type: String
  field :status,    type: String
  field :processed, type: Integer
  field :failed,    type: Integer
  field :start,     type: DateTime
  field :end,       type: DateTime
end
