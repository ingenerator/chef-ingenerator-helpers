require "spec_helper"

context "test_notification_trigger" do

  let(:chef_conf) do ChefSpec::SoloRunner.new(
      cookbook_path: %w(./test/cookbooks ../),
      step_into:     %w(notification_trigger),
      platform:      'ubuntu',
      version:       '14.04'
    )
  end

  context 'when set to notify resource' do
    cached(:chef_run) do
      chef_conf.converge('test_helpers::notification_trigger')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'sets the expected notification' do
      expect(chef_run).to queue_notification_trigger('Reload apache')
    end

    it 'triggers the expected action on the resource' do
      expect(chef_run).to reload_service 'apache2'
    end
  end
end
