Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:59730 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759310Ab2FBCQw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Jun 2012 22:16:52 -0400
Date: Sat, 2 Jun 2012 04:10:09 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: at fs/btrfs/extent_map.c:226 unpin_extent_cache+0x4b/0xa0()
Message-ID: <20120602021009.GA332@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm running the latest git kernel with the btrfs updates already merged.
Today I've hit the following warnings during rsnapshot backup:

Jun  1 22:26:30 x4 kernel: Adding 1953788k swap on /dev/sda2.  Priority:-1 extents:1 across:1953788k 
Jun  2 01:52:30 x4 kernel: ------------[ cut here ]------------
Jun  2 01:52:30 x4 kernel: WARNING: at fs/btrfs/extent_map.c:226 unpin_extent_cache+0x4b/0xa0()
Jun  2 01:52:30 x4 kernel: Hardware name: System Product Name
Jun  2 01:52:30 x4 kernel: Pid: 24991, comm: btrfs-endio-wri Not tainted 3.4.0-09820-g86c47b7-dirty #50
Jun  2 01:52:30 x4 kernel: Call Trace:
Jun  2 01:52:30 x4 kernel: [<ffffffff8105c6c0>] ? warn_slowpath_common+0x60/0xa0
Jun  2 01:52:30 x4 kernel: [<ffffffff8121d6eb>] ? unpin_extent_cache+0x4b/0xa0
Jun  2 01:52:30 x4 kernel: [<ffffffff8121207e>] ? btrfs_finish_ordered_io+0x27e/0x400
Jun  2 01:52:30 x4 kernel: [<ffffffff8123bb02>] ? worker_loop+0x142/0x4c0
Jun  2 01:52:30 x4 kernel: [<ffffffff8123b9c0>] ? btrfs_queue_worker+0x300/0x300
Jun  2 01:52:30 x4 kernel: [<ffffffff81077ae5>] ? kthread+0x85/0xa0
Jun  2 01:52:30 x4 kernel: [<ffffffff81561c54>] ? kernel_thread_helper+0x4/0x10
Jun  2 01:52:30 x4 kernel: [<ffffffff81077a60>] ? kthread_flush_work_fn+0x20/0x20
Jun  2 01:52:30 x4 kernel: [<ffffffff81561c50>] ? gs_change+0xb/0xb
Jun  2 01:52:30 x4 kernel: ---[ end trace 73bddc9623dbf3c3 ]---
...
Jun  2 01:55:27 x4 kernel: ------------[ cut here ]------------
Jun  2 01:55:27 x4 kernel: WARNING: at fs/btrfs/extent_map.c:226 unpin_extent_cache+0x4b/0xa0()
Jun  2 01:55:27 x4 kernel: Hardware name: System Product Name
Jun  2 01:55:27 x4 kernel: Pid: 24997, comm: btrfs-endio-wri Tainted: G        W    3.4.0-09820-g86c47b7-dirty #50
Jun  2 01:55:27 x4 kernel: Call Trace:
Jun  2 01:55:27 x4 kernel: [<ffffffff8105c6c0>] ? warn_slowpath_common+0x60/0xa0
Jun  2 01:55:27 x4 kernel: [<ffffffff8121d6eb>] ? unpin_extent_cache+0x4b/0xa0
Jun  2 01:55:27 x4 kernel: [<ffffffff8121207e>] ? btrfs_finish_ordered_io+0x27e/0x400
Jun  2 01:55:27 x4 kernel: [<ffffffff8123bb02>] ? worker_loop+0x142/0x4c0
Jun  2 01:55:27 x4 kernel: [<ffffffff8123b9c0>] ? btrfs_queue_worker+0x300/0x300
Jun  2 01:55:27 x4 kernel: [<ffffffff81077ae5>] ? kthread+0x85/0xa0
Jun  2 01:55:27 x4 kernel: [<ffffffff81561c54>] ? kernel_thread_helper+0x4/0x10
Jun  2 01:55:27 x4 kernel: [<ffffffff81077a60>] ? kthread_flush_work_fn+0x20/0x20
Jun  2 01:55:27 x4 kernel: [<ffffffff81561c50>] ? gs_change+0xb/0xb
Jun  2 01:55:27 x4 kernel: ---[ end trace 73bddc9623dbf3eb ]---

 ~ # < /var/log/kern.log | grep extent_map | wc -l
41

>From /var/log/cron.log

Jun  2 01:52:00 x4 fcron[24821]: Job /usr/bin/rsnapshot daily started for user root (pid 24822)
Jun  2 01:55:29 x4 fcron[24821]: Job /usr/bin/rsnapshot daily completed (mailing output)

 ~ # btrfs fi df /var
Data, RAID1: total=758.00GB, used=538.32GB
Data: total=8.00MB, used=0.00
System, RAID1: total=8.00MB, used=116.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=37.50GB, used=1.88GB
Metadata: total=8.00MB, used=0.00

~ # btrfs subvol list /var
ID 773 top level 5 path .snapshots/daily.0
ID 800 top level 5 path .snapshots/monthly.0
ID 811 top level 5 path .snapshots/weekly.3
ID 813 top level 5 path .snapshots/weekly.2
ID 839 top level 5 path .snapshots/weekly.1
ID 870 top level 5 path .snapshots/weekly.0
ID 871 top level 5 path .snapshots/daily.6
ID 872 top level 5 path .snapshots/daily.5
ID 873 top level 5 path .snapshots/daily.4
ID 874 top level 5 path .snapshots/daily.3
ID 875 top level 5 path .snapshots/daily.2
ID 876 top level 5 path .snapshots/daily.1

Rsnapshot creates a new snapshot with:
 btrfs subvolume snapshot -r
and then uses rsync to backup my root drive (on xfs).

-- 
Markus
