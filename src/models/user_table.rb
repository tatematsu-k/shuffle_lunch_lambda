require 'aws-record'

class UserTable
  include Aws::Record
  set_table_name ENV['DDB_TABLE']
  string_attr :id, hash_key: true
  string_attr :body
end
