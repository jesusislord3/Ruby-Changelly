require "Ruby/Changelly/version"
require 'rest-client'
# https://github.com/rest-client/rest-client
require 'openssl'
# http://ruby-doc.org/stdlib-2.6/libdoc/digest/rdoc/Digest/SHA2.html

module Ruby
  module Changelly
    # https://old.changelly.com/developers#getting-started
    # Your code goes here...
    class Changelly
      def initialize(api_key,api_secret)
        @api_key = api_key
        @api_secret = api_secret

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
        encrypted = OpenSSL::Digest('sha512')
        hmac = OpenSSL::HMAC.digest(encrypted,api_secret,message)
        return hmac
      end
      def send_message(api_secret=@api_secret)
        # https://old.changelly.com/developers#protocol
        header = {'api-key' => @api_key,'sign'=> encrypted_message(api_secret)}
        message = {'jsonrpc' => '2.0','id' => 'responselabel','method' => 'getExchangeAmount','params' => [{'from'=>'eur','to' => 'btc' ,'amount'=> '3'}]} # id is the id of the response to match it with.
      end
    end
  end
end
