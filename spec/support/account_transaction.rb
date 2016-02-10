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

  def blockchain_receipt
    "{\r\n  \"header\": {\r\n    \"chainpoint_version\": \"1.0\",\r\n    \"hash_type\": \"SHA-256\",\r\n    \"merkle_root\": \"c143403d4edd465be50d417bb18231099bfce8c00833b9a2f14e30c63c81e451\",\r\n    \"tx_id\": \"d5d58781fb1ef5b41b9aa3859f3076db4ef239b02277091b31d3b4bb01001fc4\",\r\n    \"timestamp\": 1449089411\r\n  },\r\n  \"target\": {\r\n    \"target_hash\": \"c143403d4edd465be50d417bb18231099bfce8c00833b9a2f14e30c63c81e451\",\r\n    \"target_proof\": []\r\n  }\r\n}"
  end
end
