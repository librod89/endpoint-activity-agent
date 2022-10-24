class FilesController < ApplicationController
  def create
    return unless params[:path].present?

    FileUtils.touch(params[:path])
  end
end
