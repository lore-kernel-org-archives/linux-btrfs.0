Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from old.lon-b.elastichosts.com ([84.45.121.3]:60346 "EHLO
	lon-b.elastichosts.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752900AbaFLPO7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 11:14:59 -0400
Received: from [79.135.116.105] (helo=[192.168.0.71])
	by lon-b.elastichosts.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.72)
	(envelope-from <alin.dobre@elastichosts.com>)
	id 1Wv6iP-00009s-CK
	for linux-btrfs@vger.kernel.org; Thu, 12 Jun 2014 16:14:57 +0100
Message-ID: <5399C40F.3070509@elastichosts.com>
Date: Thu, 12 Jun 2014 16:15:27 +0100
From: Alin Dobre <alin.dobre@elastichosts.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Deadlock/high load
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I have a problem that triggers quite often on our production machines. I
don't really know what's triggering this or how to reproduce it, but the
machine enters in some sort of deadlock state, where it consumes all the
i/o and the load average goes very high in seconds (it even gets to over
200), sometimes in about a minute or even less, the machine is
unresponsive and we have to reset it. Rarely, the load just stays high
(~25) for hours, but it never gets down again, but this happens rarely,
as I said. In general, the machine is either already unresponsive or is
about to become unresponsive.

The last machine that encountered this has 40 cores and the btrfs
filesystem is running over SSDs. We encountered this on a plain 3.14
kernel, and also on the latest 3.14.6 kernel + all the patches whose
summary is marked "btrfs:" that made it in 3.15, straight forward
backported (cherry-picked) to 3.14.

Also, no suspicious (malicious) activity from the running processes either.

I noticed there was another report on 3.13 which was solved by a 3.15rc
patch, it doesn't seem to be the same thing.

Since the only chance to obtain something was via a SysRq dump, here's
what I could get from the last "w" trigger (tasks that are in
uninterruptable (blocked) state), showing only tasks that are related to
btrfs:

btrfs-transacti D 000000000000000e     0  2483      2 0x00080008
 ffff881fd05975d8 ffffffff81880a27 ffff881fd05974e8 ffff881fd05974f8
 ffff881fd0596010 ffff881fd05975d8 0000000000011bc0 ffff881fd13398f0
 0000000000011bc0 0000000000011bc0 ffff881fd28ecad0 ffff881fd13398f0
