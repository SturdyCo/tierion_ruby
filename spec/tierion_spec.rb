require 'spec_helper'

describe Tierion do
  let(:tierion) { Tierion.new(model: AccountTransaction) }

  before do
    Tierion.configure do |config|
      config.username = 'garrettqmartin'
      config.api_key = 'ABC123'
    end
  end

  describe '.configure' do
    it 'should set the username and api_key' do
      expect(Tierion.configuration.username).to eq('garrettqmartin')
      expect(Tierion.configuration.api_key).to eq('ABC123')
    end
  end

  describe '#get_datastore' do
    context 'all' do
      it 'should return the datastore' do
        VCR.use_cassette('get_datastore_success', record: :new_episodes) do
          expect(tierion.get_datastore.first['id']).to eq(305)
        end
      end
    end

    context 'by name' do
      context 'success' do
        it 'should return the datastore' do
          VCR.use_cassette('get_datastore_success', record: :new_episodes) do
            expect(tierion.get_datastore(name: 'Transactions')['id']).to eq(305)
          end
        end
      end

      context 'failure' do
        it 'should return an error' do
          VCR.use_cassette('get_datastore_failure', record: :new_episodes) do
            expect(Proc.new {tierion.get_datastore(name: 'does not exist')}).to raise_error(ArgumentError)
          end
        end
      end
    end

    describe '#create_datastore' do
      context 'success' do
        it 'should return true' do
          params = {
            name: 'Transactions'
          }

          VCR.use_cassette('create_datastore_success', record: :new_episodes) do
            expect(tierion.create_datastore(params: params)).to eq(true)
          end
        end
      end

      context 'failure' do
        it 'should return false' do
          params = {}

          VCR.use_cassette('create_datastore_failure', record: :new_episodes) do
            expect(tierion.create_datastore(params: params)).to eq(false)
          end
        end
      end
    end
  end

  describe '#update_datastore' do
    context 'success' do
      it 'should return true' do
        params = {
          name: 'Transactions1'
        }

        VCR.use_cassette('update_datastore_success', record: :new_episodes) do
          tierion.create_datastore(params: {name: 'Transactions'})
          datastore = tierion.get_datastore(name: 'Transactions')

          expect(tierion.update_datastore(id: datastore['id'], params: params)).to eq(true)
        end
      end
    end
  end

  describe '#delete_datastore' do
    context 'success' do
      it 'should return true' do
        VCR.use_cassette('delete_datastore_success', record: :new_episodes) do
          tierion.create_datastore(params: {name: 'Transactions'})
          datastore = tierion.get_datastore(name: 'Transactions')

          expect(tierion.delete_datastore(id: datastore['id'])).to eq(true)
        end
      end
    end
  end

  describe '#create_record' do
    let(:account_transaction) { AccountTransaction.new(tierion_record_id: 'abc123') }

    context 'success' do
      it 'should return true' do
        params = {
          account_transaction_id: account_transaction.id,
          amount: account_transaction.amount
        }

        VCR.use_cassette('create_record_success', record: :new_episodes) do
          expect(tierion.create_record(model: account_transaction, datastore: 'Transactions', params: params)).to eq(true)
          expect(account_transaction.tierion_record_id).not_to eq(nil)
        end
      end
    end

    context 'failure' do
    end
  end

  describe '#get_records' do
    context 'success' do
      let(:account_transaction) { AccountTransaction.new(tierion_record_id: 'abc123') }

      it 'should return a collection of records' do
        params = {
          amount: 100,
          user_id: 123
        }

        VCR.use_cassette('get_records_success', record: :new_episodes) do
          tierion.create_datastore(params: {name: 'Transactions'})
          tierion.create_record(model: account_transaction, datastore: 'Transactions', params: params)
          datastore = tierion.get_datastore(name: 'Transactions')

          expect(tierion.get_records(datastore_id: datastore['id'])['records'].length > 0).to eq(true)
        end
      end
    end
  end

  describe '#update_blockchain_receipt' do
    let(:account_transaction) { AccountTransaction.new(tierion_record_id: 'abc123') }

    it 'should update the account transaction with the receipt' do
      webhook_params = {
        tierion_record_id: account_transaction.tierion_record_id,
        blockchain_receipt: "{\r\n  \"header\": {\r\n    \"chainpoint_version\": \"1.0\",\r\n    \"hash_type\": \"SHA-256\",\r\n    \"merkle_root\": \"c143403d4edd465be50d417bb18231099bfce8c00833b9a2f14e30c63c81e451\",\r\n    \"tx_id\": \"d5d58781fb1ef5b41b9aa3859f3076db4ef239b02277091b31d3b4bb01001fc4\",\r\n    \"timestamp\": 1449089411\r\n  },\r\n  \"target\": {\r\n    \"target_hash\": \"c143403d4edd465be50d417bb18231099bfce8c00833b9a2f14e30c63c81e451\",\r\n    \"target_proof\": []\r\n  }\r\n}"
      }

      tierion.update_blockchain_receipt(webhook_params)
      expect(account_transaction.blockchain_receipt).to eq(webhook_params[:blockchain_receipt])
    end
  end
end
