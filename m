From: Yee-Ting Li <yee379@gmail.com>
Subject: ioctl returns 0 and wrong fs type on disk addition
Date: Sat, 29 May 2010 22:53:37 -0700
Message-ID: <0D557918-A3FB-4D1A-A7EB-9C76D194EF6C@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

using v0.19 on ubuntu 10.4

i have a raid0 meta and data across 2 drives (sdf, sdg); i recently added another drive to the mix using 'btrfs-vol -a /dev/sde'. it returned 'ioctl returns 0'. 

i didn't think anything of it as the extra disk showed up. 

i did not do a rebalance. but i did write some stuff to the array.

$ btrfs-show
failed to read /dev/sr0
Label: none  uuid: ea7ea0b3-bc42-4b0c-9173-346df61d4454
	Total devices 3 FS bytes used 3.51TB
	devid    3 size 1.82TB used 0.00 path /dev/sde
	devid    1 size 1.82TB used 1.82TB path /dev/sdf
	devid    2 size 1.82TB used 1.82TB path /dev/sdg

however after a rebooted i can now only mount the disk in degraded mode. 

$ mount -t btrfs /dev/sdf /mnt/stripe/
mount: wrong fs type, bad option, bad superblock on /dev/sdf,
       missing codepage or helper program, or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

dmesg:
[  107.977464] device fsid c4b42bcb3a07eea-54441df66d347391 devid 1 transid 8747 /dev/sdf
[  107.977932] btrfs: failed to read the system array on sdf
[  108.000143] btrfs: open_ctree failed

any suggestions on how i can get out of this pickle? (except for copy all the data off the drives)