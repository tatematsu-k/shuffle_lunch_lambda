require './src/models/candidate_table'

class CandidateAssignService
  attr_accessor :member_count
  attr_accessor :team_count
  attr_accessor :lunch_group_prefix
  attr_accessor :not_assigned
  attr_accessor :assigned

  def initialize(
      member_count: 4,
      team_count: 4,
      lunch_group_prefix: Date.today.strftime('%Y_%m')
    )
    self.member_count = member_count
    self.team_count = team_count
    self.lunch_group_prefix = lunch_group_prefix
    self.not_assigned = []
    self.assigned = []
  end

  def assign!
    set_not_assigned
    raise "not issuable" unless assignable?

    self.not_assigned.shuffle!

    self.team_count.times do |team_id|
      self.member_count.times do |team_member_id|
        user = not_assigned.pop
        user.update(lunch_group: "#{self.lunch_group_prefix}_#{team_id + 1}")
        assigned << user.to_h
      end
    end

    true
  end

  private

  def assignable?
    self.not_assigned.count >= self.member_count * self.team_count
  end

  def set_not_assigned
    CandidateTable.query(
      index_name: 'candidateGSI_1',
      key_condition_expression: '#test = :lunch_group',
      expression_attribute_names: { '#test' => 'lunch_group' },
      expression_attribute_values: { ':lunch_group' => 'not_assigned' }
    ).each do |candidate|
      not_assigned << candidate
    end
  end
end
