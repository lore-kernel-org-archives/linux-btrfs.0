Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:64564 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933577AbdJQGGq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 02:06:46 -0400
MIME-Version: 1.0
Message-ID: <trinity-6a63d057-56fe-4d75-aadb-73af846c581c-1508220404791@3c-app-gmx-bs57>
From: "Ursul Hempel Egal" <dereselnenntsichimmerzuerst@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: RE: [PATCH 0/4] btrfs-progs repair support for unaligned/mismatched
 device sizes
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Oct 2017 08:06:44 +0200
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have encountered the issue where a btrfs filesystem would not mount due to mismatch of super_total_bytes with fs_devices total_rw_bytes

I was able to fix it with the new parameter --fix-dev-size

Below I have listed the steps I took.

Reference
https://www.spinics.net/lists/linux-btrfs/msg70025.html



My setup

HDDs are
	sdb 2.7TB
	3.7TB (sdd) with partition sdd1
	sde 2.7TB
	sdf 2.7TB


Running on latest version of Fedora stable

[root@localhost ~]# uname -a
Linux localhost.localdomain 4.13.5-200.fc26.x86_64 #1 SMP Thu Oct 5 16:53:13 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost ~]# btrfs --version
btrfs-progs v4.9.1


These are previous conversions of the fs:

1) I had originally created this as a RAID0 array on two drives.
2) Then converted to RAID1 and added a third drive.
3) Then converted to RAID10 and added a fourth drive.

4) I wanted to use the remaining 1TB on sdd, so I
	converted back to RAID1
	removed sdd
	created a sdd1 partition and added it to the filesystem
	converted the fs to RAID10

5) Then I found out that the sdd1 partition size was not aligned to 4096 bytes, so I
	increased partition size to exactly match the sdb drive size
	increased the fs size on sdd1 using btrfs fi resize 4:max /mnt/6TB

6) After reboot the whole filesystem would no longer mount
7) The --fix-dev-size parameter seems to have fixed it, details below








[root@localhost ~]# lsblk 
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0  59.6G  0 disk 
├─sda1   8:1    0   200M  0 part /boot/efi
├─sda2   8:2    0     1G  0 part /boot
└─sda3   8:3    0  58.4G  0 part /
sdb      8:16   0   2.7T  0 disk 
sdc      8:32   0 465.8G  0 disk 
├─sdc1   8:33   0   450M  0 part 
├─sdc2   8:34   0   100M  0 part 
├─sdc3   8:35   0    16M  0 part 
├─sdc4   8:36   0 146.5G  0 part 
└─sdc5   8:37   0 318.7G  0 part /home
sdd      8:48   0   3.7T  0 disk 
├─sdd1   8:49   0   2.7T  0 part 
└─sdd2   8:50   0 931.5G  0 part 
sde      8:64   0   2.7T  0 disk 
sdf      8:80   0   2.7T  0 disk 


