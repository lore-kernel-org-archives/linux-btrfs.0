Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:60039 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbaF1AAa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 20:00:30 -0400
Date: Fri, 27 Jun 2014 16:59:33 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140627235933.GG28692@merlins.org>
References: <20140627185009.GA21428@merlins.org>
 <53ADF1D8.9060309@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53ADF1D8.9060309@fb.com>
Subject: Re: Also seeing full deadlocks with 3.15.1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 27, 2014 at 03:36:08PM -0700, Josef Bacik wrote:
> On 06/27/2014 11:50 AM, Marc MERLIN wrote:
> >My laptop deadlocked some more times (everything works until it needs to
> >touch the filesystem, and then it's deadlocked).
> >Unfortunately, I can trigger sysrq, but it doesn't get committed to disk and
> >netconsole eats half of it because it goes too fast for UDP apparently
> >
> >Now, I just captured that on my server with serial console.
> >
> >11005  1-16:11:10 wait_current_trans.isra.15     /usr/bin/zma -m 3
> >14441  1-16:07:44 wait_current_trans.isra.15     /usr/bin/zma -m 1
> >17045  1-23:53:33 wait_current_trans.isra.15     /usr/bin/zma -m 9
> >22261  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 6
> >22292  2-00:40:36 wait_current_trans.isra.15     /usr/bin/zma -m 8
> >
> >19911    09:29:35 wait_current_trans.isra.15     rm -f -- /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13 /mnt/dshelf2/backup/0Notmachines/mysql//mysql.daily.sql.gz.13.gz
> >22848  1-05:18:35 wait_current_trans.isra.15     rm -f -- mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11 mnt/dshelf2/backup/0Notmachines/jen//backup.tar.bz.11.gz
> >
> >Those are 2 different filesystems (one single device mapper disk, the other one is btrfs raid1), so I'm not sure which one of the 2 caused the problem, but I'm perplexed as to why one would than hang the other, unless they both hit the same bug?
> >
> >The sysrq-w output is here:
> >https://urldefense.proofpoint.com/v1/url?u=http://marc.merlins.org/tmp/btrfs-hang.txt&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=CZ0ka0XcM6ZpRAF31LYBziutfoecu9ODO78jo5Kb2JQ%3D%0A&s=6213c6dc2c99166a71f262a1804bc7135ca17bffd8b9de175f655ed2a6a54f10
> >
> >but here is one hung process:
> >  zma		D 0000000000000003     0 22292	    1 0x20020084
> >   ffff880074733bb0 0000000000000082 ffff8800c933f270 ffff880074733fd8
> >   ffff8801853b4610 00000000000141c0 ffff8801aac60f00 ffff880036caa9e8
> >   0000000000000000 ffff880036caa800 ffff8801db59f0c0 ffff880074733bc0
> >  Call Trace:
> >   [<ffffffff8161d3c6>] schedule+0x73/0x75
> >   [<ffffffff8122a87b>] wait_current_trans.isra.15+0x98/0xf4
> >   [<ffffffff810847ed>] ? finish_wait+0x65/0x65
> >   [<ffffffff8122bd95>] start_transaction+0x498/0x4fc
> >   [<ffffffff8122be14>] btrfs_start_transaction+0x1b/0x1d
> >   [<ffffffff8123602a>] btrfs_create+0x3c/0x1ce
> >   [<ffffffff81298985>] ? security_inode_permission+0x1c/0x23
> >   [<ffffffff8115e93e>] ? __inode_permission+0x79/0xa4
> >   [<ffffffff8115fbfc>] vfs_create+0x66/0x8c
> >   [<ffffffff8116095e>] do_last+0x5af/0xa23
> >   [<ffffffff81161009>] path_openat+0x237/0x4de
> >   [<ffffffff81162408>] do_filp_open+0x3a/0x7f
> >   [<ffffffff8161faeb>] ? _raw_spin_unlock+0x17/0x2a
> >   [<ffffffff8116c3eb>] ? __alloc_fd+0xea/0xf9
> >   [<ffffffff8115499d>] do_sys_open+0x70/0xff
> >   [<ffffffff81194e20>] compat_SyS_open+0x1b/0x1d
> >   [<ffffffff8162842c>] sysenter_dispatch+0x7/0x21
> >
> >As per the other thread, I'm happy to test a patch against 3.15, but not hot about switching to a likely even less stable 3.16 since it's a real server with real data.
> >
> 
> A few other people have complained about this, I've not been able to reproduce
> it but I have a patch you can try.  It will make it so the box doesn't deadlock
> anymore but I still need the output, look for "timed out", thats when you need
> to dump the logs and send it to me.  The patch is here

Mmmh, I applied the patch, but now I'm getting tens of thousands of the lines below.
The machine is so unresponsive (due to serial port speed limitation and
amount of console spamming) that I cannot even ssh into it.
Example output below. I have to back that kernel out, it's unusable and
I'm not sure what output I can get you out of it.

[ 1313.747004] looking up page 46 on inode ffff8801ac3e9d68
[ 1313.747006] created a page, should be locked ? ffffea0000c6d480
[ 1313.747006] looking up page 47 on inode ffff8801ac3e9d68
[ 1313.747008] created a page, should be locked ? ffffea0000c6d4b8
[ 1313.747009] looking up page 48 on inode ffff8801ac3e9d68
[ 1313.747011] created a page, should be locked ? ffffea0000c75ad0
[ 1313.747012] looking up page 49 on inode ffff8801ac3e9d68
[ 1313.747013] created a page, should be locked ? ffffea0000c75b08
[ 1313.747014] looking up page 50 on inode ffff8801ac3e9d68
[ 1313.747016] created a page, should be locked ? ffffea0000c5d420
[ 1313.747017] looking up page 51 on inode ffff8801ac3e9d68
[ 1313.747018] created a page, should be locked ? ffffea0000c5d458
[ 1313.747019] looking up page 52 on inode ffff8801ac3e9d68
[ 1313.747021] created a page, should be locked ? ffffea0000ce4f00
[ 1313.747022] looking up page 53 on inode ffff8801ac3e9d68
[ 1313.747023] created a page, should be locked ? ffffea0000ce4f38
[ 1313.747024] looking up page 54 on inode ffff8801ac3e9d68
[ 1313.747026] created a page, should be locked ? ffffea0000c989f0
[ 1313.747027] looking up page 55 on inode ffff8801ac3e9d68
[ 1313.747029] created a page, should be locked ? ffffea0000c98a28
[ 1375.660075] dropping page 124 on inode ffff880060bfad68
[ 1375.660076] dropping page 125 on inode ffff880060bfad68
[ 1375.660077] dropping page 126 on inode ffff880060bfad68
[ 1375.660078] dropping page 127 on inode ffff880060bfad68
[ 1375.668774] write out for cache 447779700736 returned 0
[ 1375.669261] writing out space cache for 61232644096
[ 1375.669264] looking up page 0 on inode ffff8800b629f1b0
[ 1375.669266] looking up page 1 on inode ffff8800b629f1b0
[ 1375.669267] looking up page 2 on inode ffff8800b629f1b0
[ 1375.669268] looking up page 3 on inode ffff8800b629f1b0


By the way, before reboot, it did output the following even with -ro,
recovery the FS deadlocked when I was copying data off it:

 INFO: task kworker/u8:3:71 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kworker/u8:3    D 0000000000000000     0    71      2 0x00000000
 Workqueue: btrfs-delalloc normal_work_helper[ 7208.690917]  ffff8800c8637860 0000000000000046 ffff8800c8637830 ffff8800c8637fd8
  ffff8800c862e210 00000000000141c0 ffff88021f2141c0 ffff8800c862e210
  ffff8800c8637900 0000000000000002 ffffffff810fdc2f ffff8800c8637870
 Call Trace:
  [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8161d56b>] io_schedule+0x60/0x7a
  [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
  [<ffffffff8161d8fb>] __wait_on_bit_lock+0x46/0x8a
  [<ffffffff810fdcf8>] __lock_page+0x69/0x6b
  [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
  [<ffffffff810fe5de>] lock_page+0x19/0x1c
  [<ffffffff810fe63a>] find_lock_entry+0x33/0x55
  [<ffffffff810fe66a>] find_lock_page+0xe/0x1b
  [<ffffffff810feb53>] find_or_create_page+0x31/0x83
  [<ffffffff8125f18b>] io_ctl_prepare_pages+0x49/0x11c
  [<ffffffff81260d3b>] __load_free_space_cache+0x1be/0x56c
  [<ffffffff812611cf>] load_free_space_cache+0xe6/0x199
  [<ffffffff8107653d>] ? get_parent_ip+0xd/0x3c
  [<ffffffff81215fde>] cache_block_group+0x1c4/0x343
  [<ffffffff8126151b>] ? btrfs_find_space_for_alloc+0x1f8/0x21d
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff81230c2c>] cow_file_range+0x1b0/0x388
  [<ffffffff812318db>] submit_compressed_extents+0x102/0x40f
  [<ffffffff8122fdd7>] ? async_cow_free+0x24/0x27
  [<ffffffff81231c6e>] async_cow_submit+0x86/0x8b
  [<ffffffff81250971>] normal_work_helper+0x194/0x240
  [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
  [<ffffffff81066020>] worker_thread+0x136/0x205
  [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task btrfs-transacti:3186 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 btrfs-transacti D 0000000000000002     0  3186      2 0x00000000
  ffff88020d46bb00 0000000000000046 ffff880195f645b8 ffff88020d46bfd8
  ffff880213818150 00000000000141c0 ffff88020da24400 ffff8800c9fc2400
  ffff88020da24440 ffff8800c9fc3000 ffff880195f64580 ffff88020d46bb10
 Call Trace:
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff81215f47>] cache_block_group+0x12d/0x343
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff812322b4>] __btrfs_prealloc_file_range+0xcc/0x2d8
  [<ffffffff8120c7f5>] ? btrfs_free_path+0x26/0x29
  [<ffffffff812382bb>] btrfs_prealloc_file_range_trans+0x30/0x32
  [<ffffffff8121df22>] btrfs_write_dirty_block_groups+0x24b/0x556
  [<ffffffff816187e5>] commit_cowonly_roots+0x14d/0x219
  [<ffffffff8122b49b>] btrfs_commit_transaction+0x44e/0x8b0
  [<ffffffff81227b41>] transaction_kthread+0xf8/0x1ab
  [<ffffffff81227a49>] ? btrfs_cleanup_transaction+0x44c/0x44c
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task cp:477 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 cp              D 0000000000000002     0   477  32108 0x20020080
  ffff8801fed03ce8 0000000000000082 ffff8800c9fc3270 ffff8801fed03fd8
  ffff8801afef6190 00000000000141c0 ffff8801f292ad00 ffff8800372881e8
  0000000000000000 ffff880037288000 ffff88009f11e660 ffff8801fed03cf8
 Call Trace:
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8122a87b>] wait_current_trans.isra.15+0x98/0xf4
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8122bb09>] start_transaction+0x20c/0x4fc
  [<ffffffff8122be4a>] btrfs_join_transaction+0x17/0x19
  [<ffffffff812304ca>] btrfs_dirty_inode+0x2c/0xa9
  [<ffffffff81234107>] btrfs_setattr+0x241/0x273
  [<ffffffff8116b4e3>] notify_change+0x1be/0x2a6
  [<ffffffff8117aad7>] utimes_common+0x119/0x176
  [<ffffffff8117abe4>] do_utimes+0xb0/0x128
  [<ffffffff81194627>] compat_SyS_utimensat+0x7e/0x8f
  [<ffffffff810a0dc6>] ? current_kernel_time+0xe/0x32
  [<ffffffff8162842c>] sysenter_dispatch+0x7/0x21
 INFO: task kworker/u8:6:16856 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kworker/u8:6    D 0000000000000000     0 16856      2 0x00000080
 Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
  ffff88006b95ba00 0000000000000046 ffff88006b95b9d0 ffff88006b95bfd8
  ffff88009de1c6d0 00000000000141c0 ffff88021f3941c0 ffff88009de1c6d0
  ffff88006b95baa0 0000000000000002 ffffffff810fdc2f ffff88006b95ba10
 Call Trace:
  [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8161d56b>] io_schedule+0x60/0x7a
  [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
  [<ffffffff8161d8fb>] __wait_on_bit_lock+0x46/0x8a
  [<ffffffff810fdcf8>] __lock_page+0x69/0x6b
  [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
  [<ffffffff81240ff1>] lock_page+0x1e/0x21
  [<ffffffff81244abe>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
  [<ffffffff81244f1c>] extent_writepages+0x4b/0x5c
  [<ffffffff8122f1cf>] ? btrfs_submit_direct+0x3f4/0x3f4
  [<ffffffff8162338c>] ? preempt_count_add+0x77/0x8d
  [<ffffffff8122d7aa>] btrfs_writepages+0x28/0x2a
  [<ffffffff811084c6>] do_writepages+0x1e/0x2c
  [<ffffffff8117628d>] __writeback_single_inode+0x7d/0x238
  [<ffffffff81176fc5>] writeback_sb_inodes+0x1eb/0x339
  [<ffffffff81177187>] __writeback_inodes_wb+0x74/0xb7
  [<ffffffff81177302>] wb_writeback+0x138/0x293
  [<ffffffff8117793a>] bdi_writeback_workfn+0x19a/0x329
  [<ffffffff8100d047>] ? load_TLS+0xb/0xf
  [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
  [<ffffffff81066020>] worker_thread+0x136/0x205
  [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61

 INFO: task kworker/u8:3:71 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kworker/u8:3    D 0000000000000000     0    71      2 0x00000000
 Workqueue: btrfs-delalloc normal_work_helper
  ffff8800c8637860 0000000000000046 ffff8800c8637830 ffff8800c8637fd8
  ffff8800c862e210 00000000000141c0 ffff88021f2141c0 ffff8800c862e210
  ffff8800c8637900 0000000000000002 ffffffff810fdc2f ffff8800c8637870
 Call Trace:
  [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8161d56b>] io_schedule+0x60/0x7a
  [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
  [<ffffffff8161d8fb>] __wait_on_bit_lock+0x46/0x8a
  [<ffffffff810fdcf8>] __lock_page+0x69/0x6b
  [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
  [<ffffffff810fe5de>] lock_page+0x19/0x1c
  [<ffffffff810fe63a>] find_lock_entry+0x33/0x55
  [<ffffffff810fe66a>] find_lock_page+0xe/0x1b
  [<ffffffff810feb53>] find_or_create_page+0x31/0x83
  [<ffffffff8125f18b>] io_ctl_prepare_pages+0x49/0x11c
  [<ffffffff81260d3b>] __load_free_space_cache+0x1be/0x56c
  [<ffffffff812611cf>] load_free_space_cache+0xe6/0x199
  [<ffffffff8107653d>] ? get_parent_ip+0xd/0x3c
  [<ffffffff81215fde>] cache_block_group+0x1c4/0x343
  [<ffffffff8126151b>] ? btrfs_find_space_for_alloc+0x1f8/0x21d
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff81230c2c>] cow_file_range+0x1b0/0x388
  [<ffffffff812318db>] submit_compressed_extents+0x102/0x40f
  [<ffffffff8122fdd7>] ? async_cow_free+0x24/0x27
  [<ffffffff81231c6e>] async_cow_submit+0x86/0x8b
  [<ffffffff81250971>] normal_work_helper+0x194/0x240
  [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
  [<ffffffff81066020>] worker_thread+0x136/0x205
  [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task btrfs-transacti:3186 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 btrfs-transacti D 0000000000000002     0  3186      2 0x00000000
  ffff88020d46bb00 0000000000000046 ffff880195f645b8 ffff88020d46bfd8
  ffff880213818150 00000000000141c0 ffff88020da24400 ffff8800c9fc2400
  ffff88020da24440 ffff8800c9fc3000 ffff880195f64580 ffff88020d46bb10
 Call Trace:
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff81215f47>] cache_block_group+0x12d/0x343
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff812322b4>] __btrfs_prealloc_file_range+0xcc/0x2d8
  [<ffffffff8120c7f5>] ? btrfs_free_path+0x26/0x29
  [<ffffffff812382bb>] btrfs_prealloc_file_range_trans+0x30/0x32
  [<ffffffff8121df22>] btrfs_write_dirty_block_groups+0x24b/0x556
  [<ffffffff816187e5>] commit_cowonly_roots+0x14d/0x219
  [<ffffffff8122b49b>] btrfs_commit_transaction+0x44e/0x8b0
  [<ffffffff81227b41>] transaction_kthread+0xf8/0x1ab
  [<ffffffff81227a49>] ? btrfs_cleanup_transaction+0x44c/0x44c
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task cp:477 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 cp              D 0000000000000002     0   477  32108 0x20020080
  ffff8801fed03ce8 0000000000000082 ffff8800c9fc3270 ffff8801fed03fd8
  ffff8801afef6190 00000000000141c0 ffff8801f292ad00 ffff8800372881e8
  0000000000000000 ffff880037288000 ffff88009f11e660 ffff8801fed03cf8
 Call Trace:
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8122a87b>] wait_current_trans.isra.15+0x98/0xf4
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8122bb09>] start_transaction+0x20c/0x4fc
  [<ffffffff8122be4a>] btrfs_join_transaction+0x17/0x19
  [<ffffffff812304ca>] btrfs_dirty_inode+0x2c/0xa9
  [<ffffffff81234107>] btrfs_setattr+0x241/0x273
  [<ffffffff8116b4e3>] notify_change+0x1be/0x2a6
  [<ffffffff8117aad7>] utimes_common+0x119/0x176
  [<ffffffff8117abe4>] do_utimes+0xb0/0x128
  [<ffffffff81194627>] compat_SyS_utimensat+0x7e/0x8f
  [<ffffffff810a0dc6>] ? current_kernel_time+0xe/0x32
  [<ffffffff8162842c>] sysenter_dispatch+0x7/0x21
 INFO: task kworker/u8:6:16856 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kworker/u8:6    D 0000000000000000     0 16856      2 0x00000080
 Workqueue: writeback bdi_writeback_workfn (flush-btrfs-3)
  ffff88006b95ba00 0000000000000046 ffff88006b95b9d0 ffff88006b95bfd8
  ffff88009de1c6d0 00000000000141c0 ffff88021f3941c0 ffff88009de1c6d0
  ffff88006b95baa0 0000000000000002 ffffffff810fdc2f ffff88006b95ba10
 Call Trace:
  [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8161d56b>] io_schedule+0x60/0x7a
  [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
  [<ffffffff8161d8fb>] __wait_on_bit_lock+0x46/0x8a
  [<ffffffff810fdcf8>] __lock_page+0x69/0x6b
  [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
  [<ffffffff81240ff1>] lock_page+0x1e/0x21
  [<ffffffff81244abe>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c6
  [<ffffffff81244f1c>] extent_writepages+0x4b/0x5c
  [<ffffffff8122f1cf>] ? btrfs_submit_direct+0x3f4/0x3f4
  [<ffffffff8162338c>] ? preempt_count_add+0x77/0x8d
  [<ffffffff8122d7aa>] btrfs_writepages+0x28/0x2a
  [<ffffffff811084c6>] do_writepages+0x1e/0x2c
  [<ffffffff8117628d>] __writeback_single_inode+0x7d/0x238
  [<ffffffff81176fc5>] writeback_sb_inodes+0x1eb/0x339
  [<ffffffff81177187>] __writeback_inodes_wb+0x74/0xb7
  [<ffffffff81177302>] wb_writeback+0x138/0x293
  [<ffffffff8117793a>] bdi_writeback_workfn+0x19a/0x329
  [<ffffffff8100d047>] ? load_TLS+0xb/0xf
  [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
  [<ffffffff81066020>] worker_thread+0x136/0x205
  [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task kworker/u8:3:71 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 kworker/u8:3    D 0000000000000000     0    71      2 0x00000000
 Workqueue: btrfs-delalloc normal_work_helper[ 7449.289862]  ffff8800c8637860 0000000000000046 ffff8800c8637830 ffff8800c8637fd8
  ffff8800c862e210 00000000000141c0 ffff88021f2141c0 ffff8800c862e210
  ffff8800c8637900 0000000000000002 ffffffff810fdc2f ffff8800c8637870
 Call Trace:
  [<ffffffff810fdc2f>] ? wait_on_page_read+0x3c/0x3c
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff8161d56b>] io_schedule+0x60/0x7a
  [<ffffffff810fdc3d>] sleep_on_page+0xe/0x12
  [<ffffffff8161d8fb>] __wait_on_bit_lock+0x46/0x8a
  [<ffffffff810fdcf8>] __lock_page+0x69/0x6b
  [<ffffffff81084821>] ? autoremove_wake_function+0x34/0x34
  [<ffffffff810fe5de>] lock_page+0x19/0x1c
  [<ffffffff810fe63a>] find_lock_entry+0x33/0x55
  [<ffffffff810fe66a>] find_lock_page+0xe/0x1b
  [<ffffffff810feb53>] find_or_create_page+0x31/0x83
  [<ffffffff8125f18b>] io_ctl_prepare_pages+0x49/0x11c
  [<ffffffff81260d3b>] __load_free_space_cache+0x1be/0x56c
  [<ffffffff812611cf>] load_free_space_cache+0xe6/0x199
  [<ffffffff8107653d>] ? get_parent_ip+0xd/0x3c
  [<ffffffff81215fde>] cache_block_group+0x1c4/0x343
  [<ffffffff8126151b>] ? btrfs_find_space_for_alloc+0x1f8/0x21d
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff81230c2c>] cow_file_range+0x1b0/0x388
  [<ffffffff812318db>] submit_compressed_extents+0x102/0x40f
  [<ffffffff8122fdd7>] ? async_cow_free+0x24/0x27
  [<ffffffff81231c6e>] async_cow_submit+0x86/0x8b
  [<ffffffff81250971>] normal_work_helper+0x194/0x240
  [<ffffffff81065d7e>] process_one_work+0x195/0x2d2
  [<ffffffff81066020>] worker_thread+0x136/0x205
  [<ffffffff81065eea>] ? process_scheduled_works+0x2f/0x2f
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
 INFO: task btrfs-transacti:3186 blocked for more than 120 seconds.
       Not tainted 3.15.1-amd64-i915-preempt-20140216jbp #1
 "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 btrfs-transacti D 0000000000000002     0  3186      2 0x00000000
  ffff88020d46bb00 0000000000000046 ffff880195f645b8 ffff88020d46bfd8
  ffff880213818150 00000000000141c0 ffff88020da24400 ffff8800c9fc2400
  ffff88020da24440 ffff8800c9fc3000 ffff880195f64580 ffff88020d46bb10
 Call Trace:
  [<ffffffff8161d3c6>] schedule+0x73/0x75
  [<ffffffff81215f47>] cache_block_group+0x12d/0x343
  [<ffffffff810847ed>] ? finish_wait+0x65/0x65
  [<ffffffff8121ad16>] find_free_extent+0x391/0x89e
  [<ffffffff8121b37e>] btrfs_reserve_extent+0x70/0x114
  [<ffffffff812322b4>] __btrfs_prealloc_file_range+0xcc/0x2d8
  [<ffffffff8120c7f5>] ? btrfs_free_path+0x26/0x29
  [<ffffffff812382bb>] btrfs_prealloc_file_range_trans+0x30/0x32
  [<ffffffff8121df22>] btrfs_write_dirty_block_groups+0x24b/0x556
  [<ffffffff816187e5>] commit_cowonly_roots+0x14d/0x219
  [<ffffffff8122b49b>] btrfs_commit_transaction+0x44e/0x8b0
  [<ffffffff81227b41>] transaction_kthread+0xf8/0x1ab
  [<ffffffff81227a49>] ? btrfs_cleanup_transaction+0x44c/0x44c
  [<ffffffff8106b4b4>] kthread+0xae/0xb6
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61
  [<ffffffff8162667c>] ret_from_fork+0x7c/0xb0
  [<ffffffff8106b406>] ? __kthread_parkme+0x61/0x61

 
 
> http://ur1.ca/hlj6d
> 
> Thanks,
> 
> Josef
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
