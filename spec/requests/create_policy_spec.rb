require 'rails_helper'

describe 'Create Policy', type: :request do
  describe 'POST /policies' do
    context 'when all fields filled correctly' do
      it 'creates a policy successfully' do
        post policies_path

        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Criar apólice")
      end
    end
  end
end
