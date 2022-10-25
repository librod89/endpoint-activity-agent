class FilesController < ApplicationController
  def create
    return unless params[:path].present?

    FileUtils.touch(params[:path])
  end

  def update
    return unless params[:path].present?
    return unless params[:file_contents].present?

    File.open(params[:path], 'w') do |file|
      file.puts params[:file_contents]
    end
  end
end
