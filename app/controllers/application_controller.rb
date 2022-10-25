class ApplicationController < ActionController::API
  ACTIVITY_LOG = Rails.root.join('log', 'activity.csv').freeze

  def write_to_log(data_array)
    File.open(ACTIVITY_LOG, 'a') do |file|
      file.puts data_array.join(',')
    end
  end

  def username
    @username ||= (`ps -p #{Process.pid} -o user`).split(/\n/)
  end

  def command
    @command ||= (`ps -p #{Process.pid} -o command`).split(/\n/)
  end

  def start_time
    @start_time ||= Time.now
  end
end
