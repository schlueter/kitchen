node[:android_dev][:apt][:repos].each do |repo|
  apt_repository repo[:name] do
    uri repo[:uri]
    distribution node[:lsb][:codename]
    components repo[:components]
    keyserver repo[:keyserver] or nil
    key repo[:key] or nil
  end
end

node[:android_dev][:packages].each do |pckg|
  package pckg
end

link '/usr/lib/i386-linux-gnu/mesa/libGL.so.1' do
  to '/usr/lib/i386-linux-gnu/libGL.so'
end

template '/etc/udev/rules.d/51-android.rules' do
  owner 'root'
  source '51-android.rules.erb'
  variables(
    :dev_user => node[:android_dev][:user],
    :devices  => node[:android_dev][:devices]
  )
end
