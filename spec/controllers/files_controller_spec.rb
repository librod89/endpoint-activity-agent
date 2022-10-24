require 'rails_helper'

describe FilesController do
  context '#create' do
    it 'does not create file if the path param is empty' do
      expect(FileUtils).not_to receive(:touch)

      post :create
    end

    context 'when path params are included' do
      let(:path) { Faker::File.file_name(dir: Rails.root.join('tmp', 'files')) }

      it 'create a new file' do
        expect(FileUtils).to receive(:touch).with(path)

        post :create, params: { path: path }
      end
    end
  end
end
