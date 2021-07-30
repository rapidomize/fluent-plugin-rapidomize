#
# Copyright 2021- Nisal Bandara
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require "oj"
require "rapidomize"
require "fluent/plugin/output"

module Fluent
  module Plugin
    class RapidomizeOutput < Fluent::Plugin::Output
      VERSION = "1.0.0"

      Fluent::Plugin.register_output("rapidomize", self)

      helpers :formatter

      config_param :icappid, :string 
      config_param :appid, :string 
      config_param :apptoken, :string 
      config_param :webhook, :string, :default => nil

      config_section :format do 
        config_set_default :@type, "json"
      end

      def configure(conf)
        super
        http = Rapidomize::Transports::CommonHTTP.new
        
        endpoint = ""
        if @webhook.nil?
          endpoint = "https://intcon.rapidomize.com/api/v1/mo/#{@appid}/icapp/#{@icappid}?token=#{@apptoken}"
        else
          endpoint = @webhook
        end

        @rpz = Rapidomize::Client.new(endpoint, http)
        
        Oj.default_options = { :mode => :compat }
      end

      def write(chunk)
        payload = "[#{chunk.read.chop}]"
        puts "[out_rapidomize] - Sending : #{payload}"
        @rpz.send(payload)
      end

      # format to json array
      def format(tag, time, record)
        # This will generate a string similar to the compat version of following JSON object:
        # {
        #   "time": 1627645990,
        #   "tag": "test.default",
        #   "record": {
        #     "text": "Hello World"
        #   }
        # },
        # final comma allows  
        Oj.dump({ time: time, tag: tag, record: record }) << ","
      end
    end
  end
end
