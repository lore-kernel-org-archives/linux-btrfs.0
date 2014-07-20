Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f169.google.com ([209.85.220.169]:40146 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbaGTVec (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 17:34:32 -0400
Received: by mail-vc0-f169.google.com with SMTP id hu12so11038248vcb.28
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 14:34:31 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 20 Jul 2014 23:34:31 +0200
Message-ID: <CAG-aW06ypR6qqNdRncEEgmNLHfNDcajrLV2FwztwiHBRmtkUxg@mail.gmail.com>
Subject: Re: Blocked tasks on 3.15.1
From: Matt <jackdachef@gmail.com>
To: clm@fb.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>[ deadlocks during rsync in 3.15 with compression enabled ]

>Hi everyone,

>I still haven't been able to reproduce this one here, but I'm going
>through a series of tests with lzo compression foraced and every
>operation forced to ordered.  Hopefully it'll kick it out soon.
>
>While I'm hammering away, could you please try this patch.  If this is
>the buy you're hitting, the deadlock will go away and you'll see this
>printk in the log.
>
>thanks!
>
>-chris

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3668048..8ab56df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8157,6 +8157,13 @@ void btrfs_destroy_inode(struct inode *inode)
  spin_unlock(&root->fs_info->ordered_root_lock);
  }

+ spin_lock(&root->fs_info->ordered_root_lock);
+ if (!list_empty(&BTRFS_I(inode)->ordered_operations)) {
+ list_del_init(&BTRFS_I(inode)->ordered_operations);
+printk(KERN_CRIT "racing inode deletion with ordered operations!!!!!!!!!!!\n");
+ }
+ spin_unlock(&root->fs_info->ordered_root_lock);
+
  if (test_bit(BTRFS_INODE_HAS_ORPHAN_ITEM,
      &BTRFS_I(inode)->runtime_flags)) {
  btrfs_info(root->fs_info, "inode %llu still on the orphan list",
--



Hi Chris,

just had that hang during rsync from /home (ZFS, mirrored) to /bak
(Btrfs w. lzo compression) again with that patch applied, it doesn't
seem to be related to that issue (or patch) - only applicable to my
case, obviously - since search for that string (e.g. "racing") doesn't
show anything in that message:

[16028.169347] INFO: task kworker/u16:2:11956 blocked for more than 180 seconds.
[16028.169349] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16028.169350] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16028.169351] kworker/u16:2 D ffff88081ec13540 0 11956 2 0x00000008
[16028.169356] Workqueue: btrfs-delalloc normal_work_helper
[16028.169358] ffff8806180ab8e0 0000000000000046 0000000000000000
0000000000000004
[16028.169359] 000000000000a000 ffff8806210f16b0 ffff8806180abfd8
ffffffff81e11500
[16028.169360] ffff8806210f16b0 0000000000000206 ffffffff8113e6cc
ffff88081ec135c0
[16028.169362] Call Trace:
[16028.169367] [<ffffffff8113e6cc>] ? delayacct_end+0x7c/0x90
[16028.169370] [<ffffffff811689d0>] ? wait_on_page_read+0x60/0x60
[16028.169374] [<ffffffff819cfc78>] ? io_schedule+0x88/0xe0
[16028.169375] [<ffffffff811689d5>] ? sleep_on_page+0x5/0x10
[16028.169377] [<ffffffff819cfffc>] ? __wait_on_bit_lock+0x3c/0x90
[16028.169378] [<ffffffff81168ac5>] ? __lock_page+0x65/0x70
[16028.169382] [<ffffffff810f5580>] ? autoremove_wake_function+0x30/0x30
[16028.169384] [<ffffffff81169854>] ? __find_lock_page+0x44/0x70
[16028.169385] [<ffffffff811698ca>] ? find_or_create_page+0x2a/0xa0
[16028.169388] [<ffffffff8145a1cf>] ? io_ctl_prepare_pages+0x4f/0x150
[16028.169390] [<ffffffff8145bd45>] ? __load_free_space_cache+0x195/0x5d0
[16028.169392] [<ffffffff8145c26b>] ? load_free_space_cache+0xeb/0x1b0
[16028.169395] [<ffffffff813fd6a1>] ? cache_block_group+0x191/0x390
[16028.169396] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16028.169398] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16028.169400] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16028.169403] [<ffffffff81421116>] ? cow_file_range+0x136/0x420
[16028.169404] [<ffffffff81422493>] ? submit_compressed_extents+0x1f3/0x480
[16028.169406] [<ffffffff81422720>] ? submit_compressed_extents+0x480/0x480
[16028.169407] [<ffffffff8144896b>] ? normal_work_helper+0x1ab/0x330
[16028.169410] [<ffffffff810df26d>] ? process_one_work+0x16d/0x490
[16028.169411] [<ffffffff810dff8b>] ? worker_thread+0x12b/0x410
[16028.169412] [<ffffffff810dfe60>] ? manage_workers.isra.28+0x2c0/0x2c0
[16028.169414] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16028.169415] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169417] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16028.169418] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169422] INFO: task btrfs-transacti:12042 blocked for more than
180 seconds.
[16028.169422] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16028.169423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16028.169423] btrfs-transacti D ffff88081ec13540 0 12042 2 0x00000008
[16028.169425] ffff88009c7adb20 0000000000000046 0000000000000000
ffff88040d84ca68
[16028.169426] 000000000000a000 ffff88061f284ba0 ffff88009c7adfd8
ffffffff81e11500
[16028.169427] ffff88061f284ba0 ffff88061a21dea8 ffffffff811b8c2d
ffff8805fc919e00
[16028.169428] Call Trace:
[16028.169431] [<ffffffff811b8c2d>] ? kmem_cache_alloc_trace+0x14d/0x160
[16028.169433] [<ffffffff813fd632>] ? cache_block_group+0x122/0x390
[16028.169434] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16028.169436] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16028.169437] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16028.169439] [<ffffffff81422fa8>] ? __btrfs_prealloc_file_range+0xe8/0x380
[16028.169441] [<ffffffff8140b6f2>] ? btrfs_write_dirty_block_groups+0x642/0x6d0
[16028.169442] [<ffffffff819cb00c>] ? commit_cowonly_roots+0x173/0x221
[16028.169443] [<ffffffff8141ad19>] ? btrfs_commit_transaction+0x509/0xa30
[16028.169445] [<ffffffff8141b2cb>] ? start_transaction+0x8b/0x5b0
[16028.169446] [<ffffffff81416d65>] ? transaction_kthread+0x1d5/0x240
[16028.169447] [<ffffffff81416b90>] ? btrfs_cleanup_transaction+0x560/0x560
[16028.169448] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16028.169449] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169451] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16028.169452] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169454] INFO: task kworker/u16:10:12208 blocked for more than
180 seconds.
[16028.169455] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16028.169455] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16028.169456] kworker/u16:10 D ffff88081ed13540 0 12208 2 0x00000000
[16028.169460] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-183)
[16028.169461] ffff880567b31a60 0000000000000046 ffff880500000000
000000000000000e
[16028.169462] 000000000000a000 ffff88061efff170 ffff880567b31fd8
ffff880799bb0000
[16028.169463] ffff88061efff170 0000000000000206 ffffffff8113e6cc
ffff88081ed135c0
[16028.169464] Call Trace:
[16028.169466] [<ffffffff8113e6cc>] ? delayacct_end+0x7c/0x90
[16028.169467] [<ffffffff811689d0>] ? wait_on_page_read+0x60/0x60
[16028.169468] [<ffffffff819cfc78>] ? io_schedule+0x88/0xe0
[16028.169470] [<ffffffff811689d5>] ? sleep_on_page+0x5/0x10
[16028.169471] [<ffffffff819cfffc>] ? __wait_on_bit_lock+0x3c/0x90
[16028.169472] [<ffffffff81168ac5>] ? __lock_page+0x65/0x70
[16028.169474] [<ffffffff810f5580>] ? autoremove_wake_function+0x30/0x30
[16028.169476] [<ffffffff81175958>] ? pagevec_lookup_tag+0x18/0x20
[16028.169480] [<ffffffff81439468>] ?
extent_write_cache_pages.isra.31.constprop.54+0x268/0x360
[16028.169481] [<ffffffff8143af78>] ? extent_writepages+0x48/0x60
[16028.169483] [<ffffffff8141f190>] ? btrfs_writepage_end_io_hook+0x170/0x170
[16028.169485] [<ffffffff811ee518>] ? __writeback_single_inode+0x38/0x2c0
[16028.169486] [<ffffffff811f20f9>] ? writeback_sb_inodes+0x259/0x430
[16028.169488] [<ffffffff811f235e>] ? __writeback_inodes_wb+0x8e/0xc0
[16028.169489] [<ffffffff811f259b>] ? wb_writeback+0x20b/0x340
[16028.169490] [<ffffffff811f2ae7>] ? bdi_writeback_workfn+0x2f7/0x470
[16028.169492] [<ffffffff810df26d>] ? process_one_work+0x16d/0x490
[16028.169493] [<ffffffff810dff8b>] ? worker_thread+0x12b/0x410
[16028.169495] [<ffffffff810dfe60>] ? manage_workers.isra.28+0x2c0/0x2c0
[16028.169496] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16028.169497] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169499] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16028.169500] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16028.169501] INFO: task rsync:12233 blocked for more than 180 seconds.
[16028.169502] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16028.169502] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16028.169503] rsync D ffff88081ec53540 0 12233 12232 0x00000008
[16028.169504] ffff8804030a3d28 0000000000000082 ffff8804030a3e30
ffffffff811d2f01
[16028.169505] 000000000000a000 ffff880799bb69e0 ffff8804030a3fd8
ffff8807fa0fe250
[16028.169507] ffff880799bb69e0 ffff880799bb69e0 ffff8804030a3da8
ffff8807f9c65600
[16028.169508] Call Trace:
[16028.169509] [<ffffffff811d2f01>] ? link_path_walk+0x81/0xe70
[16028.169511] [<ffffffff81419f27>] ? wait_current_trans.isra.20+0x97/0x100
[16028.169513] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16028.169514] [<ffffffff8141b510>] ? start_transaction+0x2d0/0x5b0
[16028.169515] [<ffffffff814208ab>] ? btrfs_dirty_inode+0x3b/0xd0
[16028.169517] [<ffffffff811e3411>] ? setattr_copy+0x91/0x120
[16028.169518] [<ffffffff814254fc>] ? btrfs_setattr+0xac/0x300
[16028.169519] [<ffffffff811e3691>] ? notify_change+0x1f1/0x370
[16028.169521] [<ffffffff811f6b1a>] ? utimes_common+0xca/0x1b0
[16028.169523] [<ffffffff811f6cc8>] ? do_utimes+0xc8/0x140
[16028.169525] [<ffffffff811f6e12>] ? SyS_utimensat+0x52/0x80
[16028.169527] [<ffffffff819d3d26>] ? system_call_fastpath+0x1a/0x1f
[16208.244385] INFO: task kworker/u16:2:11956 blocked for more than 180 seconds.
[16208.244388] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16208.244388] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16208.244389] kworker/u16:2 D ffff88081ec13540 0 11956 2 0x00000008
[16208.244395] Workqueue: btrfs-delalloc normal_work_helper
[16208.244396] ffff8806180ab8e0 0000000000000046 0000000000000000
0000000000000004
[16208.244397] 000000000000a000 ffff8806210f16b0 ffff8806180abfd8
ffffffff81e11500
[16208.244399] ffff8806210f16b0 0000000000000206 ffffffff8113e6cc
ffff88081ec135c0
[16208.244400] Call Trace:
[16208.244405] [<ffffffff8113e6cc>] ? delayacct_end+0x7c/0x90
[16208.244408] [<ffffffff811689d0>] ? wait_on_page_read+0x60/0x60
[16208.244412] [<ffffffff819cfc78>] ? io_schedule+0x88/0xe0
[16208.244413] [<ffffffff811689d5>] ? sleep_on_page+0x5/0x10
[16208.244415] [<ffffffff819cfffc>] ? __wait_on_bit_lock+0x3c/0x90
[16208.244416] [<ffffffff81168ac5>] ? __lock_page+0x65/0x70
[16208.244420] [<ffffffff810f5580>] ? autoremove_wake_function+0x30/0x30
[16208.244421] [<ffffffff81169854>] ? __find_lock_page+0x44/0x70
[16208.244423] [<ffffffff811698ca>] ? find_or_create_page+0x2a/0xa0
[16208.244426] [<ffffffff8145a1cf>] ? io_ctl_prepare_pages+0x4f/0x150
[16208.244428] [<ffffffff8145bd45>] ? __load_free_space_cache+0x195/0x5d0
[16208.244430] [<ffffffff8145c26b>] ? load_free_space_cache+0xeb/0x1b0
[16208.244433] [<ffffffff813fd6a1>] ? cache_block_group+0x191/0x390
[16208.244434] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16208.244436] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16208.244438] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16208.244440] [<ffffffff81421116>] ? cow_file_range+0x136/0x420
[16208.244442] [<ffffffff81422493>] ? submit_compressed_extents+0x1f3/0x480
[16208.244443] [<ffffffff81422720>] ? submit_compressed_extents+0x480/0x480
[16208.244445] [<ffffffff8144896b>] ? normal_work_helper+0x1ab/0x330
[16208.244447] [<ffffffff810df26d>] ? process_one_work+0x16d/0x490
[16208.244449] [<ffffffff810dff8b>] ? worker_thread+0x12b/0x410
[16208.244450] [<ffffffff810dfe60>] ? manage_workers.isra.28+0x2c0/0x2c0
[16208.244452] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16208.244453] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244455] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16208.244456] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244459] INFO: task btrfs-transacti:12042 blocked for more than
180 seconds.
[16208.244460] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16208.244460] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16208.244461] btrfs-transacti D ffff88081ec13540 0 12042 2 0x00000008
[16208.244462] ffff88009c7adb20 0000000000000046 0000000000000000
ffff88040d84ca68
[16208.244464] 000000000000a000 ffff88061f284ba0 ffff88009c7adfd8
ffffffff81e11500
[16208.244465] ffff88061f284ba0 ffff88061a21dea8 ffffffff811b8c2d
ffff8805fc919e00
[16208.244466] Call Trace:
[16208.244468] [<ffffffff811b8c2d>] ? kmem_cache_alloc_trace+0x14d/0x160
[16208.244470] [<ffffffff813fd632>] ? cache_block_group+0x122/0x390
[16208.244471] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16208.244473] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16208.244474] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16208.244476] [<ffffffff81422fa8>] ? __btrfs_prealloc_file_range+0xe8/0x380
[16208.244478] [<ffffffff8140b6f2>] ? btrfs_write_dirty_block_groups+0x642/0x6d0
[16208.244479] [<ffffffff819cb00c>] ? commit_cowonly_roots+0x173/0x221
[16208.244481] [<ffffffff8141ad19>] ? btrfs_commit_transaction+0x509/0xa30
[16208.244482] [<ffffffff8141b2cb>] ? start_transaction+0x8b/0x5b0
[16208.244483] [<ffffffff81416d65>] ? transaction_kthread+0x1d5/0x240
[16208.244484] [<ffffffff81416b90>] ? btrfs_cleanup_transaction+0x560/0x560
[16208.244485] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16208.244487] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244488] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16208.244489] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244491] INFO: task kworker/u16:10:12208 blocked for more than
180 seconds.
[16208.244491] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16208.244492] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16208.244492] kworker/u16:10 D ffff88081ed13540 0 12208 2 0x00000000
[16208.244496] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-183)
[16208.244497] ffff880567b31a60 0000000000000046 ffff880500000000
000000000000000e
[16208.244499] 000000000000a000 ffff88061efff170 ffff880567b31fd8
ffff880799bb0000
[16208.244500] ffff88061efff170 0000000000000206 ffffffff8113e6cc
ffff88081ed135c0
[16208.244501] Call Trace:
[16208.244502] [<ffffffff8113e6cc>] ? delayacct_end+0x7c/0x90
[16208.244504] [<ffffffff811689d0>] ? wait_on_page_read+0x60/0x60
[16208.244505] [<ffffffff819cfc78>] ? io_schedule+0x88/0xe0
[16208.244507] [<ffffffff811689d5>] ? sleep_on_page+0x5/0x10
[16208.244508] [<ffffffff819cfffc>] ? __wait_on_bit_lock+0x3c/0x90
[16208.244509] [<ffffffff81168ac5>] ? __lock_page+0x65/0x70
[16208.244511] [<ffffffff810f5580>] ? autoremove_wake_function+0x30/0x30
[16208.244513] [<ffffffff81175958>] ? pagevec_lookup_tag+0x18/0x20
[16208.244516] [<ffffffff81439468>] ?
extent_write_cache_pages.isra.31.constprop.54+0x268/0x360
[16208.244518] [<ffffffff8143af78>] ? extent_writepages+0x48/0x60
[16208.244520] [<ffffffff8141f190>] ? btrfs_writepage_end_io_hook+0x170/0x170
[16208.244522] [<ffffffff811ee518>] ? __writeback_single_inode+0x38/0x2c0
[16208.244523] [<ffffffff811f20f9>] ? writeback_sb_inodes+0x259/0x430
[16208.244524] [<ffffffff811f235e>] ? __writeback_inodes_wb+0x8e/0xc0
[16208.244526] [<ffffffff811f259b>] ? wb_writeback+0x20b/0x340
[16208.244527] [<ffffffff811f2ae7>] ? bdi_writeback_workfn+0x2f7/0x470
[16208.244529] [<ffffffff810df26d>] ? process_one_work+0x16d/0x490
[16208.244530] [<ffffffff810dff8b>] ? worker_thread+0x12b/0x410
[16208.244531] [<ffffffff810dfe60>] ? manage_workers.isra.28+0x2c0/0x2c0
[16208.244533] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16208.244534] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244535] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16208.244536] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16208.244538] INFO: task rsync:12233 blocked for more than 180 seconds.
[16208.244538] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16208.244539] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16208.244539] rsync D ffff88081ec53540 0 12233 12232 0x00000008
[16208.244541] ffff8804030a3d28 0000000000000082 ffff8804030a3e30
ffffffff811d2f01
[16208.244542] 000000000000a000 ffff880799bb69e0 ffff8804030a3fd8
ffff8807fa0fe250
[16208.244543] ffff880799bb69e0 ffff880799bb69e0 ffff8804030a3da8
ffff8807f9c65600
[16208.244544] Call Trace:
[16208.244546] [<ffffffff811d2f01>] ? link_path_walk+0x81/0xe70
[16208.244547] [<ffffffff81419f27>] ? wait_current_trans.isra.20+0x97/0x100
[16208.244549] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16208.244550] [<ffffffff8141b510>] ? start_transaction+0x2d0/0x5b0
[16208.244552] [<ffffffff814208ab>] ? btrfs_dirty_inode+0x3b/0xd0
[16208.244553] [<ffffffff811e3411>] ? setattr_copy+0x91/0x120
[16208.244555] [<ffffffff814254fc>] ? btrfs_setattr+0xac/0x300
[16208.244556] [<ffffffff811e3691>] ? notify_change+0x1f1/0x370
[16208.244558] [<ffffffff811f6b1a>] ? utimes_common+0xca/0x1b0
[16208.244559] [<ffffffff811f6cc8>] ? do_utimes+0xc8/0x140
[16208.244561] [<ffffffff811f6e12>] ? SyS_utimensat+0x52/0x80
[16208.244563] [<ffffffff819d3d26>] ? system_call_fastpath+0x1a/0x1f
[16388.319440] INFO: task kworker/u16:2:11956 blocked for more than 180 seconds.
[16388.319442] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16388.319443] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16388.319444] kworker/u16:2 D ffff88081ec13540 0 11956 2 0x00000008
[16388.319450] Workqueue: btrfs-delalloc normal_work_helper
[16388.319451] ffff8806180ab8e0 0000000000000046 0000000000000000
0000000000000004
[16388.319452] 000000000000a000 ffff8806210f16b0 ffff8806180abfd8
ffffffff81e11500
[16388.319453] ffff8806210f16b0 0000000000000206 ffffffff8113e6cc
ffff88081ec135c0
[16388.319455] Call Trace:
[16388.319460] [<ffffffff8113e6cc>] ? delayacct_end+0x7c/0x90
[16388.319463] [<ffffffff811689d0>] ? wait_on_page_read+0x60/0x60
[16388.319467] [<ffffffff819cfc78>] ? io_schedule+0x88/0xe0
[16388.319468] [<ffffffff811689d5>] ? sleep_on_page+0x5/0x10
[16388.319469] [<ffffffff819cfffc>] ? __wait_on_bit_lock+0x3c/0x90
[16388.319471] [<ffffffff81168ac5>] ? __lock_page+0x65/0x70
[16388.319475] [<ffffffff810f5580>] ? autoremove_wake_function+0x30/0x30
[16388.319477] [<ffffffff81169854>] ? __find_lock_page+0x44/0x70
[16388.319478] [<ffffffff811698ca>] ? find_or_create_page+0x2a/0xa0
[16388.319481] [<ffffffff8145a1cf>] ? io_ctl_prepare_pages+0x4f/0x150
[16388.319483] [<ffffffff8145bd45>] ? __load_free_space_cache+0x195/0x5d0
[16388.319485] [<ffffffff8145c26b>] ? load_free_space_cache+0xeb/0x1b0
[16388.319488] [<ffffffff813fd6a1>] ? cache_block_group+0x191/0x390
[16388.319489] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16388.319491] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16388.319493] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16388.319496] [<ffffffff81421116>] ? cow_file_range+0x136/0x420
[16388.319497] [<ffffffff81422493>] ? submit_compressed_extents+0x1f3/0x480
[16388.319499] [<ffffffff81422720>] ? submit_compressed_extents+0x480/0x480
[16388.319500] [<ffffffff8144896b>] ? normal_work_helper+0x1ab/0x330
[16388.319503] [<ffffffff810df26d>] ? process_one_work+0x16d/0x490
[16388.319504] [<ffffffff810dff8b>] ? worker_thread+0x12b/0x410
[16388.319505] [<ffffffff810dfe60>] ? manage_workers.isra.28+0x2c0/0x2c0
[16388.319507] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16388.319508] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16388.319510] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16388.319511] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16388.319514] INFO: task btrfs-transacti:12042 blocked for more than
180 seconds.
[16388.319515] Tainted: P O 3.14.13_btrfs+_BFS_test27_integration #2
[16388.319515] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[16388.319516] btrfs-transacti D ffff88081ec13540 0 12042 2 0x00000008
[16388.319517] ffff88009c7adb20 0000000000000046 0000000000000000
ffff88040d84ca68
[16388.319519] 000000000000a000 ffff88061f284ba0 ffff88009c7adfd8
ffffffff81e11500
[16388.319520] ffff88061f284ba0 ffff88061a21dea8 ffffffff811b8c2d
ffff8805fc919e00
[16388.319521] Call Trace:
[16388.319524] [<ffffffff811b8c2d>] ? kmem_cache_alloc_trace+0x14d/0x160
[16388.319526] [<ffffffff813fd632>] ? cache_block_group+0x122/0x390
[16388.319527] [<ffffffff810f5550>] ? prepare_to_wait_event+0xf0/0xf0
[16388.319529] [<ffffffff814085ea>] ? find_free_extent+0x95a/0xdb0
[16388.319530] [<ffffffff81408bf9>] ? btrfs_reserve_extent+0x69/0x150
[16388.319532] [<ffffffff81422fa8>] ? __btrfs_prealloc_file_range+0xe8/0x380
[16388.319534] [<ffffffff8140b6f2>] ? btrfs_write_dirty_block_groups+0x642/0x6d0
[16388.319535] [<ffffffff819cb00c>] ? commit_cowonly_roots+0x173/0x221
[16388.319537] [<ffffffff8141ad19>] ? btrfs_commit_transaction+0x509/0xa30
[16388.319538] [<ffffffff8141b2cb>] ? start_transaction+0x8b/0x5b0
[16388.319539] [<ffffffff81416d65>] ? transaction_kthread+0x1d5/0x240
[16388.319540] [<ffffffff81416b90>] ? btrfs_cleanup_transaction+0x560/0x560
[16388.319541] [<ffffffff810e579a>] ? kthread+0xca/0xe0
[16388.319543] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180
[16388.319544] [<ffffffff819d3c7c>] ? ret_from_fork+0x7c/0xb0
[16388.319545] [<ffffffff810e56d0>] ? kthread_create_on_node+0x180/0x180


