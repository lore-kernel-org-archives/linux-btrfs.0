From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: semantics in btrfs multi-device (RAID) mount-by-disk-label ?
Date: Fri, 5 Feb 2010 16:20:28 -0800
Message-ID: <c67eed301002051620i5a2dfc7dl4c2e3b6ec7efe9e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

i created a array,

 mkfs.btrfs -L TEST -m raid10 -d raid10 /dev/sda /dev/sdb /dev/sdc /dev/sdd

btrfs-show
	Label: TEST  uuid: 85aa9ac8-0089-4dd3-b8b2-3c0cbb96c924
	        Total devices 4 FS bytes used 28.00KB
	        devid    3 size 931.51GB used 2.01GB path /dev/sdc
	        devid    4 size 931.51GB used 2.01GB path /dev/sdd
	        devid    2 size 931.51GB used 2.01GB path /dev/sdb
	        devid    1 size 931.51GB used 2.03GB path /dev/sda

this,

 /dev/sda /mnt/TEST btrfs
compress,device=/dev/sdb,device=/dev/sdc,device=/dev/sdd  1 2

in /etc/fstab, mounts the array on boot.

is it correct that it does NOT matter which device I actually mount,
specifying the 'other' devices in the array as options?

i.e.,

 /dev/sda ... device=/dev/sdb,device=/dev/sdc,device=/dev/sdd ...
 /dev/sdb ... device=/dev/sda,device=/dev/sdc,device=/dev/sdd ...
 /dev/sdc ... device=/dev/sda,device=/dev/sdb,device=/dev/sdd ...
 /dev/sdd ... device=/dev/sda,device=/dev/sdb,device=/dev/sdc ...

would all be equivalent?

i understand (http://marc.info/?l=btrfs-devel&m=121302854724031&w=2)
that i can also mount by label.

ls -al /dev/disk/by-label/NAS_TEST
 lrwxrwxrwx 1 root root 9 2010-02-05 15:56 /dev/disk/by-label/TEST -> ../../sdd


 /dev/disk/by-label/TEST /mnt/TEST btrfs
compress,device=/dev/sda,device=/dev/sdb,device=/dev/sdc  1 2

apparently, at device creation, the TEST-label is symlinked
(arbitrarily?) to /dev/sdd, so as devices I suppose I add the "other"
devices, /dev/sd[abc].

in this instance, given the symlink to /dev/sdd, do I still have the
option to use any combination of "other three" devices, or am I fixed
to the symlinked /dev/sdd?
