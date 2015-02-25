template '/etc/auto.master' do
  source 'auto.nfs.erb'
  mode '0644'
  owner 'root'
  action :nothing
end

accumulator 'autofs' do
  target template:  '/etc/auto.nfs'
  filter { |res| res.is_a? Chef::Resource::AutofsNfs }
  transform do|resources|
    mounts = {}
    resources.each do |r|
      mounts.merge!(r.mount_point =>
                    {
                      server: r.server,
                      export: r.export,
                      mount_options: r.mount_options
                    })
    end
    mounts
  end
end

