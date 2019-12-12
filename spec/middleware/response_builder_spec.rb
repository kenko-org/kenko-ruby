require 'kenko/middleware/response_builder'

RSpec.describe Kenko::Middleware::ResponseBuilder do
  let(:bulder) { described_class.new }

  let(:check_statueses) do
    [
      { name: :ok, status: true },
      { name: :bad, status: false },
      { name: :error, status: false }
    ]
  end

  context 'when user wants to see html response' do
    subject { bulder.call(check_statueses, json: false) }

    it { expect(subject).to eq 'OK - ok<br>WARN - bad<br>WARN - error' }
  end

  context 'when user wants to see json response' do
    subject { bulder.call(check_statueses, json: true) }

    it { expect(subject).to eq check_statueses.to_json }
  end
end
