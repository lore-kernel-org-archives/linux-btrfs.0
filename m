From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: RAID-10 arrays built with btrfs & md report 2x difference in
	available size?
Date: Sat, 23 Jan 2010 21:31:07 -0800
Message-ID: <c67eed301001232131n2a7f88acx857df19ea95371a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I created a btrfs RAID-10 array across 4-drives,

 mkfs.btrfs -L TEST -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd
 btrfs-show
 	Label: TEST  uuid: 2ac85206-2d88-47d7-a1e7-a93d80b199f8
 	        Total devices 4 FS bytes used 28.00KB
 	        devid    1 size 931.51GB used 2.03GB path /dev/sda
 	        devid    2 size 931.51GB used 2.01GB path /dev/sdb
 	        devid    4 size 931.51GB used 2.01GB path /dev/sdd
 	        devid    3 size 931.51GB used 2.01GB path /dev/sdc

@ mount,

 mount /dev/sda /mnt
 df -H | grep /dev/sda
	/dev/sda               4.1T    29k   4.1T   1% /mnt

for RAID-10 across 4-drives, shouldn't the reported/available size be
1/2x4TB ~ 2TB?

e.g., using mdadm to build a RAID-10 array across the same drives,

 mdadm -v --create /dev/md0 --level=raid10 --raid-devices=4 /dev/sd[abcd]1
 pvcreate     /dev/md0
pvs
  PV         VG   Fmt  Attr PSize   PFree
  /dev/md0        lvm2 --   1.82T 1.82T

is the difference in available array space real, an artifact, or a
misunderstanding on my part?

thanks.
