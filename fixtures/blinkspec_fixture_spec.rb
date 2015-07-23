require 'spec_helper'

describe "BlinkSpec fixtures", fixture: true do
  context 'fixture', fixture_fail: true do
    it 'should fail' do
      fail
    end
  end
end
