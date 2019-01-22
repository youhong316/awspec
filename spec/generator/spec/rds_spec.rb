require 'spec_helper'

describe 'Awspec::Generator::Spec::Rds' do
  before do
    Awspec::Stub.load 'rds'
  end
  let(:rds) { Awspec::Generator::Spec::Rds.new }
  it 'generate_by_vpc_id generate spec' do
    spec = <<-'EOF'
describe rds('my-rds') do
  it { should exist }
  it { should be_available }
  its(:db_instance_identifier) { should eq 'my-rds' }
  its(:db_instance_class) { should eq 'db.t2.medium' }
  its(:multi_az) { should eq false }
  its(:availability_zone) { should eq 'ap-northeast-1a' }
  it { should have_security_group('group-name-sg') }
  it { should belong_to_vpc('my-vpc') }
  it { should belong_to_db_subnet_group('my-db-subnet-group') }
  it { should have_db_parameter_group('default.mysql5.6').parameter_apply_status('pending-reboot') }
  it { should have_db_parameter_group('custom.mysql5.6').parameter_apply_status('in-sync') }
  it { should have_option_group('default:mysql-5-6').status('in-sync') }
  it { should have_option_group('custom:mysql-5-6').status('in-sync') }
end
EOF
    expect(rds.generate_by_vpc_id('my-vpc').to_s.gsub(/\n/, "\n")).to eq spec
  end
end
