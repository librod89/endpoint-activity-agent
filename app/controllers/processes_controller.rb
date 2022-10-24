class ProcessesController < ApplicationController
  def start
    return unless params[:path].present?

    path = params[:path]
    args = params[:args] || ''

    fork do
      exec('open', path, args)
    end
  end
end
