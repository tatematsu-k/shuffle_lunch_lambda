require 'json'
require './src/models/user_table'
require './src/services/shuffle_lunch_implementation_service'

def lambda_handler(event:, context:)
  ShuffleLunchImplementationService.new
  user = UserTable.new(email: "#{SecureRandom.uuid}@gmail.com")
  user.save!
  { statusCode: 200, body: JSON.generate({ user: user.to_h }) }
end
