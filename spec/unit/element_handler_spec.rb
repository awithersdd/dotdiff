require 'spec_helper'

class MockDriver
  def execute_script(str)
  end
end

RSpec.describe 'DotDiff::ElementHandler' do
  subject { DotDiff::ElementHandler.new(MockDriver.new) }

  before do
    DotDiff.js_elements_to_hide = [
      "document.getElementByClassName('master-opt')[0]",
      "document.getElementById('user-links')"
    ]
  end

  describe '#hide' do
    it 'calls execute_script adding css class' do
      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].style.visibility = 'hidden'").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').style.visibility = 'hidden'").once

      subject.hide
    end
  end

  describe '#show' do
    it 'calls execute_script removing css class' do
      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementByClassName('master-opt')[0].style.visibility = ''").once

      expect_any_instance_of(MockDriver).to receive(:execute_script)
        .with("document.getElementById('user-links').style.visibility = ''").once

      subject.show
    end
  end

  describe '#elements' do
    before { DotDiff.js_elements_to_hide = nil }

    it 'returns an empty array when not set' do
      expect(subject.elements).to eq []
    end

    it 'returns the user set value js_elements_to_hide' do
      DotDiff.js_elements_to_hide = ['blah', 'blue']
      expect(subject.elements).to eq ['blah', 'blue']
    end
  end
end
