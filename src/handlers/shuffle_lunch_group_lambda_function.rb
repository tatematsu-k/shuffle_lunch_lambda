require 'json'

def lambda_handler(event:, context:)
  { statusCode: 200, body: JSON.generate({message: 'Hello from Lambda!'}) }
end
