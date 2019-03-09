class JobsController < ApplicationController

  # enum true
  def true?(obj)
  return obj == "true" || obj == "false"
  end
# enum on/off
  def on?(obj)
    return obj == "on" || obj == "off"
  end
# enum yes/no
  def yes?(obj)
    return obj == "yes" || obj == "no"
  end

# Support function for create
  def support_create(arr)
    obj = {}
# Pair matching through regex
    arr.each do |t|
      pairs = t.split("=")
      key = pairs[0]
      value = pairs[1]

      if value.match(/\A[-+]?[0-9]+\z/)
        obj[key] = value
      end

      if value.match(/[0-9].[0-9]/)
        obj[key] = value
      end

      if value.match(/[a-z]/)
        obj[key] = value
      end

      if value.match(/[0-9][a-z]/)
        obj[key] = value.chomp("user")
      end
    end
  # instantiation of new config file
    @job = Job.new
# making sure each attribute is accounted for
  @job.attributes.each do |t|
    # iterating through each attribute in the object
    obj.keys.each do |x|
      # if enum cases
      if t[0] != "verbose" || t[0] != "test_mode" || t[0] != "debug_mode" || t[0] != "send_notifications"
        if t[0] == x
        @job[t[0]] = obj[x]
        end
      end
      # Enum Cases
      if t[0] == "verbose" || t[0] == "test_mode" || t[0] == "debug_mode" || t[0] == "send_notifications"
        # True // False
        if t[0] == x && t[0] == "verbose"
          if true?(obj[x])
            @job[t[0]] = obj[x]
          else
            raise obj[x] + " is not true, false. Please Re-Enter"
          end
        end
        #  Yes / No
        if t[0] == x && t[0] == "send_notifications"
          if yes?(obj[x])
            @job[t[0]] = obj[x]
          else
            raise obj[x] + " does not equal yes/no"
          end
      end
        # On / Off
        if t[0] == x && t[0] == "test_mode" || t[0] == x && t[0] == "debug_mode"
          if on?(obj[x])
            @job[t[0]] = obj[x]
          else
            raise obj[x] + " does not equal on or off"
            end
          end
        # if statement scope below
        end
      # x scope below
      end
      # t scope below
    end
    # OPTIONAL: Keep client inputted string
    @job[:clients] = params[:job][:clients]
    @job.save
    # root below
end


def home
  @jobs = Job.all
  @job = Job.new
end

def create
  arr = []
  split_str = params[:job][:clients].split(" ")

  split_str.each.with_index do |val,index|

    if val.match(/[A-Za-z]=[a-z0-9]/)
      arr.push(val)
      split_str.delete_at(index)
      end
    end

  setters = split_str.each_index.select { |i| split_str[i].include?("=") }
  setters.each do |s|

    if split_str[s] == "="
      arr.push(split_str[s - 1] + split_str[s] + split_str[s + 1])
    end

    if split_str[s].match(/[a-z]=/)
      arr.push(split_str[s] + split_str[s + 1])
    end
    if split_str[s].match(/=[a-z]/)
      arr.push(split_str[s - 1] + split_str[s])
    end
  end
  support_create(arr)
  redirect_to root_path
  flash[:notice] = "Successfully Saved Config"
end

private



end
