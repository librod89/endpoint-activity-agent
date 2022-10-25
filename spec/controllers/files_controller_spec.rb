require 'rails_helper'

describe FilesController do
  context '#create' do
    it 'does not create file if the path param is empty' do
      expect(FileUtils).not_to receive(:touch)

      post :create
    end

    context 'when path param is included' do
      let(:path) { Faker::File.file_name(dir: Rails.root.join('tmp', 'files')) }

      it 'create a new file' do
        expect(FileUtils).to receive(:touch).with(path)

        post :create, params: { path: path }
      end
    end
  end

  context '#update' do
    let(:path) { Faker::File.file_name(dir: Rails.root.join('tmp', 'files')) }
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
        before do
          FileUtils.touch(path)
        end

        it 'updates the file' do
          expect(File).to receive(:open).with(path, 'w')

          patch :update, params: { path: path, file_contents: file_contents }

          File.open(path, 'r') do |file|
            expect(file.read).to eq "#{file_contents}\n"
          end
        end
      end

      context 'if the file does not exist yet' do
        it 'creates the file and updates the contents' do
          expect(File.exists?(path)).to be_falsey
          expect(File).to receive(:open).with(path, 'w')
          patch :update, params: { path: path, file_contents: file_contents }
        end
      end
    end
  end
end
