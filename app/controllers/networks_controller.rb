require 'net/http'
require 'uri'

class NetworksController < ApplicationController
  def post
    return unless params[:url].present?

    uri = URI.parse(params[:url])
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(permitted_data[:data].to_h)
    request.add_field("Accept", "application/json")
    http.request(request)
  end

  private

  def permitted_data
    params.permit(data: {})
  end
end
