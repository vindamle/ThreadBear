# A validation that can be performed to adjudicate server compliance with a given requirement
class Validation
  include Mongoid::Document

  field :id,                    type: String
  field :tags,                  type: Array
  field :name,                  type: String
  field :description,           type: String
  field :expected_result,       type: String
  field :alternative_evidence,  type: String

  has_and_belongs_to_many :requirements
  has_many :validation_instances
end
