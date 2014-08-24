require 'rails_helper'

describe InstancesController do

  describe 'GET show' do
    before { get :show, id: 1 }

    pending 'displays the instance'
#    it 'is successful' do
#      expect(response).to be_successful
#      expect(response).to render_template(:show)
#      expect(assigns[:instance]).to_not be_nil
#      expect(assigns[:instance]).to eq '999'
#    end
  end

end