but the previous error message I saw seemed related to

http://www.spinics.net/lists/linux-btrfs/msg35145.html

and

http://www.spinics.net/lists/linux-btrfs/msg33628.html


Be aware that this kernel is a highly patched up 3.14.13 with latest
Btrfs integration/for-linus branch - up to

commit abdd2e80a57e5f7278f47913315065f0a3d78d20
Author: Filipe Manana <fdmanana@gmail.com>
Date:   Tue Jun 24 17:46:58 2014 +0100

    Btrfs: fix crash when starting transaction

except

Btrfs: fix broken free space cache after the system crashed

(commit e570fd27f2c5d7eac3876bccf99e9838d7f911a3)

which doesn't seem to apply cleanly for me.

So it's not really representative when looking for other kernel
internals but should show almost 100% similar behavior like a 3.15+
kernel with latest integration/for-linus branch.

Currently I have no reason and plans to migrate to 3.15 since I'm
planning to wait for it to mature a little bit more.


Root is on Btrfs with lzo compression on an Intel SSD.

Last time this happened I had the partition formatted with zlib/gzip
compression. This time it's with lzo and also happening.

The problem is that rsync can't be killed off - so the load will
increase over time, only option being to reboot via Magic SYSRQ Key:

ps aux | grep rsync
root     12233  0.1  0.0  33880  4776 pts/0    D+   22:20   0:03 rsync
-aiP --delete --inplace --stats /home/matt/news/ /bak/matt/news/
root     12234  0.0  0.0      0     0 pts/0    Z+   22:20   0:00
[rsync] <defunct>
root     12579  0.0  0.0  30380  1376 pts/0    S+   23:20   0:00 rsync
-ai --delete --inplace --stats /home/matt/.links/ /bak/matt/.links/
root     12580  0.0  0.0  30352   940 pts/0    D+   23:20   0:00 rsync
-ai --delete --inplace --stats /home/matt/.links/ /bak/matt/.links/
root     12581  0.0  0.0  30352   280 pts/0    S+   23:20   0:00 rsync
-ai --delete --inplace --stats /home/matt/.links/ /bak/matt/.links/
root     12583  0.0  0.0  18916  1000 pts/1    S+   23:21   0:00 grep
--color=auto rsync

/bak is a newly created partition which a few days ago just got
finished getting written to (around 1.5 TB of data).


Any ideas or other patches I could try ?

If I understood correctly

"Btrfs: fix abnormal long waiting in fsync" doesn't apply to the 3.14
kernel base since it's rather new (June 5th, according to
http://code.metager.de/source/history/linux/stable/mm/ )

and "btrfs: test for valid bdev before kobj removal in
btrfs_rm_device" is not related

Keep up the great work !

Btrfs is significantly more resilient than in the past (surviving
hardlocks, etc.) - but this high load related rsync blocked task
behavior (also had this in the past several kernel versions back)
creates headaches and still prevents it from being used on a regular,
efficient, basis. I'd *really* like to have an alternative filesystem
with checksums besides ZFS


Kind Regards

Matt
