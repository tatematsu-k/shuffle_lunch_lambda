require 'aws-record'

class UserTable
  include Aws::Record
  set_table_name ENV['DDB_TABLE']
  string_attr :email, hash_key: true
end
