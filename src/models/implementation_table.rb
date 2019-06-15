require 'aws-record'

class ImplementationTable
  include Aws::Record
  set_table_name ENV['IMPLEMENTATION_TABLE']
  string_attr :rotation_id, hash_key: true
  string_attr :shuffle_lunch_group_id
  string_attr :user_email
end
