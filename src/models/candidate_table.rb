require 'aws-record'

class CandidateTable
  include Aws::Record
  set_table_name ENV['CANDIDATE_TABLE']
  string_attr :lunch_group, default_value: "not_assigned"
  integer_attr :rotation_id, hash_key: true, default_value: 1
  string_attr :user_email, range_key: true
  map_attr :info
end
