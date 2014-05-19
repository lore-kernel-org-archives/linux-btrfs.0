Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:46470 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaESNt7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 May 2014 09:49:59 -0400
Received: from [61.215.197.74] (port=42025 helo=legolas.merlins.org)
	by mail1.merlins.org with esmtpsa
	(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.80 #2)
	id 1WmNx0-0007gr-LU by authid <merlins.org> with srv_auth_plain
	for <linux-btrfs@vger.kernel.org>; Mon, 19 May 2014 06:49:59 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
	(envelope-from <merlin@legolas.merlins.org>)
	id 1WmNwK-0000zO-3x
	for linux-btrfs@vger.kernel.org; Mon, 19 May 2014 06:49:16 -0700
Date: Mon, 19 May 2014 06:49:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org
Subject: 3.15-rc5 deadlocked a 2nd time after I was copying photos from an
 sdcard + common code path that deadlocks all btrfs filesystems
Message-ID: <20140519134915.GA27432@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, that's 2 out of 2.

I was copying pictures from an sdcard (through mmcblk0), and the
filesystem deadlocked.

Unfortunately, when this happens, I copied my pictures (which were still
in RAM) to my 2nd drive which was also btrfs.
I had to reboot, and of course the last pictures didn't get committed to
disk, but more annoyingly the copy I did to the second drive didn't work
either.
All the filenames got copied to the 2nd drive, some ended up with data,
and others ended up empty.
Why does a deadlock on drive 1 also cause btrfs to fail to write to
drive #2?
This is not the first time, there seem to be common codepaths across all
drives (just like disk array #1 having problems causing failure of
syslog to work on the boot drive with btrfs).

I tried to capture sysrq+w, but it didn't make it to disk because of that bug.
I do have remote syslog of the hangs before that though, but the capture of sysrq+w
has too much missing data to be useful
http://marc.merlins.org/tmp/btrfs-hang.txt

Mmmh, maybe the deadlock is more complicated. I had a 2nd syslog stream
going to an ext4 filesystem, exactly to get around that btrfs master
deadlock, and now I see that didn't work either.

If sync hangs, and logging to an ext4 filesystem didn't work, am I
hitting another bug/hardware problem?

Here's what I got at the end?


[194790.138156] FAT-fs (mmcblk0p1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[194790.140892] FAT-fs (mmcblk0p1): Volume was not properly unmounted. Some data may be corrupt. Please run fsck.
[194932.445153] INFO: task IndexedDB:29612 blocked for more than 120 seconds.
[194932.445161]       Tainted: G        W     3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
[194932.445163] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[194932.445166] IndexedDB       D ffff8800ccde8bc0     0 29612   5570 0x00000080
[194932.445172]  ffff8801b521fc30 0000000000000086 ffff8801b521fc00 ffff8801b521ffd8
[194932.445178]  ffff8801d622a450 00000000000141c0 ffff88041e3941c0 ffff8801d622a450
[194932.445182]  ffff8801b521fcd0 0000000000000002 ffffffff810fda1a ffff8801b521fc40
[194932.445188] Call Trace:
[194932.445198]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[194932.445209]  [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
[194932.445214]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[194932.445219]  [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
[194932.445223]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[194932.445228]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[194932.445232]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[194932.445237]  [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
[194932.445243]  [<ffffffff8161d2d4>] ? mutex_unlock+0x16/0x18
[194932.445248]  [<ffffffff81239c74>] ? btrfs_file_aio_write+0x3e9/0x4b6
[194932.445251]  [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
[194932.445255]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[194932.445262]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[194932.445267]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[194932.445272]  [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
[194932.445277]  [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
[194932.445280]  [<ffffffff8123885a>] btrfs_sync_file+0xa8/0x2b3
[194932.445286]  [<ffffffff8132048f>] ? __percpu_counter_add+0x8c/0xa6
[194932.445292]  [<ffffffff8117a1a7>] vfs_fsync_range+0x18/0x22
[194932.445296]  [<ffffffff8117a1cd>] vfs_fsync+0x1c/0x1e
[194932.445299]  [<ffffffff8117a3d9>] do_fsync+0x2c/0x4c
[194932.445303]  [<ffffffff8117a5f9>] SyS_fdatasync+0x13/0x17
[194932.445308]  [<ffffffff81625bad>] system_call_fastpath+0x1a/0x1f
[194932.445395] INFO: task kworker/u16:35:3812 blocked for more than 120 seconds.
[194932.445398]       Tainted: G        W     3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
[194932.445400] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[194932.445403] kworker/u16:35  D 0000000000000000     0  3812      2 0x00000080
[194932.445410] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[194932.445414]  ffff88003b647a00 0000000000000046 ffff88003b6479d0 ffff88003b647fd8
[194932.445419]  ffff88003b8ca590 00000000000141c0 ffff88041e3941c0 ffff88003b8ca590
[194932.445423]  ffff88003b647aa0 0000000000000002 ffffffff810fda1a ffff88003b647a10
[194932.445427] Call Trace:
[194932.445432]  [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
[194932.445437]  [<ffffffff8161c876>] schedule+0x73/0x75
[194932.445441]  [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
[194932.445445]  [<ffffffff810fda28>] sleep_on_page+0xe/0x12
[194932.445450]  [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
[194932.445454]  [<ffffffff810fdae3>] __lock_page+0x69/0x6b
[194932.445458]  [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
[194932.445461]  [<ffffffff81240c41>] lock_page+0x1e/0x21
[194932.445465]  [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
[194932.445470]  [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
[194932.445473]  [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
[194932.445479]  [<ffffffff8162280c>] ? preempt_count_add+0x77/0x8d
[194932.445483]  [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
[194932.445488]  [<ffffffff811082b1>] do_writepages+0x1e/0x2c
[194932.445492]  [<ffffffff81175ef2>] __writeback_single_inode+0x7d/0x238
[194932.445495]  [<ffffffff81176c2a>] writeback_sb_inodes+0x1eb/0x339
[194932.445499]  [<ffffffff81176dec>] __writeback_inodes_wb+0x74/0xb7
[194932.445503]  [<ffffffff81176f67>] wb_writeback+0x138/0x293
[194932.445507]  [<ffffffff8117759f>] bdi_writeback_workfn+0x19a/0x329
[194932.445513]  [<ffffffff8100d047>] ? load_TLS+0xb/0xf
[194932.445519]  [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
[194932.445523]  [<ffffffff8106624a>] worker_thread+0x136/0x205
[194932.445526]  [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
[194932.445530]  [<ffffffff8106b467>] kthread+0xae/0xb6
[194932.445534]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
[194932.445537]  [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
[194932.445540]  [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
