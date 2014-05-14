Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55841 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaENUz3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 May 2014 16:55:29 -0400
Date: Wed, 14 May 2014 13:55:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Mason <clm@fb.com>, Filipe David Manana <fdmanana@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: 3.15rc5 deadlock
Message-ID: <20140514205519.GB12849@merlins.org>
References: <20140514114027.GA32301@merlins.org>
 <5373616E.9070409@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5373616E.9070409@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 14, 2014 at 08:28:30AM -0400, Chris Mason wrote:
> I think Filipe fixed this one:
> 
> https://patchwork.kernel.org/patch/4143821/

I applied this patch, and I don't have the same deadlock anymore, but 
legolas:/mnt/btrfs_pool1# btrfs-subvolume-backup --init -k 5 var /mnt/btrfs_pool2/
Create a readonly snapshot of 'var' in './var_ro.20140514_06:39:50'
At subvol var_ro.20140514_06:39:50
At subvol var_ro.20140514_06:39:50

has been hung for 8H and only copied 200MB.
I have 2 CPUs stuck at 100% and dmesg shows:
INFO: task btrfs-cleaner:3479 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-cleaner   D 0000000000000000     0  3479      2 0x00000000
 ffff8800ca2d9d00 0000000000000046 ffff880401f5b270 ffff8800ca2d9fd8
 ffff8800ca1a6110 00000000000141c0 ffff8800c32d2700 ffff8800ca2c11e8
 0000000000000000 ffff8800ca2c1000 ffff8803cc4dcf20 ffff8800ca2d9d10
