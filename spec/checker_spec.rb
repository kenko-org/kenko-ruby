RSpec.describe Kenko::Checker do
  let(:checker) { described_class.new(container: Kenko::Container) }

  before do
    Kenko::Container.register(:ok) { 123 }
    Kenko::Container.register(:bad) { nil }
    Kenko::Container.register(:error) { fail }
  end

  after { Kenko::Container.flush }

  context 'when user wants to check everything' do
    subject { checker.call(checks: :all) }

    it do
      expect(subject).to eq [
        { name: :ok,  status: true },
        { name: :bad, status: false },
        { name: :error, status: false }
      ]
    end
  end

  context 'when user wants to check specific checks' do
    subject { checker.call(checks: [:ok, :bad]) }

    it do
      expect(subject).to eq [
        { name: :ok,  status: true },
        { name: :bad, status: false }
      ]
    end
  end
end
