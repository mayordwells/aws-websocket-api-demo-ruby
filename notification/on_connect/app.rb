require 'aws-sdk'

CLIENT = Aws::DynamoDB::Client.new

def handler(event:, context:)
  puts "Event: #{event}"
  puts "Table Name: #{ENV['TABLE_NAME']}"

  CLIENT.put_item({
                      item: {
                          connectionId: event['requestContext']['connectionId']
                      },
                      table_name: ENV['TABLE_NAME']
                  })

  {statusCode: 200, body: 'Connected.'}
end