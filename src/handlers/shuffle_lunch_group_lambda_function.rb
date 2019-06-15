require 'json'
require './src/models/user_table'

def lambda_handler(event:, context:)
  user = UserTable.new(email: "#{SecureRandom.uuid}@gmail.com")
  user.save!
  { statusCode: 200, body: JSON.generate({ user: user.to_h }) }
end
