require './src/models/candidate_table'

class CandidateService
  attr_accessor :member_count

  def initialize(member_count: 4)
    self.member_count = member_count
  end

  def assign!
    CandidateTable.new
  end
end
