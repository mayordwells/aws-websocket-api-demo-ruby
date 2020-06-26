require 'aws-sdk'
require 'json'

CLIENT = Aws::DynamoDB::Client.new
TABLE_NAME = ENV['TABLE_NAME']

def handler(event:, context:)
  connection_data = {}

  connection_data = CLIENT.scan({ table_name: TABLE_NAME, projection_expression: 'connectionId' })

  puts "Connection Data: #{connection_data}"
  puts "Event: #{event}"

  endpoint = "https://#{event['requestContext']['domainName']}/#{event['requestContext']['stage']}"

  puts "Endpoint: #{endpoint}"

  api_gw_management_api = Aws::ApiGatewayManagementApi::Client.new(endpoint: endpoint)

  puts "api_gw_management_api: #{api_gw_management_api}"

  post_data = JSON.parse(event['body'])['data']

  puts "Post Data: #{post_data}"
  puts "Connection Data"

  connection_data['items'].map do |data|
    api_gw_management_api.post_to_connection({
                                                 data: post_data,
                                                 connection_id: data['connectionId']
                                             })
  end

  { statusCode: 200, body: 'Data sent.' }
end