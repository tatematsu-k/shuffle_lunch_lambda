require 'json'
require './src/models/candidate_table'

def create_handler(event:, context:)
  params = JSON.parse(event["body"], symbolize_names: true)
  candidate = CandidateTable.new(params.slice(:rotation_id, :user_email))
  candidate.save!
  { statusCode: 201, body: JSON.generate({ candidate: candidate.to_h }) }
end