Call Trace:
 [<ffffffff81880a27>] ? __schedule+0x687/0x72c
 [<ffffffff8163aaf0>] ? do_release_stripe+0xeb/0x182
 [<ffffffff8114a076>] ? zone_statistics+0x77/0x7e
 [<ffffffff8163fed0>] ? raid5_unplug+0xaa/0xb3
 [<ffffffff813cb87e>] ? blk_flush_plug_list+0x99/0x1f0
 [<ffffffff8163c24d>] ? get_active_stripe+0x65/0x5ca
 [<ffffffff810f8704>] ? prepare_to_wait+0x71/0x7c
 [<ffffffff816431f9>] ? make_request+0x7b0/0x999
 [<ffffffff816429d4>] ? release_stripe_plug+0x20/0x95
 [<ffffffff810f8497>] ? bit_waitqueue+0xb0/0xb0
 [<ffffffff810f8497>] ? bit_waitqueue+0xb0/0xb0
 [<ffffffff8166375a>] ? md_make_request+0xfa/0x215
 [<ffffffff81324f22>] ? __btrfs_map_block+0xd6f/0xd89
 [<ffffffff813ca63c>] ? generic_make_request+0x99/0xda
 [<ffffffff813ca770>] ? submit_bio+0xf3/0xfe
 [<ffffffff813251de>] ? submit_stripe_bio+0x77/0x82
 [<ffffffff813255b6>] ? btrfs_map_bio+0x3cd/0x440
 [<ffffffff812fdc1d>] ? csum_tree_block+0x1c1/0x1ec
 [<ffffffff812fdfa6>] ? btree_submit_bio_hook+0x97/0xf0
 [<ffffffff811b561e>] ? __bio_add_page+0x153/0x1de
 [<ffffffff8131ab64>] ? submit_one_bio+0x63/0x90
 [<ffffffff8113c61b>] ? account_page_writeback+0x28/0x2d
 [<ffffffff8131b504>] ? submit_extent_page+0xe7/0x17e
 [<ffffffff81320796>] ? btree_write_cache_pages+0x44c/0x71a
 [<ffffffff8131b272>] ? extent_range_clear_dirty_for_io+0x5a/0x5a
 [<ffffffff812fc41a>] ? btree_writepages+0x4a/0x53
 [<ffffffff8113cf5f>] ? do_writepages+0x1b/0x24
 [<ffffffff81134f76>] ? __filemap_fdatawrite_range+0x4e/0x50
 [<ffffffff81135b55>] ? filemap_fdatawrite_range+0xe/0x10
 [<ffffffff813020c1>] ? btrfs_write_marked_extents+0x83/0xd1
 [<ffffffff8130216b>] ? btrfs_write_and_wait_transaction+0x5c/0x8a
 [<ffffffff81302ee2>] ? btrfs_commit_transaction+0x68b/0x87c
 [<ffffffff810cf0b7>] ? del_timer+0x87/0x87
 [<ffffffff812fef3f>] ? transaction_kthread+0x114/0x1e9
 [<ffffffff812fee2b>] ? close_ctree+0x280/0x280
 [<ffffffff810df1ff>] ? kthread+0xc9/0xd1
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
 [<ffffffff818842cc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
rs:main Q:Reg   D 0000000000000002     0  6857   4976 0x00000000
 ffff883fc9b0bb08 0000000000000002 ffff883fc9b0b9e8 ffff883fc9b0ba28
 ffff883fc9b0a010 ffff883fc9b0bb08 0000000000011bc0 ffff883fc794db70
 0000000000011bc0 0000000000011bc0 ffff881fd28e8000 ffff883fc794db70
Call Trace:
 [<ffffffff81040a93>] ? native_sched_clock+0x17/0xd3
 [<ffffffff810406e7>] ? sched_clock+0x9/0xd
 [<ffffffff810eb7c2>] ? arch_vtime_task_switch+0x81/0x86
 [<ffffffff810ebc88>] ? vtime_common_task_switch+0x29/0x2d
 [<ffffffff8104072d>] ? read_tsc+0x9/0x1b
 [<ffffffff81880c2a>] schedule+0x6e/0x70
 [<ffffffff81880cbf>] io_schedule+0x93/0xd7
 [<ffffffff81134170>] ? __lock_page+0x68/0x68
 [<ffffffff81134179>] sleep_on_page+0x9/0xd
 [<ffffffff8188118f>] __wait_on_bit+0x45/0x7a
 [<ffffffff8113444e>] wait_on_page_bit+0x71/0x78
 [<ffffffff810f84f3>] ? wake_atomic_t_function+0x28/0x28
 [<ffffffff81311056>] prepare_pages+0xd2/0x11b
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff8110eb76>] ? futex_wait+0x176/0x239
 [<ffffffff810c9650>] ? current_fs_time+0x22/0x29
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff81198eb3>] ? path_openat+0x593/0x5cc
 [<ffffffff8118c275>] do_sync_write+0x59/0x79
 [<ffffffff8118d53e>] vfs_write+0xd3/0x172
 [<ffffffff8118d69e>] SyS_write+0x4b/0x8f
 [<ffffffff81884505>] tracesys+0xd0/0xd5
freshclam       D 0000000000000002     0  8305   4976 0x00000000
 ffff883fbc1b1b08 0000000000000002 ffff881fdfc72760 ffff883fbc1b1a28
 ffff883fbc1b0010 ffff883fbc1b1b08 0000000000011bc0 ffff883fb5ca31e0
 0000000000011bc0 0000000000011bc0 ffffffff81b8d440 ffff883fb5ca31e0
Call Trace:
 [<ffffffff8113f65f>] ? lru_cache_add+0x9/0xb
 [<ffffffff8115d727>] ? page_add_new_anon_rmap+0x108/0x11a
 [<ffffffff811535a8>] ? handle_mm_fault+0xbdf/0xc84
 [<ffffffff8104072d>] ? read_tsc+0x9/0x1b
 [<ffffffff81880c2a>] schedule+0x6e/0x70
 [<ffffffff81880cbf>] io_schedule+0x93/0xd7
 [<ffffffff81134170>] ? __lock_page+0x68/0x68
 [<ffffffff81134179>] sleep_on_page+0x9/0xd
 [<ffffffff8188118f>] __wait_on_bit+0x45/0x7a
 [<ffffffff8113444e>] wait_on_page_bit+0x71/0x78
 [<ffffffff810f84f3>] ? wake_atomic_t_function+0x28/0x28
 [<ffffffff81311056>] prepare_pages+0xd2/0x11b
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff81194a71>] ? complete_walk+0x84/0xc9
 [<ffffffff810c9650>] ? current_fs_time+0x22/0x29
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff811991d6>] ? final_putname+0x33/0x37
 [<ffffffff8118c275>] do_sync_write+0x59/0x79
 [<ffffffff8118d53e>] vfs_write+0xd3/0x172
 [<ffffffff8118d69e>] SyS_write+0x4b/0x8f
 [<ffffffff81884505>] tracesys+0xd0/0xd5
nginx           D 0000000000000002     0 12360  12358 0x00000000
 ffff881f9ef6bb08 0000000000000002 ffff881f9ef6ba08 ffff881f9ef6ba28
 ffff881f9ef6a010 ffff881f9ef6bb08 0000000000011bc0 ffff881fb894ec10
 0000000000011bc0 0000000000011bc0 ffffffff81b8d440 ffff881fb894ec10
