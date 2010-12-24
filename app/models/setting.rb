#
# The ::Setting object emulates a hash with simple bracket methods
# which allow you to get and set values in the Settinguration table:
#
#   Setting['setting.name'] = 'value'
#   Setting['setting.name'] #=> "value"
#
# Currently, you can edit it through web interface or console. The console script is probably the
# easiest way to this:
#
#   % script/console production
#   Loading production environment.
#   >> Setting['setting.name'] = 'value'
#   => "value"
#   >> 
class Setting < ActiveRecord::Base

  class << self
    def [](key)
#      pair = find(:first, :conditions=>["key = ?",key])
      pair = find_by_key(key)
      pair.value unless pair.nil?
    end

    def []=(key, value)
      pair = find_by_key(key)
      unless pair
        pair = new
        pair.key, pair.value = key, value
        pair.save
      else
        pair.value = value
        pair.save
      end
      value
    end

    def to_hash
      Hash[ *find(:all).map { |pair| [pair.key, pair.value] }.flatten ]
    end

    def find_all_as_tree
      returning(ActiveSupport::OrderedHash.new) do |result|

        db_key = (ActiveRecord::Base.connection.adapter_name.downcase == 'mysql' ? '`key`' : 'key')

        # For all settings
        find(:all, :order => db_key).each do |setting|

          # Split the setting path into an array
          path = setting.key.split('.')

          # Set the current level to the root of the hash
          current_level = result

          # iterate through all path levels
          path.each do |path_element|
            if path_element == path.last
              # We are at the end of the path, so set the settting object as the value
              current_level[path_element] = setting

            else
              # Not at the end yet, so first make sure that there is a hash for this key
              current_level[path_element] ||= ActiveSupport::OrderedHash.new

              # Reset the curent level to this hash object for this key
              current_level = current_level[path_element]
            end
          end # if
        end # each
      end # returning
    end # find_all_as_tree
  end
  
  def value=(param)
    self[:value] = param.to_s
  end
  
  def value
    key.ends_with?("?") ?  self[:value] == "true" : self[:value]
  end

  def protected?
    key.match(/[p|P]assword/)
  end

  def protected_value
    protected? ? "********" : value
  end

end
