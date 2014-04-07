Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:50234 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190AbaDGQMT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 12:12:19 -0400
Received: by mail-oa0-f45.google.com with SMTP id eb12so6806595oac.4
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Apr 2014 09:12:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com>
References: <CAAcaxmWqrLUwbvmsyE+3zLLP1jSVZXGASRvN-D-BLaJp4WnpLQ@mail.gmail.com>
	<5342C944.2020000@fb.com>
	<CAAcaxmWEDa+jS8n4LZKdE_ZXFVAoOgACDseQs0_fViYdfRHShg@mail.gmail.com>
	<CAAcaxmURiYRV7Rszb9UQuxSCgR+ZRTu2f+CxVhS4x7qHU2wb4A@mail.gmail.com>
Date: Tue, 8 Apr 2014 00:12:18 +0800
Message-ID: <CAAcaxmWTTz-KRyXtQ-Hgn=J-1uERgnzM1H4g0m4pp1q68RYP9Q@mail.gmail.com>
Subject: Re: Is this a race bug when releasing eb?
From: ylet ylet <levin.front@gmail.com>
To: jbacik <jbacik@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

======================This is the IOzone test bug (can be reliably
reproduced)==================================

Btrfs falls into hang when I ran iozone test with the following configuration:

./iozone -s 8g -i 0 -i 2 -i 1 -t 4 -r 4k -+w 50 -+y 20 -+C 60 -F
/mnt/btrfs/test1 /mnt/btrfs/test2 /mnt/btrfs/test3 /mnt/btrfs/test

The bug can be very easily triggered when running this test in my PC.
My PC equipped with 4-core intel I5 cpu, 8G memory and a SSD. dmesg
result is as below, hoping to help you guys:

