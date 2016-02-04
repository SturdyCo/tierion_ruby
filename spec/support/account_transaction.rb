class AccountTransaction
  attr_reader :tierion_record_id

  def initialize(tierion_record_id: nil)
    @tierion_record_id = tierion_record_id
  end

  def id
    1
  end

  def amount
    100
  end

  def update(_)
    true
  end

  def self.find_by(_)
    new
  end
end