Call Trace:
 [<ffffffff816db51b>] ? netif_rx_internal+0xc9/0xda
 [<ffffffff816db535>] ? netif_rx+0x9/0xb
 [<ffffffff8150c554>] ? loopback_xmit+0x9a/0xb4
 [<ffffffff8104072d>] ? read_tsc+0x9/0x1b
 [<ffffffff81880c2a>] schedule+0x6e/0x70
 [<ffffffff81880cbf>] io_schedule+0x93/0xd7
 [<ffffffff81134170>] ? __lock_page+0x68/0x68
 [<ffffffff81134179>] sleep_on_page+0x9/0xd
 [<ffffffff8188118f>] __wait_on_bit+0x45/0x7a
 [<ffffffff8113444e>] wait_on_page_bit+0x71/0x78
 [<ffffffff810f84f3>] ? wake_atomic_t_function+0x28/0x28
 [<ffffffff81311056>] prepare_pages+0xd2/0x11b
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff810c9650>] ? current_fs_time+0x22/0x29
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff816c442b>] ? sock_destroy_inode+0x2e/0x32
 [<ffffffff8118c275>] do_sync_write+0x59/0x79
 [<ffffffff8118d53e>] vfs_write+0xd3/0x172
 [<ffffffff8118d69e>] SyS_write+0x4b/0x8f
 [<ffffffff81884505>] tracesys+0xd0/0xd5
kworker/u81:1   D ffff883fd150e800     0 35017      2 0x00000000
Workqueue: writeback bdi_writeback_workfn (flush-9:0)
 ffff881f60ae56d8 0000000000000002 ffff881f60ae55c8 ffff881f60ae55f8
 ffff881f60ae4010 ffff881f60ae56d8 0000000000011bc0 ffff881fd12bf460
 0000000000011bc0 0000000000011bc0 ffff881fd28e8850 ffff881fd12bf460
Call Trace:
 [<ffffffff810ea9a7>] ? default_wake_function+0xd/0xf
 [<ffffffff810f84a8>] ? autoremove_wake_function+0x11/0x34
 [<ffffffff810f838c>] ? __wake_up_common+0x49/0x7f
 [<ffffffff81880c2a>] schedule+0x6e/0x70
 [<ffffffff816613c8>] md_write_start+0x12a/0x142
 [<ffffffff810f8497>] ? bit_waitqueue+0xb0/0xb0
 [<ffffffff81631e4f>] make_request+0x61/0xc26
 [<ffffffff811b561e>] ? __bio_add_page+0x153/0x1de
 [<ffffffff81134218>] ? unlock_page+0x22/0x26
 [<ffffffff8113efc1>] ? release_pages+0x1f2/0x201
 [<ffffffff8166375a>] md_make_request+0xfa/0x215
 [<ffffffff810f874e>] ? __wake_up+0x3f/0x48
 [<ffffffff813ca63c>] generic_make_request+0x99/0xda
 [<ffffffff813ca770>] submit_bio+0xf3/0xfe
 [<ffffffff811f4c1c>] ext4_io_submit+0x24/0x43
 [<ffffffff811f46f7>] ext4_writepages+0x8bc/0xa07
 [<ffffffff813cb9e8>] ? blk_finish_plug+0x13/0x34
 [<ffffffff8113cf5f>] do_writepages+0x1b/0x24
 [<ffffffff811abb30>] __writeback_single_inode+0x40/0xf3
 [<ffffffff811ac99c>] writeback_sb_inodes+0x21d/0x391
 [<ffffffff8118e6ba>] ? put_super+0x2c/0x31
 [<ffffffff811acb83>] __writeback_inodes_wb+0x73/0xb4
 [<ffffffff811acccd>] wb_writeback+0x109/0x19c
 [<ffffffff8113d0f1>] ? bdi_dirty_limit+0x2c/0x89
 [<ffffffff811acea9>] wb_do_writeback+0x149/0x16d
 [<ffffffff811acf3a>] bdi_writeback_workfn+0x6d/0x16f
 [<ffffffff81310708>] ? finish_ordered_fn+0x10/0x12
 [<ffffffff8132a747>] ? normal_work_helper+0xcc/0x18e
 [<ffffffff810d9977>] ? pwq_dec_nr_in_flight+0xe3/0xec
 [<ffffffff810d9bd3>] process_one_work+0x253/0x368
 [<ffffffff810d9ed2>] worker_thread+0x1ea/0x343
 [<ffffffff810d9ce8>] ? process_one_work+0x368/0x368
 [<ffffffff810df1ff>] kthread+0xc9/0xd1
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
 [<ffffffff818842cc>] ret_from_fork+0x7c/0xb0
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
kworker/u82:2   D 0000000000000000     0 35547      2 0x00080000
Workqueue: btrfs-submit normal_work_helper
 0000000000000000 0000000000000000 0000000000000008 ffff881fd0ec0040
 ffff881fd0ec0070 0000000000000000 0000000091827364 ffff883eec757d30
 ffff883eec757d30 ffff883eec757d40 ffff883eec757d40 ffff883fd157a0c0
