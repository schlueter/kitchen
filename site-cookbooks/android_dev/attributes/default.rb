default[:android_dev][:user]    = 'vagrant'
default[:android_dev][:devices] = []

default[:android_dev][:apt][:repos] = [{
    :name       => 'phablet-team',
    :uri        => 'http://ppa.launchpad.net/phablet-team/tools/ubuntu',
    :components => %w{main},
    :keyserver  => 'keyserver.ubuntu.com',
    :key        => '5E51A24C'
},
{
    :name       => 'ubuntu-sdk-team',
    :uri        => 'http://ppa.launchpad.net/ubuntu-sdk-team/ppa/ubuntu',
    :components => %w{main},
    :keyserver  => 'keyserver.ubuntu.com',
    :key        => 'C7122F9B'
}]

default[:android_dev][:packages]    = %w{
    openjdk-6-jdk openjdk-7-jdk
    git gnupg flex bison gperf build-essential 
    zip curl libc6-dev libncurses5-dev:i386 x11proto-core-dev 
    libx11-dev:i386 libreadline6-dev:i386 libgl1-mesa-glx:i386 
    libgl1-mesa-dev g++-multilib mingw32 tofrodos 
    python-markdown libxml2-utils xsltproc zlib1g-dev:i386
}
