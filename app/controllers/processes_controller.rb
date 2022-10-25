class ProcessesController < ApplicationController
  before_action :start_time
  after_action :log

  def start
    return unless params[:path].present?

    path = params[:path]
    args = params[:args] || ''

    fork do
      exec(OS.open_file_command, path, args)
    end
  end

  private

  def log
    return unless params[:path].present?

    write_to_log([
      "Process start",
      start_time,
      username[1],
      $PROGRAM_NAME,
      command[1],
      Process.pid,
    ])
  end
end
