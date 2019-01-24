require "Ruby/Changelly/version"
require 'rpc4json'
# https://github.com/rest-client/rest-client
require 'openssl'
# http://ruby-doc.org/stdlib-2.6/libdoc/digest/rdoc/Digest/SHA2.html
require 'rest-client'
require 'json'

module Ruby
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

      end
      def logout

      end
      def encrypted_message(api_secret=@api_secret,message)
        # https://stackoverflow.com/questions/24401623/equivalent-hmac-sha-512-key
        # code is licenced! https://meta.stackexchange.com/questions/271080/the-mit-license-clarity-on-using-code-on-stack-overflow-and-stack-exchange
        # https://legalict.com/2016/01/07/what-is-the-license-status-of-stackoverflow-code-snippets/
        # 2 programmers coming up with the same code argument applies here. facts are not covered by copyright.
        @@encrypted = OpenSSL::Digest('sha512')
        @@hmac = OpenSSL::HMAC.digest(@@encrypted,@api_secret,message)
        return @@hmac
      end
      def send_message(message = {'jsonrpc' => '2.0','id' => 'responselabel','method' => 'getExchangeAmount','params' => [{'from'=>'eur','to' => 'btc' ,'amount'=> '3'}]},api_secret=@api_secret)
        # https://old.changelly.com/developers#protocol
        @@headers = {'api-key' => @api_key,'sign'=> encrypted_message(@@message)}
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
        @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getCurrenciesFull'}
         results = send_message @@message
         parsed_results = JSON.parse(results)
         return parsed_results["result"]
      end
      def getCurrencies(id='ruby-changelly-getCurrencies')
          # https://old.changelly.com/developers#currency-list
         @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getCurrencies'}
         results = send_message @@message
         parsed_results = JSON.parse(results)
         return parsed_results["result"]
      end
      def getMinAmount(from_currency,to_currency)
        # https://old.changelly.com/developers#currency-list
        # resume from above
        @@message = {'jsonrpc' => '2.0','id' => id.to_s,'method' => 'getMinAmount'}
        results = send_message @@message
        parsed_results = JSON.parse(results)
        return parsed_results["result"]
      end
      def getExchangeAmount(from_currency,to_currency)
      # gets the estimated amount of coins resulting from an exchange.
      #   the estimated result includes the partner fee as well as the exchange fee
      end
      def createTransaction(from_currency,to_currency,reciepient_address,extra_id,refund_address,refund_extra_id)

      end
      def getStatus(transaction_id)

      end

    end
  end
end
