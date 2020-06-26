require 'aws-sdk'

CLIENT = Aws::DynamoDB::Client.new

def handler(event:, context:)
  delete_params = {
      table_name: ENV['TABLE_NAME'],
      key: {
          connectionId: event['requestContext']['connectionId']
      }
  }

  CLIENT.delete_item(delete_params)


  { statusCode: 200, body: 'Disconnected.' }
end