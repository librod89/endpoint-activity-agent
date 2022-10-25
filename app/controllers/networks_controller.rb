require 'net/http'
require 'uri'
require 'objspace'

class NetworksController < ApplicationController
  before_action :start_time
  after_action :log

  def post
    return unless params[:url].present?

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(form_data)
    request.add_field('Accept', 'application/json')
    http.request(request)
  end

  private

  def form_data
    @form_data ||= permitted_data[:data].to_h
  end

  def permitted_data
    params.permit(data: {})
  end

  def uri
    @uri ||= URI.parse(params[:url])
  end

  def log
    return unless params[:url].present?

    write_to_log([
      'Network connection',
      start_time,
      username[1],
      "#{uri.host}::#{uri.port}",
      "#{request.env['HTTP_HOST']}",
      ObjectSpace.memsize_of(form_data),
      'POST',
      $PROGRAM_NAME,
      command[1],
      Process.pid,
    ])
  end
end
