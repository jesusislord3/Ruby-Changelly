require "Ruby/Changelly/version"
require 'rpc4json'
# https://github.com/rest-client/rest-client
require 'openssl'
# http://ruby-doc.org/stdlib-2.6/libdoc/digest/rdoc/Digest/SHA2.html
require 'rest-client'

module Ruby
  module Changelly
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
        @@hmac = OpenSSL::HMAC.digest(encrypted,api_secret,message)
        return hmac
      end
      def send_message(api_secret=@api_secret)
        # https://old.changelly.com/developers#protocol
        @@headers = {'api-key' => @api_key,'sign'=> encrypted_message(api_secret)}
        @@message = {'jsonrpc' => '2.0','id' => 'responselabel','method' => 'getExchangeAmount','params' => [{'from'=>'eur','to' => 'btc' ,'amount'=> '3'}]} # id is the id of the response to match it with.
        # send the message
        @@tosend = @@headers.merge(@@message) # more ram rather than code golf but usable.
        # https://rubygems.org/gems/rpc4json
        # https://github.com/GRoguelon/JSONRPC/blob/master/lib/jsonrpc/client.rb
        # jsonrpc = JSONRPC::Client.new(@api_url)
        # jsonrpc.http_header_extra = @@headers
        return RestClient.get(@api_url,@@tosend) # @@headers.merge!(@@message) could have gone there.

      end
    end
  end
end
