require 'httparty'

class Tierion
  include HTTParty
  base_uri 'https://api.tierion.com/v1'

  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :username
    attr_accessor :api_key
  end

  def self.configure
    self.configuration = @configuration || Configuration.new
    yield(configuration)
  end

  def initialize(model:)
    @model = model
    @headers = {
      'X-Username' => self.class.configuration.username,
      'X-Api-Key' => self.class.configuration.api_key,
      'Content-Type' => 'application/json'
    }
  end


  def get_datastore(name: nil)
    response = self.class.get('/datastores', headers: @headers)

    unless name.nil?
      datastore = response.find { |datastore| datastore['name'] == name }

      if datastore.nil?
        raise ArgumentError, 'No datastore by that name. Check your spelling.'
      end

      datastore
    else
      response
    end
  end

  def create_datastore(params:)
    body = params.to_json

    response = self.class.post('/datastores',
                               body: body,
                               headers: @headers)
    if response.code == 201
      true
    else
      false
    end
  end

  def update_datastore(id:, params:)
    body = params.to_json

    response = self.class.put("/datastores/#{id}",
                              body: body,
                                headers: @headers)

    if response.code == 200
      true
    else
      false
    end
  end

  def delete_datastore(id:)
    response = self.class.delete("/datastores/#{id}", headers: @headers)

    if response.code == 200
      true
    else
      false
    end
  end

  def create_record(model:, datastore:, params:)
    datastore_id = get_datastore(name: datastore)['id']

    body = {
      datastoreId: datastore_id
    }.merge(params).to_json

    response = self.class.post('/records', body: body, headers: @headers)

    if response.code == 200
      model.update(tierion_record_id: response['id'])
      true
    else
      false
    end
  end

  def get_records(datastore_id:)
    query = { datastoreId: datastore_id }

    response = self.class.get('/records', query: query, headers: @headers)

    response
  end

  def update_blockchain_receipt(params)
    model_instance = @model.find_by(tierion_record_id: params[:tierion_record_id])

    return unless model_instance

    model_instance.update(blockchain_receipt: params[:blockchain_receipt])
  end
end
