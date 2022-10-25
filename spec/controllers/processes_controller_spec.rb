require 'rails_helper'

describe ProcessesController do
  before do
    allow(subject).to receive(:write_to_log)
  end

  context '#start' do
    it 'does not call exec if the path param is empty' do
      expect(subject).not_to receive(:fork)

      post :start
    end

    context 'when path params are included' do
      let(:path) { Rails.root.join('log', 'development.log').to_s }

      it 'calls exec with expected path but no args' do
        expect(subject).to receive(:fork).and_yield do |block|
          expect(block).to receive(:exec).with(OS.open_file_command, path, '')
        end

        post :start, params: { path: path }
      end

      context 'when arg params are included' do
        let(:args) { "-e" }

        it 'calls exec with expected args' do
          expect(subject).to receive(:fork).and_yield do |block|
            expect(block).to receive(:exec).with(OS.open_file_command, path, args)
          end

          post :start, params: { path: path, args: args }
        end
      end
    end
  end
end
