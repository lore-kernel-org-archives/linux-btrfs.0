From: Jim <jim@webstarts.com>
Subject: install errors 3.2.0-rc4
Date: Tue, 06 Dec 2011 11:10:00 -0500
Message-ID: <4EDE3E58.1030401@webstarts.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Good morning btrfs list,
I am trying to upgrade a remote server from kernel 3.1.0.rc4 to 
3.2.0-rc4.  I am not using make oldconfig.  I use make menuconfig to do 
a new configuration.  After doing the dance of selecting (deselecting 
actually) all includes and modules, I make sure I select btrfs to be 
built in the kernel.  The only place errors show up is in make install 
where there are module not found errors.  The most troubling is:
ERROR: modinfo: could not find module btrfs
Why is it even looking for this module when I specified to build btrfs 
in the kernel.  I would appreciate any thoughts, since this is a remote 
server and any reboot issues involve much hassle with the colo service 
team.  The hardware this is being built on is dual quad-core xeons, 48Gb 
memory 1ea 1Tb system disk and 12ea 1Tb disks on adaptec card to become 
btrfs system.  BTW, I am upgrading to pick up the latest patches as I 
did have some exceptional latency when doing simple ls on the system.  I 
was testing with about 5.5Gb data on the btrfs system, in a file setup 
involving thousands of subvolumes (replaced dirs with subvols for 
snapshots).
Thanks
Jim Maloney
