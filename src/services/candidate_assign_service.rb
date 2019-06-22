require './src/models/candidate_table'

class CandidateAssignService
  MAX_RETRY_COUNT = 10

  attr_accessor :member_count
  attr_accessor :team_count
  attr_accessor :lunch_group_prefix

  attr_accessor :not_assigned
  attr_accessor :assigned
  attr_accessor :team_belongs

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
      self.team_belongs = {}

      self.member_count.times do |team_member_id|
        user = retry_pick
        assign_user(user: user, team_id: team_id)
      end
    end

    true
  end

  private

  def retry_pick(retry_count: 0)
    user = not_assigned.pop
    return user if retry_count >= MAX_RETRY_COUNT
    user.info["belongs"]&.each do |belong|
      belong_name = belong["name"]
      team_degree = team_belongs[belong_name]
      if team_degree.nil?
        return user
      else
        if team_degree * belong["degree"] * 10000 > rand(10000)
          not_assigned.unshift(user)
          return retry_pick(retry_count: retry_count + 1)
        else
          return user
        end
      end
    end
  end

  def assign_user(user:, team_id:)
    user.update(lunch_group: "#{self.lunch_group_prefix}_#{team_id + 1}")
    set_team_belongs(user: user)
    assigned << user.to_h
  end

  def set_team_belongs(user:)
    user.info["belongs"]&.each do |belong|
      belong_name = belong["name"]
      before_value = team_belongs[belong_name]

      if before_value.nil?
        team_belongs[belong_name] = belong["degree"]
      else
        team_belongs[belong_name] = [before_value, belong["degree"]].max
      end
    end
  end

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
