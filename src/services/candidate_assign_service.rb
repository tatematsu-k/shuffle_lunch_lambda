require './src/models/candidate_table'

class CandidateAssignService
  attr_accessor :member_count
  attr_accessor :not_assigned
  attr_accessor :assigned

  def initialize(member_count: 4)
    self.member_count = member_count
    self.not_assigned = []
    self.assigned = []
  end

  def assign!
    set_not_assigned
    self.not_assigned.shuffle!

    self.member_count.times do |i|
      user = not_assigned.pop
      user.update(lunch_group: "test")
      assigned << user.to_h
    end

    true
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
