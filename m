Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:56470 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbaLIGFw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Dec 2014 01:05:52 -0500
Message-ID: <5486913D.2010900@hiperscan.com>
Date: Tue, 09 Dec 2014 07:05:49 +0100
From: Florian Stuelpner <florian.stuelpner@hiperscan.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: =?UTF-8?B?ZnJhbnppc2thIE7DpHBlbHQ=?=
	<franziska.naepelt@hiperscan.com>
Subject: cannot delete subvolumes
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

Our specifications are:
- Debian 7.7
- kernel version: 3.17.4

Two weeks ago we started a btrfs balance. Some days later we stopped the 
balance. The messages log show some errors (see below).

While balancing we removed some snapshots, this operations failed with a 
error messages.

For example: ERROR: error accessing 
'/mnt/btrfs/snapshots/home/2014-10-23--20-31-18-@daily'

Now there are some subvolumes without a owner, last modified date etc. .

Additionally the ls command returns an error:
stuelpner@hsad-srv-03:/boot$ ls -l /mnt/btrfs/snapshots/home/
ls: cannot access /mnt/btrfs/snapshots/home/2014-10-23--20-31-18-@daily: 
Cannot allocate memory
total 0
drwxr-xr-x 1 root root 952 May 20 2014 2014-06-30--18-49-09-@monthly
drwxr-xr-x 1 root root 952 May 20 2014 2014-07-01--02-52-01-@monthly
drwxr-xr-x 1 root root 952 May 20 2014 2014-08-01--02-52-01-@monthly
drwxr-xr-x 1 root root 990 Aug 28 07:00 2014-09-01--02-52-01-@monthly
drwxr-xr-x 1 root root 990 Aug 28 07:00 2014-10-01--02-52-02-@monthly
d????????? ? ? ? ? ? 2014-10-23--20-31-18-@daily
drwxr-xr-x 1 root root 996 Oct 21 12:38 2014-11-01--02-52-01-@monthly

This subvolumes cannot be access nor deleted:

~# btrfs subvolume
delete /mnt/btrfs/snapshots/transfer/2014-10-21--20-50-44-\@daily
Transaction commit: none (default)
ERROR: error accessing
'/mnt/btrfs/snapshots/transfer/2014-10-21--20-50-44-@daily'

Filesystem info:

~# btrfs fi show
Label: 'btrfs-data' uuid: 47a6ce34-6b63-4202-a7da-c1f6dbe48676
Total devices 4 FS bytes used 2.22TiB
devid 1 size 2.73TiB used 2.42TiB path /dev/sda
devid 2 size 2.73TiB used 2.42TiB path /dev/sdb
devid 3 size 2.73TiB used 186.00GiB path /dev/sdc
devid 4 size 2.73TiB used 186.00GiB path /dev/sdd
Label: 'spectral-data' uuid: aaaba9e0-7710-4295-88b1-c0ee9bd2eff8
Total devices 2 FS bytes used 640.00KiB
devid 1 size 238.47GiB used 2.03GiB path /dev/sdg
devid 2 size 238.47GiB used 2.01GiB path /dev/sdh
Btrfs v3.12

root@hsad-srv-03:~# btrfs fi df /mnt/btrfs
Data, RAID1: total=2.32TiB, used=2.06TiB
Data, single: total=8.00MiB, used=0.00B
System, RAID1: total=8.00MiB, used=400.00KiB
System, single: total=4.00MiB, used=0.00B
Metadata, RAID1: total=287.00GiB, used=159.31GiB
Metadata, single: total=8.00MiB, used=0.00B
GlobalReserve, single: total=512.00MiB, used=0.00B

message.log:
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323328] btrfs D 
ffff88083ed92dc0 0 7313 7296 0x00000000
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323335] ffff88068d816310 
0000000000000082 ffff88083ae971d0 0000000000000086
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323340] 0000000000012dc0 
0000000000012dc0 ffff88068d816310 ffff88058028ffd8
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323345] ffff88083ec12dc0 
7fffffffffffffff 7fffffffffffffff 0000000000000002
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323351] Call Trace:
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323364] [] ? 
console_conditional_schedule+0xf/0xf
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323372] [] ? 
schedule_timeout+0x1c/0xf7
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323378] [] ? 
__queue_work+0x1ef/0x23d
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323384] [] ? 
__wait_for_common+0x120/0x158
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323390] [] ? 
try_to_wake_up+0x1c7/0x1c7
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323441] [] ? 
btrfs_async_run_delayed_refs+0xbd/0xda [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323475] [] ? 
__btrfs_end_transaction+0x2b3/0x2d6 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323512] [] ? 
relocate_block_group+0x2a1/0x4cd [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323548] [] ? 
btrfs_relocate_block_group+0x14f/0x267 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323584] [] ? 
btrfs_relocate_chunk.isra.58+0x58/0x5e2 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323609] [] ? 
btrfs_item_key_to_cpu+0x12/0x30 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323645] [] ? 
btrfs_get_token_64+0x76/0xc6 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323681] [] ? 
release_extent_buffer+0x9d/0xa4 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323717] [] ? 
btrfs_balance+0x9b0/0xb9d [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323752] [] ? 
btrfs_ioctl_balance+0x21a/0x297 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323788] [] ? 
btrfs_ioctl+0x1134/0x20e5 [btrfs]
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323794] [] ? 
path_openat+0x233/0x4c5
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323801] [] ? 
__do_page_fault+0x339/0x3df
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323807] [] ? vma_link+0x6b/0x8a
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323813] [] ? 
do_vfs_ioctl+0x3ed/0x436
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323819] [] ? SyS_ioctl+0x49/0x77
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323824] [] ? 
page_fault+0x22/0x30
Nov 24 01:22:44 hsad-srv-03 kernel: [112256.323829] [] ? 
system_call_fastpath+0x16/0x1b

Do you have an idea? Can you help us please?

Regards,
Florian
