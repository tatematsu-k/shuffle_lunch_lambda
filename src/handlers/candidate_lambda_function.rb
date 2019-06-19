require 'json'
require './src/models/candidate_table'
require './src/services/candidate_bulk_create_service'
require './src/services/candidate_assign_service'

def create_handler(event:, context:)
  params = JSON.parse(event["body"], symbolize_names: true)
  candidate = CandidateTable.new(params.slice(:rotation_id, :user_email))
  candidate.save!
  { statusCode: 201, body: JSON.generate({ candidate: candidate.to_h }) }
end

def bulk_create_handler(event:, context:)
  params = JSON.parse(event["body"], symbolize_names: true)
  CandidateBulkCreateService.bulk_create!(params[:candidates])
  { statusCode: 201, body: JSON.generate(params.to_h) }
end

def assign_handler(event:, context:)
  candidate_asign_service = CandidateAssignService.new
  candidate_asign_service.assign!
  { statusCode: 201, body: JSON.generate( { assigned: candidate_asign_service.assigned } ) }
end
