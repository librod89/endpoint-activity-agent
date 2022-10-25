require 'rails_helper'

describe FilesController do
  let(:path) { Faker::File.file_name(dir: Rails.root.join('tmp', 'files')) }

  context '#create' do
    it 'does not create file if the path param is empty' do
      expect(FileUtils).not_to receive(:touch)

      post :create
    end

    context 'when path param is included' do

      it 'create a new file' do
        expect(FileUtils).to receive(:touch).with(path)

        post :create, params: { path: path }
      end
    end
  end

  context '#update' do
    let(:file_contents) { Faker::Quote.famous_last_words }

    before do
      allow(File).to receive(:open)
    end

    it 'does not modify a file if the path param is empty' do
      expect(File).not_to receive(:open)

      patch :update
    end

    context 'when path param is included' do
      it 'does not modify a file if the file_contents param is empty' do
        expect(File).not_to receive(:open)

        patch :update, params: { path: path }
      end

      context 'when the file_contents param is included' do
        it 'updates the file' do
          expect(File).to receive(:open).with(path, 'w')

          patch :update, params: { path: path, file_contents: file_contents }

          File.open(path, 'r') do |file|
            expect(file.read).to eq "#{file_contents}\n"
          end
        end
      end
    end
  end

  context '#destroy' do
    before do
      allow(File).to receive(:open).and_yield(StringIO.new)
      allow(File).to receive(:delete)
    end

    it 'does not delete a file if the path param is empty' do
      expect(File).not_to receive(:open)

      post :destroy
    end

    it 'does not detete a file that does not exist' do
      expect(File).not_to receive(:open)

      post :destroy, params: { path: path }
    end

    context 'when the file already exists' do
      before do
        allow(File).to receive(:exists?).and_return(true)
      end

      it 'deletes the file' do
        expect(File).to receive(:open).with(path, 'w')
        expect(File).to receive(:delete)

        post :destroy, params: { path: path }
      end
    end
  end
end
