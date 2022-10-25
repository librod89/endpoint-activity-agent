class FilesController < ApplicationController
  def create
    return unless path.present?

    FileUtils.touch(path)
  end

  def update
    return unless path.present?
    return unless params[:file_contents].present?

    File.open(path, 'w') do |file|
      file.puts params[:file_contents]
    end
  end

  def destroy
    return unless path.present?
    return unless File.exists?(path)

    File.open(path, 'w') do |file|
      File.delete(file)
    end
  end

  private

  def path
    @path ||= params[:path]
  end
end
