From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to read
	the system array on sda"
Date: Sat, 23 Jan 2010 21:53:25 -0800
Message-ID: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

after a simple reboot,

	btrfs-show
		Label: TEST uuid: 2ac85206-2d88-47d7-a1e7-a93d80b199f8
		        Total devices 4 FS bytes used 28.00KB
		        devid    1 size 931.51GB used 2.03GB path /dev/sda
		        devid    2 size 931.51GB used 2.01GB path /dev/sdb
		        devid    3 size 931.51GB used 2.01GB path /dev/sdc
		        devid    4 size 931.51GB used 2.01GB path /dev/sdd

but,

	mount /dev/sda /mnt
		mount: wrong fs type, bad option, bad superblock on /dev/sda,
		       missing codepage or helper program, or other error
		       In some cases useful info is found in syslog - try
		       dmesg | tail  or so

where,

	tail -f /var/log/messages,

		Jan 23 21:49:23 test kernel: [   94.949335] device fsid
f9452f77524a701a-28bb2c0e9bab5a99 devid 1 transid 17 /dev/sda
		Jan 23 21:49:23 test kernel: [   94.951716] btrfs: failed to read
the system array on sda
		Jan 23 21:49:23 test kernel: [   94.952748] btrfs: open_ctree failed

mkfs.btrfs -m raid10 -d raid10 /dev/sd[abcd]

	WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
	WARNING! - see http://btrfs.wiki.kernel.org before using
	
	adding device /dev/sdb id 2
	adding device /dev/sdc id 3
	adding device /dev/sdd id 4
	fs created label (null) on /dev/sda
	        nodesize 4096 leafsize 4096 sectorsize 4096 size 3.64TB
	Btrfs Btrfs v0.19

mount /dev/sda /mnt
df -H | grep -i sda
	/dev/sda               4.1T    29k   4.1T   1% /mnt

fyi,

lsb_release -ri
  Distributor ID: SUSE LINUX
  Release:        11.2
uname -a
  Linux test 2.6.31.8-0.1-xen #1 SMP 2009-12-15 23:55:40 +0100 x86_64
x86_64 x86_64 GNU/Linux
rpm -qa | grep btr
  btrfsprogs-0.19-10.1.x86_64


a bug?