Call Trace:
 [<ffffffff813241b1>] ? pending_bios_fn+0x10/0x12
 [<ffffffff8132a747>] ? normal_work_helper+0xcc/0x18e
 [<ffffffff810d9bd3>] ? process_one_work+0x253/0x368
 [<ffffffff810d9ed2>] ? worker_thread+0x1ea/0x343
 [<ffffffff810d9ce8>] ? process_one_work+0x368/0x368
 [<ffffffff810df1ff>] ? kthread+0xc9/0xd1
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
 [<ffffffff818842cc>] ? ret_from_fork+0x7c/0xb0
 [<ffffffff810df136>] ? kthread_freezable_should_stop+0x5b/0x5b
php-fpm         D ffffffff81134170     0 16086  12386 0x00000000
 ffff881f474c3b28 0000000000000002 0000001400000010 ffff881f474c3a48
 ffff881f474c2010 ffff881f474c3b28 0000000000011bc0 ffff881f7184f460
 0000000000011bc0 0000000000011bc0 ffff881fd28bec10 ffff881f7184f460
Call Trace:
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff8118e25b>] ? __sb_end_write+0x2d/0x5c
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff8104072d>] ? read_tsc+0x9/0x1b
 [<ffffffff81134170>] ? __lock_page+0x68/0x68
 [<ffffffff81880c2a>] schedule+0x6e/0x70
 [<ffffffff81880cbf>] io_schedule+0x93/0xd7
 [<ffffffff81134179>] sleep_on_page+0x9/0xd
 [<ffffffff81880fd3>] __wait_on_bit_lock+0x43/0x8f
 [<ffffffff81134169>] __lock_page+0x61/0x68
 [<ffffffff810f84f3>] ? wake_atomic_t_function+0x28/0x28
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff81151a47>] do_wp_page+0x1e4/0x79a
 [<ffffffff811969b1>] ? path_lookupat+0x5db/0x64d
 [<ffffffff81153584>] handle_mm_fault+0xbbb/0xc84
 [<ffffffff811991d6>] ? final_putname+0x33/0x37
 [<ffffffff81199344>] ? user_path_at_empty+0x5e/0x8f
 [<ffffffff810f99ed>] ? cpuacct_account_field+0x55/0x5e
 [<ffffffff8106b08c>] __do_page_fault+0x3bb/0x3e2
 [<ffffffff811061e9>] ? rcu_eqs_enter+0x70/0x83
 [<ffffffff8110620a>] ? rcu_user_enter+0xe/0x10
 [<ffffffff810f99ed>] ? cpuacct_account_field+0x55/0x5e
 [<ffffffff810ebcfa>] ? account_user_time+0x6e/0x97
 [<ffffffff810ebd70>] ? vtime_account_user+0x4d/0x52
 [<ffffffff8106b0f7>] do_page_fault+0x44/0x61
 [<ffffffff81883e38>] page_fault+0x28/0x30

And then the php-fpm process is present 14 more times with the same
backtrace. In total, the number of btrfs calls is pretty much in the
following state:

$ grep btrfs blocked.txt | sort
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff812e9c53>] ? btrfs_block_rsv_check+0x55/0x61
 [<ffffffff813020c1>] ? btrfs_write_marked_extents+0x83/0xd1
 [<ffffffff8130216b>] ? btrfs_write_and_wait_transaction+0x5c/0x8a
 [<ffffffff81302ee2>] ? btrfs_commit_transaction+0x68b/0x87c
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff81303380>] ? __btrfs_end_transaction+0x2ad/0x2d1
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee2a>] btrfs_page_mkwrite+0xb0/0x2c2
 [<ffffffff8130ee69>] btrfs_page_mkwrite+0xef/0x2c2
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff813143a5>] __btrfs_buffered_write+0x214/0x482
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff81314a2a>] btrfs_file_aio_write+0x417/0x507
 [<ffffffff81324f22>] ? __btrfs_map_block+0xd6f/0xd89
 [<ffffffff813255b6>] ? btrfs_map_bio+0x3cd/0x440
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
 [<ffffffff81348277>] ? __btrfs_release_delayed_node+0x184/0x1e2
Workqueue: btrfs-submit normal_work_helper
btrfs-transacti D 000000000000000e     0  2483      2 0x00080008

I can send the whole file, if someone is interested.

Appreciate any feedback.

Cheers,
Alin.
