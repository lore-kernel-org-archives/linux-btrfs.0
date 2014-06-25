Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51161 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbaFYJ51 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Jun 2014 05:57:27 -0400
Received: from fb07-iapwap2.localnet ([134.176.19.122]) by mail.gmx.com
 (mrgmx003) with ESMTPSA (Nemesis) id 0LgZRV-1WNOPQ1bwT-00nyLA for
 <linux-btrfs@vger.kernel.org>; Wed, 25 Jun 2014 11:57:25 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs hang in 3.16rc2
Date: Wed, 25 Jun 2014 11:57:24 +0200
Message-ID: <1942450.8TyUqUU8d3@fb07-iapwap2>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I got these during heavy IO (fs indexing):

[175200.080150] INFO: task akonadi_baloo_i:6489 blocked for more than 480 seconds.
[175200.080160]       Not tainted 3.16.0-rc2-12.gfc9498b-desktop+ #2
[175200.080164] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[175200.080169] akonadi_baloo_i D ffff88011fc13a00     0  6489   6330 0x00000000
[175200.080178]  ffff8800db70bc78 0000000000000086 ffff8800b3fd4390 0000000000013a00
[175200.080186]  ffff8800db70bfd8 0000000000013a00 ffff8800b3fd4390 ffff88011fc14310
[175200.080192]  ffff88011ffcb408 ffff8800db70bd00 0000000000000002 ffffffff81140710
[175200.080198] Call Trace:
[175200.080212]  [<ffffffff81140710>] ? wait_on_page_read+0x60/0x60
[175200.080223]  [<ffffffff816101fa>] io_schedule+0xaa/0x140
[175200.080230]  [<ffffffff81140719>] sleep_on_page+0x9/0x10
[175200.080237]  [<ffffffff81610763>] __wait_on_bit_lock+0x43/0xa0
[175200.080244]  [<ffffffff81140815>] __lock_page+0x65/0x70
[175200.080251]  [<ffffffff810a3570>] ? autoremove_wake_function+0x30/0x30
[175200.080322]  [<ffffffffc05001a9>] ? flush_write_bio+0x9/0x10 [btrfs]
[175200.080367]  [<ffffffffc05041a8>] extent_write_cache_pages.isra.28.constprop.46+0x2d8/0x3e0 [btrfs]
[175200.080411]  [<ffffffffc05060f8>] extent_writepages+0x48/0x60 [btrfs]
[175200.080451]  [<ffffffffc04e9460>] ? btrfs_writepage_end_io_hook+0x1a0/0x1a0 [btrfs]
[175200.080489]  [<ffffffffc04e6e83>] btrfs_writepages+0x23/0x30 [btrfs]
[175200.080496]  [<ffffffff8114de79>] do_writepages+0x19/0x30
[175200.080503]  [<ffffffff81142281>] __filemap_fdatawrite_range+0x51/0x60
[175200.080510]  [<ffffffff8114233e>] filemap_fdatawrite_range+0xe/0x10
[175200.080549]  [<ffffffffc04f53e9>] btrfs_sync_file+0x49/0x310 [btrfs]
[175200.080558]  [<ffffffff8107c134>] ? task_work_run+0xb4/0xf0
[175200.080564]  [<ffffffff811e302c>] do_fsync+0x4c/0x80
[175200.080570]  [<ffffffff811e32ab>] SyS_fsync+0xb/0x10
[175200.080577]  [<ffffffff816145ad>] system_call_fastpath+0x1a/0x1f
[175200.080588] INFO: task kworker/u12:4:7346 blocked for more than 480 seconds.
[175200.080592]       Not tainted 3.16.0-rc2-12.gfc9498b-desktop+ #2
[175200.080595] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[175200.080599] kworker/u12:4   D ffff88011fcd3a00     0  7346      2 0x00000000
[175200.080609] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-5)
[175200.080613]  ffff880060c5b9d8 0000000000000046 ffff88003ffec510 0000000000013a00
[175200.080619]  ffff880060c5bfd8 0000000000013a00 ffff88003ffec510 ffff88011fcd4310
[175200.080625]  ffff88011ffc9608 ffff880060c5ba60 0000000000000002 ffffffff81140710
[175200.080630] Call Trace:
[175200.080638]  [<ffffffff81140710>] ? wait_on_page_read+0x60/0x60
[175200.080645]  [<ffffffff816101fa>] io_schedule+0xaa/0x140
[175200.080652]  [<ffffffff81140719>] sleep_on_page+0x9/0x10
[175200.080659]  [<ffffffff81610763>] __wait_on_bit_lock+0x43/0xa0
[175200.080665]  [<ffffffff81140815>] __lock_page+0x65/0x70
[175200.080671]  [<ffffffff810a3570>] ? autoremove_wake_function+0x30/0x30
[175200.080713]  [<ffffffffc05001a9>] ? flush_write_bio+0x9/0x10 [btrfs]
[175200.080754]  [<ffffffffc05041a8>] extent_write_cache_pages.isra.28.constprop.46+0x2d8/0x3e0 [btrfs]
[175200.080797]  [<ffffffffc05060f8>] extent_writepages+0x48/0x60 [btrfs]
[175200.080836]  [<ffffffffc04e9460>] ? btrfs_writepage_end_io_hook+0x1a0/0x1a0 [btrfs]
[175200.080874]  [<ffffffffc04e6e83>] btrfs_writepages+0x23/0x30 [btrfs]
[175200.080880]  [<ffffffff8114de79>] do_writepages+0x19/0x30
[175200.080888]  [<ffffffff811dbacb>] __writeback_single_inode+0x3b/0x2c0
[175200.080894]  [<ffffffff810a3180>] ? wake_up_bit+0x20/0x30
[175200.081050]  [<ffffffff811dca87>] writeback_sb_inodes+0x247/0x3e0
[175200.081059]  [<ffffffff811dccb7>] __writeback_inodes_wb+0x97/0xd0
[175200.081072]  [<ffffffff811dcefb>] wb_writeback+0x20b/0x340
[175200.081078]  [<ffffffff811df3b9>] bdi_writeback_workfn+0x1d9/0x490
[175200.081086]  [<ffffffff81078333>] process_one_work+0x173/0x4c0
[175200.081092]  [<ffffffff81078ba3>] worker_thread+0x63/0x540
[175200.081100]  [<ffffffff81078b40>] ? create_and_start_worker+0x40/0x40
[175200.081106]  [<ffffffff8107efb6>] kthread+0xd6/0xf0
[175200.081112]  [<ffffffff8107eee0>] ? kthread_create_on_node+0x180/0x180
[175200.081118]  [<ffffffff816144fc>] ret_from_fork+0x7c/0xb0
[175200.081124]  [<ffffffff8107eee0>] ? kthread_create_on_node+0x180/0x180
[175200.081136] INFO: task kworker/u12:10:9821 blocked for more than 480 seconds.
[175200.081140]       Not tainted 3.16.0-rc2-12.gfc9498b-desktop+ #2
[175200.081143] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[175200.081146] kworker/u12:10  D ffff88011fc13a00     0  9821      2 0x00000000
[175200.081196] Workqueue: btrfs-delalloc normal_work_helper [btrfs]
[175200.081200]  ffff88000392f858 0000000000000046 ffff8800039b2210 0000000000013a00
[175200.081206]  ffff88000392ffd8 0000000000013a00 ffff8800039b2210 ffff88011fc14310
[175200.081211]  ffff88011ffcd988 ffff88000392f8e0 0000000000000002 ffffffff81140710
[175200.081217] Call Trace:
[175200.081224]  [<ffffffff81140710>] ? wait_on_page_read+0x60/0x60
[175200.081231]  [<ffffffff816101fa>] io_schedule+0xaa/0x140
[175200.081237]  [<ffffffff81140719>] sleep_on_page+0x9/0x10
[175200.081244]  [<ffffffff81610763>] __wait_on_bit_lock+0x43/0xa0
[175200.081251]  [<ffffffff81140815>] __lock_page+0x65/0x70
[175200.081257]  [<ffffffff810a3570>] ? autoremove_wake_function+0x30/0x30
[175200.081264]  [<ffffffff811414bc>] pagecache_get_page+0xac/0x1d0
[175200.081306]  [<ffffffffc0526017>] io_ctl_prepare_pages+0x67/0x180 [btrfs]
[175200.081349]  [<ffffffffc0527d13>] __load_free_space_cache+0x1d3/0x680 [btrfs]
[175200.081392]  [<ffffffffc05282b4>] load_free_space_cache+0xf4/0x1b0 [btrfs]
[175200.081425]  [<ffffffffc04c6cd2>] cache_block_group+0x192/0x390 [btrfs]
[175200.081431]  [<ffffffff810a3540>] ? prepare_to_wait_event+0x100/0x100
[175200.081465]  [<ffffffffc04d1dea>] find_free_extent+0x95a/0xdb0 [btrfs]
[175200.081500]  [<ffffffffc04d2400>] btrfs_reserve_extent+0x60/0x150 [btrfs]
[175200.081539]  [<ffffffffc04eb4db>] cow_file_range+0x12b/0x400 [btrfs]
[175200.081582]  [<ffffffffc04e9460>] ? btrfs_writepage_end_io_hook+0x1a0/0x1a0 [btrfs]
[175200.081621]  [<ffffffffc04ec7b5>] submit_compressed_extents+0x1f5/0x460 [btrfs]
[175200.081661]  [<ffffffffc04eca20>] ? submit_compressed_extents+0x460/0x460 [btrfs]
[175200.081704]  [<ffffffffc04ecaa1>] async_cow_submit+0x81/0x90 [btrfs]
[175200.081746]  [<ffffffffc05142c3>] normal_work_helper+0x1b3/0x340 [btrfs]
[175200.081753]  [<ffffffff81078333>] process_one_work+0x173/0x4c0
[175200.081760]  [<ffffffff81078ba3>] worker_thread+0x63/0x540
[175200.081767]  [<ffffffff81078b40>] ? create_and_start_worker+0x40/0x40
[175200.081773]  [<ffffffff8107efb6>] kthread+0xd6/0xf0
[175200.081779]  [<ffffffff8107eee0>] ? kthread_create_on_node+0x180/0x180
[175200.081785]  [<ffffffff816144fc>] ret_from_fork+0x7c/0xb0
[175200.081791]  [<ffffffff8107eee0>] ? kthread_create_on_node+0x180/0x180
[175200.081797] INFO: task baloo_file_extr:10005 blocked for more than 480 seconds.
[175200.081801]       Not tainted 3.16.0-rc2-12.gfc9498b-desktop+ #2
[175200.081803] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[175200.081806] baloo_file_extr D ffff88011fc93a00     0 10005   6266 0x00000004
[175200.081812]  ffff8800c748fc78 0000000000000086 ffff8800a2a44390 0000000000013a00
[175200.081821]  ffff8800c748ffd8 0000000000013a00 ffff8800a2a44390 ffff88011fc94310
[175200.081826]  ffff88011ffcace8 ffff8800c748fd00 0000000000000002 ffffffff81140710
[175200.081832] Call Trace:
[175200.081839]  [<ffffffff81140710>] ? wait_on_page_read+0x60/0x60
[175200.081846]  [<ffffffff816101fa>] io_schedule+0xaa/0x140
[175200.081852]  [<ffffffff81140719>] sleep_on_page+0x9/0x10
[175200.081859]  [<ffffffff81610763>] __wait_on_bit_lock+0x43/0xa0
[175200.081866]  [<ffffffff81140815>] __lock_page+0x65/0x70
[175200.081871]  [<ffffffff810a3570>] ? autoremove_wake_function+0x30/0x30
[175200.081913]  [<ffffffffc05001a9>] ? flush_write_bio+0x9/0x10 [btrfs]
[175200.082079]  [<ffffffffc05041a8>] extent_write_cache_pages.isra.28.constprop.46+0x2d8/0x3e0 [btrfs]
[175200.082122]  [<ffffffffc05060f8>] extent_writepages+0x48/0x60 [btrfs]
[175200.082160]  [<ffffffffc04e9460>] ? btrfs_writepage_end_io_hook+0x1a0/0x1a0 [btrfs]
[175200.082198]  [<ffffffffc04e6e83>] btrfs_writepages+0x23/0x30 [btrfs]
[175200.082205]  [<ffffffff8114de79>] do_writepages+0x19/0x30
[175200.082212]  [<ffffffff81142281>] __filemap_fdatawrite_range+0x51/0x60
[175200.082219]  [<ffffffff8114233e>] filemap_fdatawrite_range+0xe/0x10
[175200.082259]  [<ffffffffc04f53e9>] btrfs_sync_file+0x49/0x310 [btrfs]
[175200.082266]  [<ffffffff8107c134>] ? task_work_run+0xb4/0xf0
[175200.082272]  [<ffffffff811e302c>] do_fsync+0x4c/0x80
[175200.082278]  [<ffffffff811e32ab>] SyS_fsync+0xb/0x10
[175200.082284]  [<ffffffff816145ad>] system_call_fastpath+0x1a/0x1f

Marc

