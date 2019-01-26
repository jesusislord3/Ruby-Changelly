require "Changelly/version"
# require 'rpc4json'
# https://github.com/rest-client/rest-client
require 'openssl'
# http://ruby-doc.org/stdlib-2.6/libdoc/digest/rdoc/Digest/SHA2.html
require 'rest-client'
require 'json'


module Changelly
  #  method names copied from:
  # https://old.changelly.com/developers#getting-started
  # Your code goes here...
  class Changelly
    def initialize(api_key,api_secret,api_url='https://api.changelly.com')
      @api_key = api_key
      @api_secret = api_secret
      @api_url = api_url
    end
    def login
      raise "Not Implemented"
    end
    def logout
      raise "Not Implemented"
    end
    def encrypted_message(api_secret=@api_secret,message)
      # https://stackoverflow.com/questions/24401623/equivalent-hmac-sha-512-key
      # code is licenced! https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
      # https://legalict.com/2016/01/07/what-is-the-license-status-of-stackoverflow-code-snippets/
      # 2 programmers coming up with the same code argument applies here. facts are not covered by copyright.
      # @@encrypted = OpenSSL::Digest('sha512')

      # result was gained from here:
      # https://ruby-doc.org/stdlib-2.4.2/libdoc/openssl/rdoc/OpenSSL/HMAC.html
      @@hmac = OpenSSL::HMAC.digest("SHA512",api_secret,message.to_s)
      return String @@hmac
    end
    def send_message(message = {'jsonrpc' => '2.0','id' => 'responselabel','method' => 'getExchangeAmount','params' => [{'from'=>'eur','to' => 'btc' ,'amount'=> '3'}]},api_secret=@api_secret)
      # https://old.changelly.com/developers#protocol
      @@headers = {'api-key' => @api_key,'sign'=> encrypted_message(message)}
      # send the message
      @@tosend = @@headers.merge(message) # more ram rather than code golf but usable.
      # https://rubygems.org/gems/rpc4json
      # https://github.com/GRoguelon/JSONRPC/blob/master/lib/jsonrpc/client.rb
      # jsonrpc = JSONRPC::Client.new(@api_url)
      # jsonrpc.http_header_extra = @@headers
      return RestClient.get(@api_url,@@tosend) # @@headers.merge!(@@message) could have gone where to send is.
    end
    def getCurrenciesFull(id='ruby-changelly-getCurrenciesFull')
      # https://old.changelly.com/developers#currency-list
      @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getCurrenciesFull','params' => {}}
       results = send_message @@message
       parsed_results = JSON.parse(results)
       return Array parsed_results["result"]
    end
    def getCurrencies(id='ruby-changelly-getCurrencies')
        # https://old.changelly.com/developers#currency-list
       @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getCurrencies','params' => {}}
       results = send_message @@message
       parsed_results = JSON.parse(results)
       return Array parsed_results["result"]
    end
    def getMinAmount(from_currency,to_currency)
      # https://old.changelly.com/developers#currency-list
      @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getMinAmount','params' =>
          {'from' => from_currency,
           'to' => to_currency}
      }
      results = send_message @@message
      parsed_results = JSON.parse(results)
      return Hash parsed_results["result"]
    end
    def getExchangeAmount(currencies_hash_array)
      # gets the estimated amount of coins resulting from an exchange.
      #   the estimated result includes the partner fee as well as the exchange fee
      # https://old.changelly.com/developers#currency-list
      # currencies_hash_array example is [{from => 'eur','to' => 'btc','amount' => 2.33 },{from => 'btc','eth' => 'btc','amount' => 30.0 },...]
      @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getExchangeAmount','params' => currencies_hash_array}
      results = send_message @@message
      parsed_results = JSON.parse(results)
      return Hash parsed_results["result"]
    end
    def createTransaction(from_currency,to_currency,recipient_address,amount,extra_id="null",refund_address="null",refund_extra_id="null")
      # create a transaction to finalise by sending funds.
      @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'createTransaction','params' =>
          {'from'=>from_currency,
           'to_currency'=>to_currency,
           'address' => recipient_address,
           'extra_id' => extra_id ,
           'amount'=>amount,
           'refundAddress'=>refund_address,
           'refundExtraId' => refund_extra_id }
      }
      results = send_message @@message
      parsed_results = JSON.parse(results)
      return Hash parsed_results["result"]
    end
    def getStatus(transaction_id)
      @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getStatus','params' =>
          {'id' => transaction_id }
      }
      results = send_message @@message
      parsed_results = JSON.parse(results)
      return Hash parsed_results["result"]
    end
  end
end

