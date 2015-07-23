require 'spec_helper'

describe BlinkSpec::BlinkSpecRunner do
  context 'when spec files are given' do
    let(:runner) { BlinkSpec::BlinkSpecRunner.new }

    it 'should call rspec with arguments' do
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.running}/)
      expect(runner).to receive(:run_rspec_subprocess).with('fixtures/blinkspec_fixture_spec.rb --color')
      runner.run_specs('fixtures/blinkspec_fixture_spec.rb --color')
    end

    it 'should detect errors immediately during running' do
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.fail}/)
      runner.send(:run_rspec_subprocess, 'fixtures/blinkspec_fixture_spec.rb --tag fixture_fail')
    end
  end

  context 'errors' do
    let(:runner) { BlinkSpec::BlinkSpecRunner.new }

    it 'should handle an error if exit code is not a success exit code' do
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.running}/)
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.error}/)
      allow(runner).to receive(:run_rspec_subprocess) { system("exit 42") }
      success, pending, failure = runner.run_specs('fixtures/blinkspec_fixture_spec.rb')
      expect(success).to eq(nil)
    end

    it 'should handle keyboard interrupts' do
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.running}/)
      expect(runner).to receive(:blink).with(/--rgb=#{BlinkSpec::BlinkColor.error}/)
      allow(runner).to receive(:run_rspec_subprocess).and_raise(Interrupt)
      success, pending, failure = runner.run_specs('fixtures/blinkspec_fixture_spec.rb')
      expect(success).to eq(nil)
    end
  end

  context 'when spec results are given' do
    let(:runner) do
      runner = BlinkSpec::BlinkSpecRunner.new
      runner.instance_variable_set(:@spec_output_file, 'fixtures/blinkspec_fixture.json')
      runner
    end
    it 'should provide the success specs number' do
      success, _pending, _error = runner.send(:results)
      expect(success).to eq(1)
    end
    it 'should provide the pending specs number' do
      _success, pending, _error = runner.send(:results)
      expect(pending).to eq(1)
    end
    it 'should provide the failed specs number' do
      _success, _pending, error = runner.send(:results)
      expect(error).to eq(1)
    end
  end
end