[root@localhost ~]# btrfs inspect dump-super /dev/sdd1
superblock: bytenr=65536, device=/dev/sdd1
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0x9c9d6da0 [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			41806396-8892-4278-a534-23ce61d78970
label			6TB
generation		245580
root			48007926906880
sys_array_size		193
chunk_root_generation	245539
root_level		1
chunk_root		38578614435840
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		12002371923968
bytes_used		4542498934784
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x163
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
cache_generation	245580
uuid_tree_generation	245580
dev_item.uuid		2d19c08c-8a16-48c2-ae28-4547b19ae419
dev_item.fsid		41806396-8892-4278-a534-23ce61d78970 [match]
dev_item.type		0
dev_item.total_bytes	3000592982016
dev_item.bytes_used	2725190303744
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		4
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0




[root@localhost ~]# btrfs inspect dump-super /dev/sdb
superblock: bytenr=65536, device=/dev/sdb
---------------------------------------------------------
csum_type		0 (crc32c)
csum_size		4
csum			0xb540bd25 [match]
bytenr			65536
flags			0x1
			( WRITTEN )
magic			_BHRfS_M [match]
fsid			41806396-8892-4278-a534-23ce61d78970
label			6TB
generation		245580
root			48007926906880
sys_array_size		193
chunk_root_generation	245539
root_level		1
chunk_root		38578614435840
chunk_root_level	1
log_root		0
log_root_transid	0
log_root_level		0
total_bytes		12002371923968
bytes_used		4542498934784
sectorsize		4096
nodesize		16384
leafsize		16384
stripesize		4096
root_dir		6
num_devices		4
compat_flags		0x0
compat_ro_flags		0x0
incompat_flags		0x163
			( MIXED_BACKREF |
			  DEFAULT_SUBVOL |
			  BIG_METADATA |
			  EXTENDED_IREF |
			  SKINNY_METADATA )
cache_generation	245580
uuid_tree_generation	245580
dev_item.uuid		549ba2bf-880c-4fc2-8e5f-f3445b32f84e
dev_item.fsid		41806396-8892-4278-a534-23ce61d78970 [match]
dev_item.type		0
dev_item.total_bytes	3000592982016
dev_item.bytes_used	2725190303744
dev_item.io_align	4096
dev_item.io_width	4096
dev_item.sector_size	4096
dev_item.devid		1
dev_item.dev_group	0
dev_item.seek_speed	0
dev_item.bandwidth	0
dev_item.generation	0






[root@localhost ~]# btrfs fi show --raw

Label: '6TB'  uuid: 41806396-8892-4278-a534-23ce61d78970
	Total devices 4 FS bytes used 4542498934784
	devid    1 size 3000592982016 used 2725190303744 path /dev/sdb
	devid    2 size 3000592982016 used 2725190303744 path /dev/sdf
	devid    3 size 3000592982016 used 2725190303744 path /dev/sde
	devid    4 size 3000592982016 used 2725190303744 path /dev/sdd1




[root@localhost ~]# mount -t btrfs /dev/sdb /mnt/6TB/
mount: /mnt/6TB: wrong fs type, bad option, bad superblock on /dev/sdb, missing codepage or helper program, or other error.
[root@localhost ~]# mount -t btrfs /dev/sdd1 /mnt/6TB/
mount: /mnt/6TB: wrong fs type, bad option, bad superblock on /dev/sdd1, missing codepage or helper program, or other error.
[root@localhost ~]# dmesg | tail
[ 7743.052419] BTRFS info (device sdd1): disk space caching is enabled
[ 7743.052426] BTRFS info (device sdd1): has skinny extents
[ 7743.103575] BTRFS error (device sdd1): super_total_bytes 12002371923968 mismatch with fs_devices total_rw_bytes 12002371928064
[ 7743.103583] BTRFS error (device sdd1): failed to read chunk tree: -22
[ 7743.131815] BTRFS error (device sdd1): open_ctree failed
[ 7763.318712] BTRFS info (device sdd1): disk space caching is enabled
[ 7763.318718] BTRFS info (device sdd1): has skinny extents
[ 7763.369597] BTRFS error (device sdd1): super_total_bytes 12002371923968 mismatch with fs_devices total_rw_bytes 12002371928064
[ 7763.369605] BTRFS error (device sdd1): failed to read chunk tree: -22
[ 7763.392512] BTRFS error (device sdd1): open_ctree failed

[root@localhost ~]# mount -t btrfs -o ro,usebackuproot /dev/sdb /mnt/6TB/
mount: /mnt/6TB: wrong fs type, bad option, bad superblock on /dev/sdb, missing codepage or helper program, or other error.
[root@localhost ~]# mount -t btrfs -o ro,usebackuproot /dev/sdd1 /mnt/6TB/
mount: /mnt/6TB: wrong fs type, bad option, bad superblock on /dev/sdd1, missing codepage or helper program, or other error.
[root@localhost ~]# dmesg | tail -12
[ 7883.324339] BTRFS info (device sdd1): trying to use backup root at mount time
[ 7883.324344] BTRFS info (device sdd1): disk space caching is enabled
[ 7883.324346] BTRFS info (device sdd1): has skinny extents
[ 7883.348445] BTRFS error (device sdd1): super_total_bytes 12002371923968 mismatch with fs_devices total_rw_bytes 12002371928064
[ 7883.348452] BTRFS error (device sdd1): failed to read chunk tree: -22
[ 7883.368949] BTRFS error (device sdd1): open_ctree failed
[ 7888.549118] BTRFS info (device sdd1): trying to use backup root at mount time
[ 7888.549124] BTRFS info (device sdd1): disk space caching is enabled
[ 7888.549127] BTRFS info (device sdd1): has skinny extents
[ 7888.591806] BTRFS error (device sdd1): super_total_bytes 12002371923968 mismatch with fs_devices total_rw_bytes 12002371928064
[ 7888.591811] BTRFS error (device sdd1): failed to read chunk tree: -22
[ 7888.613883] BTRFS error (device sdd1): open_ctree failed



Then downloaded the btrfs-progs branch from here (Latest commit 6ff9231)
https://github.com/adam900710/btrfs-progs/tree/check_unaligned_dev


[root@localhost btrfs-progs-check_unaligned_dev]# ./btrfs check --fix-dev-size /dev/sdd1
Checking filesystem on /dev/sdd1
UUID: 41806396-8892-4278-a534-23ce61d78970
Fixed super total bytes, old size: 12002371923968 new size: 12002371928064
Fixed unaligned/mismatch total_bytes for superblock and device item

[root@localhost ~]# dmesg | tail -2

[ 8134.623626]  sdf:
[ 8134.734011]  sdb:


Used bytes changed

[root@localhost ~]# btrfs fi show --raw

Label: '6TB'  uuid: 41806396-8892-4278-a534-23ce61d78970
	Total devices 4 FS bytes used 4542498934784
	devid    1 size 3000592982016 used 2679019405312 path /dev/sdb
	devid    2 size 3000592982016 used 2679019405312 path /dev/sdf
	devid    3 size 3000592982016 used 2679019405312 path /dev/sde
	devid    4 size 3000592982016 used 2679019405312 path /dev/sdd1


[root@localhost ~]# mount /dev/sdb mnt/6TB/

[ 8454.694653] BTRFS info (device sdd1): disk space caching is enabled
[ 8454.694657] BTRFS info (device sdd1): has skinny extents
[ 8462.707166] BTRFS info (device sdd1): checking UUID tree



Scrub is currently running, but looks like there are no errors on the fs.
