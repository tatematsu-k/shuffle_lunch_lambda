require 'aws-record'

class CandidateTable
  include Aws::Record
  set_table_name ENV['CANDIDATE_TABLE']
  integer_attr :rotation_id, hash_key: true
  string_attr :user_email
end