Call Trace:
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8122a4cb>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8122b9e5>] start_transaction+0x498/0x4fc
 [<ffffffff8122bdcf>] ? __btrfs_end_transaction+0x2a8/0x2cd
 [<ffffffff8122ba64>] btrfs_start_transaction+0x1b/0x1d
 [<ffffffff8121c550>] btrfs_drop_snapshot+0x443/0x610
 [<ffffffff8161ef9b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
 [<ffffffff8122c20d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
 [<ffffffff812248e5>] cleaner_kthread+0x103/0x136
 [<ffffffff812247e2>] ? btrfs_alloc_root+0x26/0x26
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:3480 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 0000000000000000     0  3480      2 0x00000000
 ffff8800ccac1b00 0000000000000046 ffff8804067bd2b8 ffff8800ccac1fd8
 ffff8800ca1925d0 00000000000141c0 ffff880401bb6100 ffff8803e9700c40
 ffff880401bb6140 ffff880401f5b000 ffff8804067bd280 ffff8800ccac1b10
Call Trace:
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff81215b97>] cache_block_group+0x12d/0x343
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8121a966>] find_free_extent+0x391/0x89e
 [<ffffffff8121afce>] btrfs_reserve_extent+0x70/0x114
 [<ffffffff81231f04>] __btrfs_prealloc_file_range+0xcc/0x2d8
 [<ffffffff8120c445>] ? btrfs_free_path+0x26/0x29
 [<ffffffff81237f0b>] btrfs_prealloc_file_range_trans+0x30/0x32
 [<ffffffff8121db72>] btrfs_write_dirty_block_groups+0x24b/0x556
 [<ffffffff81617c91>] commit_cowonly_roots+0x14d/0x219
 [<ffffffff8122b0eb>] btrfs_commit_transaction+0x44e/0x8b0
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff81227791>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81227699>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u16:13:12552 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:13  D 0000000000000000     0 12552      2 0x00000080
Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
 ffff8803bd841a00 0000000000000046 ffff8803bd8419d0 ffff8803bd841fd8
 ffff8803bd90a190 00000000000141c0 ffff88041e2941c0 ffff8803bd90a190
 ffff8803bd841aa0 0000000000000002 ffffffff810fda1a ffff8803bd841a10
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81240c41>] lock_page+0x1e/0x21
 [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
 [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
 [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8162280c>] ? preempt_count_add+0x77/0x8d
 [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
 [<ffffffff811082b1>] do_writepages+0x1e/0x2c
 [<ffffffff81175ef2>] __writeback_single_inode+0x7d/0x238
 [<ffffffff81176c2a>] writeback_sb_inodes+0x1eb/0x339
 [<ffffffff81176dec>] __writeback_inodes_wb+0x74/0xb7
 [<ffffffff81176f67>] wb_writeback+0x138/0x293
 [<ffffffff81107584>] ? bdi_dirty_limit+0x31/0x91
 [<ffffffff811775dd>] bdi_writeback_workfn+0x1d8/0x329
 [<ffffffff8100d047>] ? load_TLS+0xb/0xf
 [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
 [<ffffffff8106624a>] worker_thread+0x136/0x205
 [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u16:1:13077 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:1   D 0000000000000000     0 13077      2 0x00000080
Workqueue: btrfs-delalloc normal_work_helper
 ffff8803b50fd860 0000000000000046 ffff8803b50fd830 ffff8803b50fdfd8
 ffff8803b77282d0 00000000000141c0 ffff88041e2d41c0 ffff8803b77282d0
 ffff8803b50fd900 0000000000000002 ffffffff810fda1a ffff8803b50fd870
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810fe3c9>] lock_page+0x19/0x1c
 [<ffffffff810fe425>] find_lock_entry+0x33/0x55
 [<ffffffff810fe455>] find_lock_page+0xe/0x1b
 [<ffffffff810fe93e>] find_or_create_page+0x31/0x83
 [<ffffffff8125ee32>] io_ctl_prepare_pages+0x49/0x11c
 [<ffffffff812609e2>] __load_free_space_cache+0x1be/0x56c
 [<ffffffff81260e76>] load_free_space_cache+0xe6/0x199
 [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
 [<ffffffff81215c2e>] cache_block_group+0x1c4/0x343
 [<ffffffff812611c2>] ? btrfs_find_space_for_alloc+0x1f8/0x21d
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8121a966>] find_free_extent+0x391/0x89e
 [<ffffffff8121afce>] btrfs_reserve_extent+0x70/0x114
 [<ffffffff8123087c>] cow_file_range+0x1b0/0x388
 [<ffffffff8123152b>] submit_compressed_extents+0x102/0x40f
 [<ffffffff8122fa27>] ? async_cow_free+0x24/0x27
 [<ffffffff812318be>] async_cow_submit+0x86/0x8b
 [<ffffffff81250629>] normal_work_helper+0x194/0x240
 [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
 [<ffffffff8106624a>] worker_thread+0x136/0x205
 [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs:13329 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs           D 0000000000000004     0 13329  13305 0x00000080
 ffff8803aaf75b10 0000000000000082 ffff8803aaf75ae0 ffff8803aaf75fd8
 ffff8803aa8165d0 00000000000141c0 ffff88041e3141c0 ffff8803aa8165d0
 ffff8803aaf75bb0 0000000000000002 ffffffff810fda1a ffff8803aaf75b20
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81240c41>] lock_page+0x1e/0x21
 [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
 [<ffffffff8110a5b2>] ? pagevec_lookup_entries+0x1e/0x26
 [<ffffffff8110ae23>] ? truncate_inode_pages_range+0x2a9/0x3ad
 [<ffffffff81211106>] ? setup_items_for_insert+0x2ba/0x2da
 [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
 [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
 [<ffffffff811082b1>] do_writepages+0x1e/0x2c
 [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123fcda>] btrfs_wait_ordered_range+0x85/0x11a
 [<ffffffff8123321e>] btrfs_truncate+0x45/0x22b
 [<ffffffff81233cb1>] btrfs_setattr+0x19b/0x273
 [<ffffffff8116b148>] notify_change+0x1be/0x2a6
 [<ffffffff81153d74>] do_truncate+0x69/0x90
 [<ffffffff81153e8c>] vfs_truncate+0xf1/0x11f
 [<ffffffff81153f04>] do_sys_truncate+0x4a/0x86
 [<ffffffff81154041>] SyS_truncate+0xe/0x10
 [<ffffffff81625bad>] system_call_fastpath+0x1a/0x1f
INFO: task btrfs-cleaner:3479 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-cleaner   D 0000000000000000     0  3479      2 0x00000000
 ffff8800ca2d9d00 0000000000000046 ffff880401f5b270 ffff8800ca2d9fd8
 ffff8800ca1a6110 00000000000141c0 ffff8800c32d2700 ffff8800ca2c11e8
 0000000000000000 ffff8800ca2c1000 ffff8803cc4dcf20 ffff8800ca2d9d10
Call Trace:
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8122a4cb>] wait_current_trans.isra.15+0x98/0xf4
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8122b9e5>] start_transaction+0x498/0x4fc
 [<ffffffff8122bdcf>] ? __btrfs_end_transaction+0x2a8/0x2cd
 [<ffffffff8122ba64>] btrfs_start_transaction+0x1b/0x1d
 [<ffffffff8121c550>] btrfs_drop_snapshot+0x443/0x610
 [<ffffffff8161ef9b>] ? _raw_spin_unlock+0x17/0x2a
 [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
 [<ffffffff8122c20d>] btrfs_clean_one_deleted_snapshot+0x103/0x10f
 [<ffffffff812248e5>] cleaner_kthread+0x103/0x136
 [<ffffffff812247e2>] ? btrfs_alloc_root+0x26/0x26
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs-transacti:3480 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs-transacti D 0000000000000000     0  3480      2 0x00000000
 ffff8800ccac1b00 0000000000000046 ffff8804067bd2b8 ffff8800ccac1fd8
 ffff8800ca1925d0 00000000000141c0 ffff880401bb6100 ffff8803e9700c40
 ffff880401bb6140 ffff880401f5b000 ffff8804067bd280 ffff8800ccac1b10
Call Trace:
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff81215b97>] cache_block_group+0x12d/0x343
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8121a966>] find_free_extent+0x391/0x89e
 [<ffffffff8121afce>] btrfs_reserve_extent+0x70/0x114
 [<ffffffff81231f04>] __btrfs_prealloc_file_range+0xcc/0x2d8
 [<ffffffff8120c445>] ? btrfs_free_path+0x26/0x29
 [<ffffffff81237f0b>] btrfs_prealloc_file_range_trans+0x30/0x32
 [<ffffffff8121db72>] btrfs_write_dirty_block_groups+0x24b/0x556
 [<ffffffff81617c91>] commit_cowonly_roots+0x14d/0x219
 [<ffffffff8122b0eb>] btrfs_commit_transaction+0x44e/0x8b0
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff81227791>] transaction_kthread+0xf8/0x1ab
 [<ffffffff81227699>] ? btrfs_cleanup_transaction+0x44c/0x44c
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u16:13:12552 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:13  D 0000000000000000     0 12552      2 0x00000080
Workqueue: writeback bdi_writeback_workfn (flush-btrfs-2)
 ffff8803bd841a00 0000000000000046 ffff8803bd8419d0 ffff8803bd841fd8
 ffff8803bd90a190 00000000000141c0 ffff88041e2941c0 ffff8803bd90a190
 ffff8803bd841aa0 0000000000000002 ffffffff810fda1a ffff8803bd841a10
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81240c41>] lock_page+0x1e/0x21
 [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
 [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
 [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8162280c>] ? preempt_count_add+0x77/0x8d
 [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
 [<ffffffff811082b1>] do_writepages+0x1e/0x2c
 [<ffffffff81175ef2>] __writeback_single_inode+0x7d/0x238
 [<ffffffff81176c2a>] writeback_sb_inodes+0x1eb/0x339
 [<ffffffff81176dec>] __writeback_inodes_wb+0x74/0xb7
 [<ffffffff81176f67>] wb_writeback+0x138/0x293
 [<ffffffff81107584>] ? bdi_dirty_limit+0x31/0x91
 [<ffffffff811775dd>] bdi_writeback_workfn+0x1d8/0x329
 [<ffffffff8100d047>] ? load_TLS+0xb/0xf
 [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
 [<ffffffff8106624a>] worker_thread+0x136/0x205
 [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task kworker/u16:1:13077 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/u16:1   D 0000000000000000     0 13077      2 0x00000080
Workqueue: btrfs-delalloc normal_work_helper
 ffff8803b50fd860 0000000000000046 ffff8803b50fd830 ffff8803b50fdfd8
 ffff8803b77282d0 00000000000141c0 ffff88041e2d41c0 ffff8803b77282d0
 ffff8803b50fd900 0000000000000002 ffffffff810fda1a ffff8803b50fd870
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff810fe3c9>] lock_page+0x19/0x1c
 [<ffffffff810fe425>] find_lock_entry+0x33/0x55
 [<ffffffff810fe455>] find_lock_page+0xe/0x1b
 [<ffffffff810fe93e>] find_or_create_page+0x31/0x83
 [<ffffffff8125ee32>] io_ctl_prepare_pages+0x49/0x11c
 [<ffffffff812609e2>] __load_free_space_cache+0x1be/0x56c
 [<ffffffff81260e76>] load_free_space_cache+0xe6/0x199
 [<ffffffff810764de>] ? get_parent_ip+0xd/0x3c
 [<ffffffff81215c2e>] cache_block_group+0x1c4/0x343
 [<ffffffff812611c2>] ? btrfs_find_space_for_alloc+0x1f8/0x21d
 [<ffffffff8108473d>] ? finish_wait+0x65/0x65
 [<ffffffff8121a966>] find_free_extent+0x391/0x89e
 [<ffffffff8121afce>] btrfs_reserve_extent+0x70/0x114
 [<ffffffff8123087c>] cow_file_range+0x1b0/0x388
 [<ffffffff8123152b>] submit_compressed_extents+0x102/0x40f
 [<ffffffff8122fa27>] ? async_cow_free+0x24/0x27
 [<ffffffff812318be>] async_cow_submit+0x86/0x8b
 [<ffffffff81250629>] normal_work_helper+0x194/0x240
 [<ffffffff81065d2e>] process_one_work+0x195/0x2d2
 [<ffffffff8106624a>] worker_thread+0x136/0x205
 [<ffffffff81066114>] ? rescuer_thread+0x27a/0x27a
 [<ffffffff8106b467>] kthread+0xae/0xb6
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
 [<ffffffff81625afc>] ret_from_fork+0x7c/0xb0
 [<ffffffff8106b3b9>] ? __kthread_parkme+0x61/0x61
INFO: task btrfs:13329 blocked for more than 120 seconds.
      Not tainted 3.15.0-rc5-amd64-i915-preempt-20140216s1 #2
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
btrfs           D 0000000000000004     0 13329  13305 0x00000080
 ffff8803aaf75b10 0000000000000082 ffff8803aaf75ae0 ffff8803aaf75fd8
 ffff8803aa8165d0 00000000000141c0 ffff88041e3141c0 ffff8803aa8165d0
 ffff8803aaf75bb0 0000000000000002 ffffffff810fda1a ffff8803aaf75b20
Call Trace:
 [<ffffffff810fda1a>] ? wait_on_page_read+0x3c/0x3c
 [<ffffffff8161c876>] schedule+0x73/0x75
 [<ffffffff8161ca1b>] io_schedule+0x60/0x7a
 [<ffffffff810fda28>] sleep_on_page+0xe/0x12
 [<ffffffff8161cdab>] __wait_on_bit_lock+0x46/0x8a
 [<ffffffff810fdae3>] __lock_page+0x69/0x6b
 [<ffffffff81084771>] ? autoremove_wake_function+0x34/0x34
 [<ffffffff81240c41>] lock_page+0x1e/0x21
 [<ffffffff81244779>] extent_write_cache_pages.isra.16.constprop.32+0x10e/0x2c3
 [<ffffffff8110a5b2>] ? pagevec_lookup_entries+0x1e/0x26
 [<ffffffff8110ae23>] ? truncate_inode_pages_range+0x2a9/0x3ad
 [<ffffffff81211106>] ? setup_items_for_insert+0x2ba/0x2da
 [<ffffffff81244bd4>] extent_writepages+0x4b/0x5c
 [<ffffffff8122ee1f>] ? btrfs_submit_direct+0x3f4/0x3f4
 [<ffffffff8122d3fa>] btrfs_writepages+0x28/0x2a
 [<ffffffff811082b1>] do_writepages+0x1e/0x2c
 [<ffffffff810ff179>] __filemap_fdatawrite_range+0x55/0x57
 [<ffffffff810ff1ef>] filemap_fdatawrite_range+0x13/0x15
 [<ffffffff8123fcda>] btrfs_wait_ordered_range+0x85/0x11a
 [<ffffffff8123321e>] btrfs_truncate+0x45/0x22b
 [<ffffffff81233cb1>] btrfs_setattr+0x19b/0x273
 [<ffffffff8116b148>] notify_change+0x1be/0x2a6
 [<ffffffff81153d74>] do_truncate+0x69/0x90
 [<ffffffff81153e8c>] vfs_truncate+0xf1/0x11f
 [<ffffffff81153f04>] do_sys_truncate+0x4a/0x86
 [<ffffffff81154041>] SyS_truncate+0xe/0x10
 [<ffffffff81625bad>] system_call_fastpath+0x1a/0x1f


Nothing after that.
btrfs receive /mnt/btrfs_pool2 
seems uninterruptible and suck on sleep_on_page:
legolas:/mnt/btrfs_pool1# ps -eo pid,user,args,wchan  | grep  btrfs
  526 root     [btrfs-worker]              rescuer_thread
  527 root     [btrfs-worker-hi]           rescuer_thread
  528 root     [btrfs-delalloc]            rescuer_thread
  529 root     [btrfs-flush_del]           rescuer_thread
  530 root     [btrfs-cache]               rescuer_thread
  531 root     [btrfs-submit]              rescuer_thread
  532 root     [btrfs-fixup]               rescuer_thread
  533 root     [btrfs-endio]               rescuer_thread
  534 root     [btrfs-endio-met]           rescuer_thread
  535 root     [btrfs-endio-met]           rescuer_thread
  536 root     [btrfs-endio-rai]           rescuer_thread
  537 root     [btrfs-rmw]                 rescuer_thread
  538 root     [btrfs-endio-wri]           rescuer_thread
  539 root     [btrfs-freespace]           rescuer_thread
  540 root     [btrfs-delayed-m]           rescuer_thread
  541 root     [btrfs-readahead]           rescuer_thread
  542 root     [btrfs-qgroup-re]           rescuer_thread
  543 root     [btrfs-cleaner]             cleaner_kthread
  544 root     [btrfs-transacti]           transaction_kthread
 2424 root     [btrfs-worker]              rescuer_thread
 2425 root     [btrfs-worker-hi]           rescuer_thread
 2426 root     [btrfs-delalloc]            rescuer_thread
 2427 root     [btrfs-flush_del]           rescuer_thread
 2428 root     [btrfs-cache]               rescuer_thread
 2429 root     [btrfs-submit]              rescuer_thread
 2430 root     [btrfs-fixup]               rescuer_thread
 2431 root     [btrfs-endio]               rescuer_thread
 2432 root     [btrfs-endio-met]           rescuer_thread
 2433 root     [btrfs-endio-met]           rescuer_thread
 2434 root     [btrfs-endio-rai]           rescuer_thread
 2435 root     [btrfs-rmw]                 rescuer_thread
 2436 root     [btrfs-endio-wri]           rescuer_thread
 2437 root     [btrfs-freespace]           rescuer_thread
 2438 root     [btrfs-delayed-m]           rescuer_thread
 2439 root     [btrfs-readahead]           rescuer_thread
 2440 root     [btrfs-qgroup-re]           rescuer_thread
 3479 root     [btrfs-cleaner]             wait_current_trans.isra.15
 3480 root     [btrfs-transacti]           cache_block_group
13329 root     btrfs receive /mnt/btrfs_po sleep_on_page

I now still have 2 CPUs stuck, looks like I'll need to reboot.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
