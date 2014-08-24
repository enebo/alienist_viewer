require 'rails_helper'

describe InstancesController do
  let(:data_file) { File.expand_path(File.join('spec', 'fixtures', 'data.json')) }

  before do
    allow(JSON).to receive(:load) { File.read(data_file) }
  end

  describe 'GET show' do
    before { get :show, id: 2 }

    it 'is successful' do
      expect(response).to be_successful
      expect(response).to render_template(:show)
      expect(assigns[:instance].id).to eq 2
    end
  end

end
