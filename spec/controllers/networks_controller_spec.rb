require 'rails_helper'
require 'net/http'

describe NetworksController do
  let(:http) { double(Net::HTTP) }
  let(:request) { double(Net::HTTP::Post, add_field: nil) }
  let(:url) { 'http://example.com' }

  before do
    allow(subject).to receive(:write_to_log)
    allow(Net::HTTP).to receive(:new).and_return(http)
    allow(Net::HTTP::Post).to receive(:new).and_return(request)
    allow(http).to receive(:request).with(request)
      .and_return(Net::HTTPResponse)
  end

  context '#post' do
    it 'does not establish connection if URL param is not included' do
      expect(http).not_to receive(:request)

      post :post
    end

    context 'when URL param is included' do
      let(:uri) { URI.parse(url) }

      it 'establishes connection and transmits data' do
        expect(Net::HTTP).to receive(:new).with(uri.host, uri.port)
        expect(Net::HTTP::Post).to receive(:new).with(uri.request_uri)
        expect(request).to receive(:set_form_data).with({ foo: 'bar' })
        expect(http).to receive(:request)

        post :post, params: { url: url, data: { foo: 'bar' } }
      end

      it 'establishes connection even if data is not included' do
        expect(Net::HTTP).to receive(:new).with(uri.host, uri.port)
        expect(Net::HTTP::Post).to receive(:new).with(uri.request_uri)
        expect(request).to receive(:set_form_data).with({})
        expect(http).to receive(:request)

        post :post, params: { url: url }
      end
    end
  end
end
