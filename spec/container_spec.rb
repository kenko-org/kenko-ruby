RSpec.describe Kenko::Container do
  let(:container) { described_class }

  after { container.flush }

  describe '#keys' do
    subject { container.keys }

    it { expect(subject).to eq [] }
  end

  describe '#flush' do
    it 'flushes all checks from container' do
      container.register(:test) { 123 }
      expect(container.keys).to eq [:test]

      container.flush
      expect(container.keys).to eq []
    end
  end

  describe '#register' do
    before { container.register(:test) { 123 } }

    it 'registers check by specific name' do
      expect(container.keys).to eq [:test]
    end

    context 'when name is different type' do
      before { container.register('symbol') { 123 } }

      it { expect(container.keys).to eq [:test, :symbol] }
    end

    context 'when user try to register existed check' do
      it {
        expect {
          container.register(:test) { 321 }
        }.to raise_error(Kenko::Error, 'There is already an item registered with the key :test')
      }
    end
  end

  describe '#resolver' do
    subject { container.resolver(:test) }

    it 'resolves registered check' do
      container.register(:test) { 123 }
      expect(subject).to eq 123
    end

    context 'when name is different type' do
      it 'resolves registered check' do
        container.register('test') { 123 }
        expect(subject).to eq 123
      end
    end

    context 'when user try to register existed check' do
      it {
        expect {
          container.resolver(:not_registered)
        }.to raise_error(Kenko::Error, 'Nothing registered with the key :not_registered')
      }
    end
  end
end
