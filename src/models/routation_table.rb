require 'aws-record'

class RotationTable
  include Aws::Record
  set_table_name ENV['ROTATION_TABLE']
  string_attr :rotation_id, hash_key: true
  map_attr :info
end
