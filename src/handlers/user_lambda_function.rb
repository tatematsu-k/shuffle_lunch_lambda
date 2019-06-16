require 'json'
require './src/models/user_table'

def create_handler(event:, context:)
  user = UserTable.new(email: JSON.parse(event["body"])["email"])
  user.save!
  { statusCode: 200, body: JSON.generate({ user: user.to_h }) }
end