[23379.435980] INFO: task btrfs-flush_del:1971 blocked for more than
120 seconds.
[23379.435997]       Tainted: G           O 3.14.0-rc2 #2
[23379.436006] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.436019] btrfs-flush_del D 0000000000000000     0  1971      2 0x00000000
[23379.436024]  ffff88002eb9dd28 0000000000000046 ffff88002eb9dcc8
0000000000000296
[23379.436029]  ffff8800d9946100 00000000000133c0 ffff88002eb9dfd8
00000000000133c0
[23379.436033]  ffff880064cb0000 ffff8800d9946100 ffff88002eb9dd38
ffff880058b7ccc0
[23379.436037] Call Trace:
[23379.436047]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.436068]  [<ffffffffa033d825>]
btrfs_start_ordered_extent+0x75/0x120 [btrfs]
[23379.436073]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.436089]  [<ffffffffa033d8f9>]
btrfs_run_ordered_extent_work+0x29/0x40 [btrfs]
[23379.436106]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.436120]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.436124]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.436129]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436133]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.436137]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436140] INFO: task btrfs-transacti:1974 blocked for more than
120 seconds.
[23379.436151]       Tainted: G           O 3.14.0-rc2 #2
[23379.436161] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.436174] btrfs-transacti D ffffffff8180fa60     0  1974      2 0x00000000
[23379.436177]  ffff8800d3fad9e8 0000000000000046 ffff8800d3fad9d8
0000000000000292
[23379.436181]  ffff8802145bc8c0 00000000000133c0 ffff8800d3fadfd8
00000000000133c0
[23379.436185]  ffff880215169840 ffff8802145bc8c0 ffff8800d3fad9f8
ffff88008b406b98
[23379.436188] Call Trace:
[23379.436193]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.436206]  [<ffffffffa035b52d>] btrfs_tree_read_lock+0x8d/0x100 [btrfs]
[23379.436210]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.436220]  [<ffffffffa02fbbcb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[23379.436230]  [<ffffffffa0300ffb>] btrfs_search_slot+0x5bb/0x9d0 [btrfs]
[23379.436235]  [<ffffffff816b9ace>] ? _raw_spin_unlock+0xe/0x10
[23379.436246]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.436257]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.436269]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.436281]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.436294]  [<ffffffffa0323fe9>] btrfs_commit_transaction+0x59/0xa00 [btrfs]
[23379.436299]  [<ffffffff8105cdf0>] ? call_timer_fn+0x160/0x160
[23379.436311]  [<ffffffffa0321f55>] transaction_kthread+0x1d5/0x250 [btrfs]
[23379.436323]  [<ffffffffa0321d80>] ? open_ctree+0x2220/0x2220 [btrfs]
[23379.436327]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.436331]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436335]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.436338]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436341] INFO: task kworker/u8:1:2041 blocked for more than 120 seconds.
[23379.436351]       Tainted: G           O 3.14.0-rc2 #2
[23379.436362] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.436374] kworker/u8:1    D ffffffff8180fa60     0  2041      2 0x00000000
[23379.436381] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-1)
[23379.436384]  ffff8801c86f18a8 0000000000000046 ffff880202afd468
0000000000000292
[23379.436387]  ffff88002eb948c0 00000000000133c0 ffff8801c86f1fd8
00000000000133c0
[23379.436391]  ffff880215168000 ffff88002eb948c0 ffff8801c86f18b8
ffff88008b406b98
[23379.436394] Call Trace:
[23379.436398]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.436413]  [<ffffffffa035b91d>] btrfs_tree_lock+0xad/0x1f0 [btrfs]
[23379.436416]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.436431]  [<ffffffffa0344fbe>] btree_write_cache_pages+0x25e/0x800 [btrfs]
[23379.436444]  [<ffffffffa031b671>] btree_writepages+0x71/0x80 [btrfs]
[23379.436449]  [<ffffffff8113ebb3>] do_writepages+0x23/0x40
[23379.436452]  [<ffffffff811bbda5>] __writeback_single_inode+0x45/0x2a0
[23379.436456]  [<ffffffff8108bf73>] ? check_preempt_wakeup+0x163/0x260
[23379.436460]  [<ffffffff811bd17d>] writeback_sb_inodes+0x23d/0x3e0
[23379.436463]  [<ffffffff811bd3be>] __writeback_inodes_wb+0x9e/0xd0
[23379.436467]  [<ffffffff811bd67b>] wb_writeback+0x28b/0x330
[23379.436471]  [<ffffffff811c0699>] bdi_writeback_workfn+0x209/0x460
[23379.436476]  [<ffffffff8106c1bd>] process_one_work+0x17d/0x4a0
[23379.436480]  [<ffffffff8106d59b>] worker_thread+0x11b/0x370
[23379.436484]  [<ffffffff8106d480>] ? manage_workers.isra.21+0x2e0/0x2e0
[23379.436488]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.436492]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436496]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.436500]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436503] INFO: task btrfs-endio-wri:2177 blocked for more than
120 seconds.
[23379.436514]       Tainted: G           O 3.14.0-rc2 #2
[23379.436524] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.436537] btrfs-endio-wri D ffffffff8180fa60     0  2177      2 0x00000000
[23379.436540]  ffff880024165928 0000000000000046 ffff8800241658e8
0000000000000296
[23379.436543]  ffff8802025d8000 00000000000133c0 ffff880024165fd8
00000000000133c0
[23379.436547]  ffff88021516b080 ffff8802025d8000 ffff880024165938
ffff8800c1151090
[23379.436550] Call Trace:
[23379.436554]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.436568]  [<ffffffffa035b91d>] btrfs_tree_lock+0xad/0x1f0 [btrfs]
[23379.436571]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.436582]  [<ffffffffa0301261>] btrfs_search_slot+0x821/0x9d0 [btrfs]
[23379.436592]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.436603]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.436615]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.436629]  [<ffffffffa033f8fa>] ? merge_state+0x6a/0x150 [btrfs]
[23379.436641]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.436652]  [<ffffffffa030b47c>] ?
btrfs_delayed_refs_qgroup_accounting+0xbc/0x100 [btrfs]
[23379.436665]  [<ffffffffa0324c5f>] __btrfs_end_transaction+0x27f/0x390 [btrfs]
[23379.436677]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.436690]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.436703]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.436717]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.436730]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.436733]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.436737]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436741]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.436745]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.436748] INFO: task iozone:2406 blocked for more than 120 seconds.
[23379.436758]       Tainted: G           O 3.14.0-rc2 #2
[23379.436768] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.436811] iozone          D 0000000000000000     0  2406   2165 0x00000000
[23379.436814]  ffff8800a62778e8 0000000000000082 ffff8800a6277888
ffffffff8113b08e
[23379.436818]  ffff8800cc909840 00000000000133c0 ffff8800a6277fd8
00000000000133c0
[23379.436821]  ffff880047046100 ffff8800cc909840 ffff88012df4a800
ffff880058b7cdd8
[23379.436825] Call Trace:
[23379.436829]  [<ffffffff8113b08e>] ? __free_memcg_kmem_pages+0xe/0x10
[23379.436833]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.436836]  [<ffffffff816b5a2d>] schedule_timeout+0x1bd/0x220
[23379.436851]  [<ffffffffa033ccf2>] ?
btrfs_put_ordered_extent+0xf2/0x110 [btrfs]
[23379.436855]  [<ffffffff816b7909>] wait_for_completion+0xa9/0x110
[23379.436859]  [<ffffffff81084930>] ? try_to_wake_up+0x2c0/0x2c0
[23379.436872]  [<ffffffffa033d2de>]
btrfs_wait_ordered_extents+0x1ee/0x240 [btrfs]
[23379.436884]  [<ffffffffa033d43f>]
btrfs_wait_ordered_roots+0x10f/0x1c0 [btrfs]
[23379.436895]  [<ffffffffa030c585>] reserve_metadata_bytes+0x435/0x970 [btrfs]
[23379.436909]  [<ffffffffa033f771>] ? free_extent_state+0xb1/0x120 [btrfs]
[23379.436921]  [<ffffffffa030d9bd>]
btrfs_delalloc_reserve_metadata+0x16d/0x4a0 [btrfs]
[23379.436935]  [<ffffffffa0335d4d>] __btrfs_buffered_write+0x15d/0x5a0 [btrfs]
[23379.436939]  [<ffffffff81054926>] ? current_fs_time+0x16/0x60
[23379.436952]  [<ffffffffa03363a5>] btrfs_file_aio_write+0x215/0x5c0 [btrfs]
[23379.436956]  [<ffffffff81089e25>] ? set_next_entity+0xa5/0xc0
[23379.436960]  [<ffffffff8108af51>] ? update_curr+0x141/0x200
[23379.436964]  [<ffffffff81193afa>] do_sync_write+0x5a/0x90
[23379.436968]  [<ffffffff811945db>] vfs_write+0xcb/0x1f0
[23379.436972]  [<ffffffff81194ad2>] SyS_write+0x52/0xa0
[23379.436977]  [<ffffffff816c2412>] system_call_fastpath+0x16/0x1b
[23379.436980] INFO: task btrfs-endio-wri:2409 blocked for more than
120 seconds.
[23379.437020]       Tainted: G           O 3.14.0-rc2 #2
[23379.437044] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.437086] btrfs-endio-wri D ffffffff8180fa60     0  2409      2 0x00000000
[23379.437089]  ffff88004834d2a8 0000000000000046 0000000000000000
0000000000000292
[23379.437093]  ffff880064cb1840 00000000000133c0 ffff88004834dfd8
00000000000133c0
[23379.437096]  ffff880215169840 ffff880064cb1840 ffff88004834d2b8
ffff8800d77866a0
[23379.437100] Call Trace:
[23379.437103]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.437117]  [<ffffffffa035b8d5>] btrfs_tree_lock+0x65/0x1f0 [btrfs]
[23379.437121]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.437131]  [<ffffffffa02fcdea>] push_nodes_for_insert+0xea/0x4d0 [btrfs]
[23379.437141]  [<ffffffffa02fe198>] ? key_search+0x88/0xb0 [btrfs]
[23379.437151]  [<ffffffffa02fdf4c>] ? comp_keys+0x2c/0x30 [btrfs]
[23379.437161]  [<ffffffffa02fd251>] split_node+0x81/0x4b0 [btrfs]
[23379.437173]  [<ffffffffa031e1d5>] ? btrfs_buffer_uptodate+0x65/0x80 [btrfs]
[23379.437183]  [<ffffffffa02f95ad>] ? reada_for_balance+0xfd/0x1d0 [btrfs]
[23379.437193]  [<ffffffffa0300d36>] btrfs_search_slot+0x2f6/0x9d0 [btrfs]
[23379.437197]  [<ffffffff816b8896>] ? down_write+0x16/0x40
[23379.437208]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.437218]  [<ffffffffa0302b15>] btrfs_insert_item+0x65/0xe0 [btrfs]
[23379.437230]  [<ffffffffa03135f8>]
btrfs_create_pending_block_groups+0xf8/0x170 [btrfs]
[23379.437242]  [<ffffffffa0324aaa>] __btrfs_end_transaction+0xca/0x390 [btrfs]
[23379.437254]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.437265]  [<ffffffffa030ff83>] find_free_extent+0xa03/0xb60 [btrfs]
[23379.437277]  [<ffffffffa03101a2>] btrfs_reserve_extent+0xa2/0x130 [btrfs]
[23379.437288]  [<ffffffffa03116e3>] btrfs_alloc_free_block+0x103/0x4b0 [btrfs]
[23379.437298]  [<ffffffffa03000ed>] split_leaf+0x12d/0x7b0 [btrfs]
[23379.437309]  [<ffffffffa03013a4>] btrfs_search_slot+0x964/0x9d0 [btrfs]
[23379.437319]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.437330]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.437341]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.437355]  [<ffffffffa033f8fa>] ? merge_state+0x6a/0x150 [btrfs]
[23379.437367]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.437378]  [<ffffffffa030b47c>] ?
btrfs_delayed_refs_qgroup_accounting+0xbc/0x100 [btrfs]
[23379.437390]  [<ffffffffa0324c5f>] __btrfs_end_transaction+0x27f/0x390 [btrfs]
[23379.437402]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.437414]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.437426]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.437440]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.437454]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.437457]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.437461]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.437465]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.437469]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.437472] INFO: task btrfs-endio-wri:2410 blocked for more than
120 seconds.
[23379.437512]       Tainted: G           O 3.14.0-rc2 #2
[23379.437536] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.437578] btrfs-endio-wri D 0000000000000000     0  2410      2 0x00000000
[23379.437581]  ffff8800232f1928 0000000000000046 ffff8800232f18e8
0000000000000296
[23379.437584]  ffff880064cb3080 00000000000133c0 ffff8800232f1fd8
00000000000133c0
[23379.437588]  ffff8802025d8000 ffff880064cb3080 ffff8800232f1938
ffff8800c1151090
[23379.437591] Call Trace:
[23379.437595]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.437608]  [<ffffffffa035b91d>] btrfs_tree_lock+0xad/0x1f0 [btrfs]
[23379.437612]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.437622]  [<ffffffffa0301261>] btrfs_search_slot+0x821/0x9d0 [btrfs]
[23379.437632]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.437643]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.437655]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.437669]  [<ffffffffa033f8fa>] ? merge_state+0x6a/0x150 [btrfs]
[23379.437681]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.437692]  [<ffffffffa030b47c>] ?
btrfs_delayed_refs_qgroup_accounting+0xbc/0x100 [btrfs]
[23379.437704]  [<ffffffffa0324c5f>] __btrfs_end_transaction+0x27f/0x390 [btrfs]
[23379.437716]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.437729]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.437741]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.437754]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.437767]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.437771]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.437775]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.437779]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.437783]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.437785] INFO: task btrfs-endio-wri:2411 blocked for more than
120 seconds.
[23379.437826]       Tainted: G           O 3.14.0-rc2 #2
[23379.437850] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.437892] btrfs-endio-wri D ffffffff8180fa60     0  2411      2 0x00000000
[23379.437895]  ffff8800177dfa58 0000000000000046 ffff88020a1a6c08
0000000000000296
[23379.437898]  ffff880064cb0000 00000000000133c0 ffff8800177dffd8
00000000000133c0
[23379.437902]  ffffffff81c104a0 ffff880064cb0000 ffff8800177dfa68
ffff88008b406b98
[23379.437905] Call Trace:
[23379.437909]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.437922]  [<ffffffffa035b52d>] btrfs_tree_read_lock+0x8d/0x100 [btrfs]
[23379.437925]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.437935]  [<ffffffffa02fbbcb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[23379.437945]  [<ffffffffa0300ffb>] btrfs_search_slot+0x5bb/0x9d0 [btrfs]
[23379.437955]  [<ffffffffa02f8ee0>] ? leaf_space_used+0xe0/0x110 [btrfs]
[23379.437965]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.437975]  [<ffffffffa0302b15>] btrfs_insert_item+0x65/0xe0 [btrfs]
[23379.437987]  [<ffffffffa03135f8>]
btrfs_create_pending_block_groups+0xf8/0x170 [btrfs]
[23379.437999]  [<ffffffffa0324aaa>] __btrfs_end_transaction+0xca/0x390 [btrfs]
[23379.438011]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.438023]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.438035]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.438048]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.438061]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.438065]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.438068]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.438072]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.438076]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.438079] INFO: task btrfs-endio-wri:2412 blocked for more than
120 seconds.
[23379.438120]       Tainted: G           O 3.14.0-rc2 #2
[23379.438144] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.438185] btrfs-endio-wri D ffffffff8180fa60     0  2412      2 0x00000000
[23379.438188]  ffff880024791908 0000000000000046 ffff8800247918d8
0000000000000292
[23379.438192]  ffff88002e981840 00000000000133c0 ffff880024791fd8
00000000000133c0
[23379.438195]  ffff880215168000 ffff88002e981840 ffff880024791918
ffff88008b406b98
[23379.438199] Call Trace:
[23379.438203]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.438215]  [<ffffffffa035b52d>] btrfs_tree_read_lock+0x8d/0x100 [btrfs]
[23379.438218]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.438228]  [<ffffffffa02fbbcb>] btrfs_read_lock_root_node+0x3b/0x50 [btrfs]
[23379.438238]  [<ffffffffa0300ffb>] btrfs_search_slot+0x5bb/0x9d0 [btrfs]
[23379.438243]  [<ffffffff811845c5>] ? kmem_cache_alloc_trace+0x35/0x160
[23379.438253]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.438264]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.438278]  [<ffffffffa033b224>] ? btrfs_get_token_32+0x64/0xf0 [btrfs]
[23379.438290]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.438304]  [<ffffffffa033f8fa>] ? merge_state+0x6a/0x150 [btrfs]
[23379.438316]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.438327]  [<ffffffffa030b47c>] ?
btrfs_delayed_refs_qgroup_accounting+0xbc/0x100 [btrfs]
[23379.438339]  [<ffffffffa0324c5f>] __btrfs_end_transaction+0x27f/0x390 [btrfs]
[23379.438351]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.438363]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.438375]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.438388]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.438401]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.438404]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.438408]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.438412]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.438416]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.438419] INFO: task btrfs-endio-wri:2413 blocked for more than
120 seconds.
[23379.438459]       Tainted: G           O 3.14.0-rc2 #2
[23379.438483] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[23379.438525] btrfs-endio-wri D ffffffff8180fa60     0  2413      2 0x00000000
[23379.438528]  ffff88003b1ad928 0000000000000046 ffff88003b1ad8e8
0000000000000296
[23379.438531]  ffff880047046100 00000000000133c0 ffff88003b1adfd8
00000000000133c0
[23379.438535]  ffff880215168000 ffff880047046100 ffff88003b1ad938
ffff8800c1151090
[23379.438539] Call Trace:
[23379.438542]  [<ffffffff816b67f9>] schedule+0x29/0x70
[23379.438555]  [<ffffffffa035b985>] btrfs_tree_lock+0x115/0x1f0 [btrfs]
[23379.438558]  [<ffffffff81095200>] ? __init_waitqueue_head+0x40/0x40
[23379.438569]  [<ffffffffa0301261>] btrfs_search_slot+0x821/0x9d0 [btrfs]
[23379.438579]  [<ffffffffa0302a58>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[23379.438590]  [<ffffffffa0309c9a>]
alloc_reserved_file_extent+0x9a/0x2e0 [btrfs]
[23379.438602]  [<ffffffffa0310893>]
__btrfs_run_delayed_refs+0x623/0x1210 [btrfs]
[23379.438615]  [<ffffffffa033f969>] ? merge_state+0xd9/0x150 [btrfs]
[23379.438628]  [<ffffffffa033f969>] ? merge_state+0xd9/0x150 [btrfs]
[23379.438640]  [<ffffffffa03136e6>] btrfs_run_delayed_refs+0x76/0x2b0 [btrfs]
[23379.438651]  [<ffffffffa030b47c>] ?
btrfs_delayed_refs_qgroup_accounting+0xbc/0x100 [btrfs]
[23379.438663]  [<ffffffffa0324c5f>] __btrfs_end_transaction+0x27f/0x390 [btrfs]
[23379.438675]  [<ffffffffa0324da0>] btrfs_end_transaction+0x10/0x20 [btrfs]
[23379.438687]  [<ffffffffa032cfbb>] btrfs_finish_ordered_io+0xcb/0x500 [btrfs]
[23379.438699]  [<ffffffffa032d405>] finish_ordered_fn+0x15/0x20 [btrfs]
[23379.438712]  [<ffffffffa03531ea>] worker_loop+0x16a/0x570 [btrfs]
[23379.438725]  [<ffffffffa0353080>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[23379.438728]  [<ffffffff81074191>] kthread+0xe1/0x100
[23379.438732]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0
[23379.438736]  [<ffffffff816c236c>] ret_from_fork+0x7c/0xb0
[23379.438740]  [<ffffffff810740b0>] ? flush_kthread_worker+0xe0/0xe0

==========The following is my postmark config (Iam not sure if it can
be reliably reproduced because i only ran once)=======
set location /mnt/btrfs
set size 100000 5000000
#set size 1000000
#set size 4096
set transactions 5000000
#set bias read 10
set number 1000000
run
quit

2014-04-08 0:01 GMT+08:00 ylet ylet <levin.front@gmail.com>:
> hi Josef
>
> Thanks, I got it. But i still have no idea to reliably reproduce it.
> This bug-on is triggered when I ran POSTMARK test lasting two days.
>
> BTW, can you reproduce the bug reported by email with title of "btrfs
> hung with iozone test under linux kernel 3.14." The reported bug can
> be reliably reproduced in my environment.
>
> 2014-04-07 23:50 GMT+08:00 Josef Bacik <jbacik@fb.com>:
>> On 04/07/2014 11:45 AM, ylet ylet wrote:
>>>
>>> Assuming thread 1 (may be VFS want to release the page) wants to
>>> release a CLEAN page and thus the eb attaching the page.
>>> and thread 2 wants to access the eb and cow the eb.
>>>
>>> Thread 1
>>>                 Thread 2
>>>
>>> btree_releasepage
>>>
>>> try_release_extent_buffer
>>>
>>> release_extent_buffer
>>> ->if (atomic_dec_and_test(&eb->refs)) {
>>> ->spin_unlock(&eb->refs_lock);
>>>   -------switch to thread 2 here------
>>>
>>>                 read_block_for_search
>>>
>>>                  btrfs_find_tree_block
>>>
>>>       radix_tree_lookup && atomic_inc_not_zero
>>>
>>
>> atomic_inc_not_zero would return 0 here because we've dropped the last
>> buffer for this, that is how we protect against this problem.  How reliably
>> are you able to reproduce this bug?  Cause I'd love to find it if you can
>> reproduce reliably.  Thanks,
>>
>> Josef
