Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:45984 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754780AbaCPXxn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 16 Mar 2014 19:53:43 -0400
Received: from c-75-70-18-61.hsd1.co.comcast.net ([75.70.18.61]:60719 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WPKsB-001TCO-2s
	for linux-btrfs@vger.kernel.org; Sun, 16 Mar 2014 17:53:43 -0600
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: [bug] hang when using btrfs device add on degraded raid5 volume
Message-Id: <E1C17BAC-24CC-4767-8158-9092B2AD3C25@colorremedies.com>
Date: Sun, 16 Mar 2014 17:53:42 -0600
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm not sure if this is a bug or expected at this point.

Create and populate 3x 8TB virtual devices
Boot kernel 3.13.6-200.fc20.x86_64
btrfs-progs v3.12
mkfs.btrfs -d raid5 -m raid1 /dev/sd[bcd]
mount /mnt
cp -a <source> /mnt/
umount /mnt
poweroff

In VM, remove sdd virtual disk and replace with blank image (which becomes sdd).
Boot kernel 3.14.0-0.rc6.git0.1.fc21.x86_64
btrfs replace start 3 /dev/sdd /mnt
"dev_replace cannot yet handle RAID5/RAID6"
btrfs device add /dev/sdd /mnt
*hang*

ps reports D+ status for btrfs process.


During the btrfs device add D+ hanged state with 3.14.0-0.rc6.git0.1.fc21.x86_64.

sysrq t

[ 1235.585226] btrfs           D ffff88009d914640     0   598    508 0x00000084
[ 1235.585226]  ffff88009ecf99b8 0000000000000086 ffff880094935f00 ffff88009ecf9fd8
[ 1235.585226]  0000000000014640 0000000000014640 ffff880094935f00 ffff88009d914f40
[ 1235.585226]  ffff88009e44a0e8 0000000000000002 ffffffff81173ce0 ffff88009ecf9a30
[ 1235.585226] Call Trace:
[ 1235.585226]  [<ffffffff81173ce0>] ? wait_on_page_read+0x60/0x60
[ 1235.585226]  [<ffffffff816f1d0d>] io_schedule+0x9d/0x140
[ 1235.585226]  [<ffffffff81173cee>] sleep_on_page+0xe/0x20
[ 1235.585226]  [<ffffffff816f20c2>] __wait_on_bit+0x62/0x90
[ 1235.585226]  [<ffffffff81173a69>] wait_on_page_bit+0x89/0xb0
[ 1235.585226]  [<ffffffff810d2050>] ? autoremove_wake_function+0x40/0x40
[ 1235.585226]  [<ffffffff81173b99>] filemap_fdatawait_range+0x109/0x1c0
[ 1235.585226]  [<ffffffffa00d1f77>] btrfs_wait_marked_extents+0x97/0x100 [btrfs]
[ 1235.585226]  [<ffffffffa00d204b>] btrfs_write_and_wait_transaction+0x6b/0xb0 [btrfs]
[ 1235.585226]  [<ffffffffa00d2833>] btrfs_commit_transaction+0x683/0x9a0 [btrfs]
[ 1235.585226]  [<ffffffffa00fedf6>] btrfs_init_new_device+0xa36/0xec0 [btrfs]
[ 1235.585226]  [<ffffffff81176003>] ? filemap_fault+0xa3/0x420
[ 1235.585226]  [<ffffffff811cecbe>] ? __kmalloc_track_caller+0xae/0x240
[ 1235.585226]  [<ffffffffa01077a9>] ? btrfs_ioctl+0xac9/0x2b80 [btrfs]
[ 1235.585226]  [<ffffffffa01077cb>] btrfs_ioctl+0xaeb/0x2b80 [btrfs]
[ 1235.585226]  [<ffffffff811a2255>] ? handle_mm_fault+0x4a5/0xef0
[ 1235.585226]  [<ffffffff810bf506>] ? try_to_wake_up+0x1e6/0x290
[ 1235.585226]  [<ffffffff816f8bdc>] ? __do_page_fault+0x20c/0x550
[ 1235.585226]  [<ffffffff81224241>] ? __blkdev_put+0x141/0x1a0
[ 1235.585226]  [<ffffffff811fc790>] do_vfs_ioctl+0x2e0/0x4a0
[ 1235.585226]  [<ffffffff811fc9f1>] SyS_ioctl+0xa1/0xc0
[ 1235.585226]  [<ffffffff816fe129>] system_call_fastpath+0x16/0x1b


sysrq w (partial)

[ 1210.545670] SysRq : Show Blocked State
[ 1210.545834]   task                        PC stack   pid father
[ 1210.546010] btrfs           D ffff88009d914640     0   598    508 0x00000084
[ 1210.546119]  ffff88009ecf99b8 0000000000000086 ffff880094935f00 ffff88009ecf9fd8
[ 1210.546119]  0000000000014640 0000000000014640 ffff880094935f00 ffff88009d914f40
[ 1210.546119]  ffff88009e44a0e8 0000000000000002 ffffffff81173ce0 ffff88009ecf9a30
[ 1210.546119] Call Trace:
[ 1210.546119]  [<ffffffff81173ce0>] ? wait_on_page_read+0x60/0x60
[ 1210.546119]  [<ffffffff816f1d0d>] io_schedule+0x9d/0x140
[ 1210.546119]  [<ffffffff81173cee>] sleep_on_page+0xe/0x20
[ 1210.546119]  [<ffffffff816f20c2>] __wait_on_bit+0x62/0x90
[ 1210.546119]  [<ffffffff81173a69>] wait_on_page_bit+0x89/0xb0
[ 1210.546119]  [<ffffffff810d2050>] ? autoremove_wake_function+0x40/0x40
[ 1210.546119]  [<ffffffff81173b99>] filemap_fdatawait_range+0x109/0x1c0
[ 1210.546119]  [<ffffffffa00d1f77>] btrfs_wait_marked_extents+0x97/0x100 [btrfs]
[ 1210.546119]  [<ffffffffa00d204b>] btrfs_write_and_wait_transaction+0x6b/0xb0 [btrfs]
[ 1210.546119]  [<ffffffffa00d2833>] btrfs_commit_transaction+0x683/0x9a0 [btrfs]
[ 1210.546119]  [<ffffffffa00fedf6>] btrfs_init_new_device+0xa36/0xec0 [btrfs]
[ 1210.546119]  [<ffffffff81176003>] ? filemap_fault+0xa3/0x420
[ 1210.546119]  [<ffffffff811cecbe>] ? __kmalloc_track_caller+0xae/0x240
[ 1210.546119]  [<ffffffffa01077a9>] ? btrfs_ioctl+0xac9/0x2b80 [btrfs]
[ 1210.546119]  [<ffffffffa01077cb>] btrfs_ioctl+0xaeb/0x2b80 [btrfs]
[ 1210.546119]  [<ffffffff811a2255>] ? handle_mm_fault+0x4a5/0xef0
[ 1210.546119]  [<ffffffff810bf506>] ? try_to_wake_up+0x1e6/0x290
[ 1210.546119]  [<ffffffff816f8bdc>] ? __do_page_fault+0x20c/0x550
[ 1210.546119]  [<ffffffff81224241>] ? __blkdev_put+0x141/0x1a0
[ 1210.546119]  [<ffffffff811fc790>] do_vfs_ioctl+0x2e0/0x4a0
[ 1210.546119]  [<ffffffff811fc9f1>] SyS_ioctl+0xa1/0xc0
[ 1210.546119]  [<ffffffff816fe129>] system_call_fastpath+0x16/0x1b
[ 1210.546119] Sched Debug Version: v0.11, 3.14.0-0.rc6.git0.1.fc21.x86_64 #1


Bug report includes full dmesg.
https://bugzilla.kernel.org/show_bug.cgi?id=72221


Chris Murphy