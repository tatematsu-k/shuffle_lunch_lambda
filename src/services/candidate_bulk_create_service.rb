require './src/models/candidate_table'

class CandidateBulkCreateService
  def self.bulk_create!(candidates_param)
    candidates_param.each do |param|
      candidate = CandidateTable.new(param.slice(:rotation_id, :user_email, :user_name, :info))
      candidate.save!
    end
    true
  end
end
