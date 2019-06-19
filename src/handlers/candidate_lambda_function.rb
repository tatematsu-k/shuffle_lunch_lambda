require 'json'
require './src/models/candidate_table'
require './src/services/candidate_service'

def create_handler(event:, context:)
  params = JSON.parse(event["body"], symbolize_names: true)
  candidate = CandidateTable.new(params.slice(:rotation_id, :user_email))
  candidate.save!
  { statusCode: 201, body: JSON.generate({ candidate: candidate.to_h }) }
end

def assign_handler(event:, context:)
  candidate_service = CandidateService.new
  candidate_service.assign!
  { statusCode: 201, body: JSON.generate( { assigned: candidate_service.assigned } ) }
end
