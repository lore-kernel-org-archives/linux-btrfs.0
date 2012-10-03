Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:37604 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827Ab2JCVak (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Oct 2012 17:30:40 -0400
Message-ID: <506CAE5E.40806@sandia.gov>
Date: Wed, 3 Oct 2012 15:30:06 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
cc: "Josef Bacik" <jbacik@fusionio.com>
Subject: btrfs lockdep splat for fs_info->chunk_mutex
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been testing what I believe to be the btrfs patches being queued
up for 3.7, and have been having trouble with stalled writes.
(See, e.g., http://www.spinics.net/lists/linux-btrfs/msg19171.html)

With CONFIG_PROVE_LOCKING=y I was able to collect the following
lockdep splat, which I hope is related to my stalls.

The kernel is from the master branch of Josef Bacik's btrfs-next
tree, and the load is heavy writing from Ceph OSDs.

Please let me know if there is anything more I can do to help
resolve this.

[ 1369.608721]
[ 1369.610215] =============================================
[ 1369.615602] [ INFO: possible recursive locking detected ]
[ 1369.620990] 3.6.0-00115-g2ff1260 #311 Not tainted
[ 1369.625688] ---------------------------------------------
[ 1369.631076] ceph-osd/88953 is trying to acquire lock:
[ 1369.636122]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa05514f3>] do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.645815]
[ 1369.645815] but task is already holding lock:
[ 1369.651636]  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa05514f3>] do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.661333]
[ 1369.661333] other info that might help us debug this:
[ 1369.667843]  Possible unsafe locking scenario:
[ 1369.667843]
[ 1369.673748]        CPU0
[ 1369.676202]        ----
[ 1369.678646]   lock(&fs_info->chunk_mutex);
[ 1369.682783]   lock(&fs_info->chunk_mutex);
[ 1369.686917]
[ 1369.686917]  *** DEADLOCK ***
[ 1369.686917]
[ 1369.692821]  May be due to missing lock nesting notation
[ 1369.692821]
[ 1369.699595] 4 locks held by ceph-osd/88953:
[ 1369.703776]  #0:  (sb_writers#7){.+.+.+}, at: [<ffffffffa0579d44>] btrfs_file_aio_write+0x64/0x320 [btrfs]
[ 1369.713647]  #1:  (&sb->s_type->i_mutex_key#9){+.+.+.}, at: [<ffffffffa0579d4e>] btrfs_file_aio_write+0x6e/0x320 [btrfs]
[ 1369.724666]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa0568724>] start_transaction+0x1c4/0x490 [btrfs]
[ 1369.734186]  #3:  (&fs_info->chunk_mutex){+.+...}, at: [<ffffffffa05514f3>] do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.744345]
[ 1369.744345] stack backtrace:
[ 1369.748707] Pid: 88953, comm: ceph-osd Not tainted 3.6.0-00115-g2ff1260 #311
[ 1369.755740] Call Trace:
[ 1369.758213]  [<ffffffff810a1a99>] print_deadlock_bug+0xe9/0x100
[ 1369.764124]  [<ffffffff810a3806>] validate_chain+0x596/0x750
[ 1369.769778]  [<ffffffff8107929f>] ? finish_task_switch+0x3f/0x110
[ 1369.775867]  [<ffffffff810a3d9d>] __lock_acquire+0x3dd/0x480
[ 1369.781532]  [<ffffffff810a3f69>] lock_acquire+0x129/0x190
[ 1369.787052]  [<ffffffffa05514f3>] ? do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.793586]  [<ffffffff814d13cd>] __mutex_lock_common+0x5d/0x3a0
[ 1369.799618]  [<ffffffffa05514f3>] ? do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.806183]  [<ffffffffa05514f3>] ? do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.812702]  [<ffffffff814d187a>] mutex_lock_nested+0x4a/0x60
[ 1369.818467]  [<ffffffffa05514f3>] do_chunk_alloc+0x183/0x290 [btrfs]
[ 1369.824853]  [<ffffffffa05571bc>] find_free_extent+0xa9c/0xbc0 [btrfs]
[ 1369.831394]  [<ffffffffa05499e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1369.838920]  [<ffffffffa0557362>] btrfs_reserve_extent+0x82/0x1e0 [btrfs]
[ 1369.845731]  [<ffffffffa0557545>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1369.852717]  [<ffffffffa0542a7a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1369.859354]  [<ffffffffa059b3a3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
[ 1369.866843]  [<ffffffffa054347d>] btrfs_cow_block+0x18d/0x2d0 [btrfs]
[ 1369.873289]  [<ffffffffa05466e8>] btrfs_search_slot+0x368/0x720 [btrfs]
[ 1369.879910]  [<ffffffffa05474dd>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1369.887026]  [<ffffffff81165c63>] ? kmem_cache_alloc+0xd3/0x1b0
[ 1369.892965]  [<ffffffffa058c5d5>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
[ 1369.899931]  [<ffffffffa0591017>] __btrfs_alloc_chunk+0x6e7/0x790 [btrfs]
[ 1369.906743]  [<ffffffffa059111e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1369.913204]  [<ffffffffa05512b1>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1369.920022]  [<ffffffffa055158e>] do_chunk_alloc+0x21e/0x290 [btrfs]
[ 1369.926409]  [<ffffffffa0551e9c>] btrfs_check_data_free_space+0x13c/0x2f0 [btrfs]
[ 1369.933917]  [<ffffffffa0553a20>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[ 1369.941335]  [<ffffffffa05799be>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
[ 1369.948408]  [<ffffffffa0579ee9>] btrfs_file_aio_write+0x209/0x320 [btrfs]
[ 1369.955299]  [<ffffffffa0579ce0>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[ 1369.962334]  [<ffffffff81171894>] do_sync_readv_writev+0x94/0xe0
[ 1369.968333]  [<ffffffff811727a3>] do_readv_writev+0xe3/0x1e0
[ 1369.973983]  [<ffffffff81174448>] ? fget_light+0x388/0x3e0
[ 1369.979459]  [<ffffffff811728e6>] vfs_writev+0x46/0x60
[ 1369.984585]  [<ffffffff81172a01>] sys_writev+0x51/0xb0
[ 1369.989715]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1559.036678] INFO: task btrfs-endio-wri:75602 blocked for more than 120 seconds.
[ 1559.043993] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.051872] btrfs-endio-wri D ffff8802e7440250     0 75602      2 0x00000000
[ 1559.059095]  ffff8805e2f87a80 0000000000000046 0000000000000282 ffff8805e2f87fd8
[ 1559.066634]  ffff8805e2f86000 ffff8805e2f86010 ffff8805e2f86000 ffff8805e2f86000
[ 1559.074240]  ffff8805e2f87fd8 ffff8805e2f86000 ffff88098749bea0 ffff880506d95df0
[ 1559.081786] Call Trace:
[ 1559.084252]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1559.089261]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.096062]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1559.101478]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1559.108124]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1559.114669]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1559.121819]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1559.128425]  [<ffffffff81164a9b>] ? kmem_cache_alloc_trace+0x5b/0x1b0
[ 1559.134890]  [<ffffffffa055b104>] btrfs_lookup_csum+0x84/0x180 [btrfs]
[ 1559.141422]  [<ffffffff81165c63>] ? kmem_cache_alloc+0xd3/0x1b0
[ 1559.147385]  [<ffffffffa055bf50>] btrfs_csum_file_blocks+0xe0/0x6d0 [btrfs]
[ 1559.154382]  [<ffffffffa057d2ab>] ? unpin_extent_cache+0xeb/0x120 [btrfs]
[ 1559.161222]  [<ffffffffa056abe9>] add_pending_csums+0x49/0x70 [btrfs]
[ 1559.167681]  [<ffffffffa0572992>] btrfs_finish_ordered_io+0x392/0x4d0 [btrfs]
[ 1559.174817]  [<ffffffff814d4700>] ? _raw_spin_unlock_irq+0x30/0x50
[ 1559.181027]  [<ffffffffa0572ae5>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1559.187507]  [<ffffffffa0593442>] worker_loop+0x1a2/0x410 [btrfs]
[ 1559.193628]  [<ffffffffa05932a0>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[ 1559.201226]  [<ffffffff8106aa24>] kthread+0xb4/0xc0
[ 1559.206113]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1559.212738]  [<ffffffff814de924>] kernel_thread_helper+0x4/0x10
[ 1559.218669]  [<ffffffff814d4ad9>] ? retint_restore_args+0xe/0xe
[ 1559.224608]  [<ffffffff8106a970>] ? __init_kthread_worker+0x70/0x70
[ 1559.230895]  [<ffffffff814de920>] ? gs_change+0xb/0xb
[ 1559.236380] INFO: lockdep is turned off.
[ 1559.240519] INFO: task btrfs-transacti:75608 blocked for more than 120 seconds.
[ 1559.247816] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.255641] btrfs-transacti D ffff8802cba07780     0 75608      2 0x00000000
[ 1559.262745]  ffff8804712035b0 0000000000000046 0000000000000286 ffff880471203fd8
[ 1559.270249]  ffff880471202000 ffff880471202010 ffff880471202000 ffff880471202000
[ 1559.277760]  ffff880471203fd8 ffff880471202000 ffff880624610000 ffff88034b571f50
[ 1559.285289] Call Trace:
[ 1559.287752]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1559.292757]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.299544]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1559.304975]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1559.311600]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1559.318142]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1559.325293]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1559.331933]  [<ffffffffa057cdf7>] ? free_extent_map+0x87/0x90 [btrfs]
[ 1559.338403]  [<ffffffffa055a9fd>] btrfs_lookup_file_extent+0x3d/0x40 [btrfs]
[ 1559.345481]  [<ffffffffa057aa11>] __btrfs_drop_extents+0x171/0xad0 [btrfs]
[ 1559.352356]  [<ffffffff81165c63>] ? kmem_cache_alloc+0xd3/0x1b0
[ 1559.358297]  [<ffffffffa057bd73>] btrfs_drop_extents+0x73/0xa0 [btrfs]
[ 1559.364834]  [<ffffffffa056f225>] cow_file_range_inline+0xe5/0x1c0 [btrfs]
[ 1559.371732]  [<ffffffffa0585c1c>] ? test_range_bit+0x17c/0x190 [btrfs]
[ 1559.378284]  [<ffffffffa056f472>] cow_file_range+0x172/0x4b0 [btrfs]
[ 1559.384651]  [<ffffffffa057175b>] run_delalloc_range+0x7b/0xa0 [btrfs]
[ 1559.391195]  [<ffffffffa05866d0>] __extent_writepage+0x280/0x7b0 [btrfs]
[ 1559.397900]  [<ffffffff811144ef>] ? find_get_pages_tag+0x28f/0x2f0
[ 1559.404079]  [<ffffffff81114507>] ? find_get_pages_tag+0x2a7/0x2f0
[ 1559.410260]  [<ffffffff81114298>] ? find_get_pages_tag+0x38/0x2f0
[ 1559.416346]  [<ffffffff8118e760>] ? igrab+0x40/0x70
[ 1559.421254]  [<ffffffff8111ffc5>] ? clear_page_dirty_for_io+0xe5/0x100
[ 1559.427810]  [<ffffffffa0587012>] extent_write_cache_pages.clone.3+0x242/0x3c0 [btrfs]
[ 1559.435769]  [<ffffffffa057fa4d>] ? btrfs_run_ordered_operations+0x3d/0x220 [btrfs]
[ 1559.443428]  [<ffffffff814d16db>] ? __mutex_lock_common+0x36b/0x3a0
[ 1559.449726]  [<ffffffffa05871df>] extent_writepages+0x4f/0x70 [btrfs]
[ 1559.456188]  [<ffffffffa0576460>] ? can_nocow_odirect+0x260/0x260 [btrfs]
[ 1559.462975]  [<ffffffff8118e760>] ? igrab+0x40/0x70
[ 1559.467939]  [<ffffffffa056bff7>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1559.474330]  [<ffffffff81120733>] do_writepages+0x23/0x40
[ 1559.479754]  [<ffffffff81113a9e>] __filemap_fdatawrite_range+0x4e/0x50
[ 1559.486282]  [<ffffffff814d47bb>] ? _raw_spin_unlock+0x2b/0x50
[ 1559.492123]  [<ffffffff81113cbc>] filemap_flush+0x1c/0x20
[ 1559.497567]  [<ffffffffa057fb89>] btrfs_run_ordered_operations+0x179/0x220 [btrfs]
[ 1559.505158]  [<ffffffffa0567791>] btrfs_commit_transaction+0x91/0xa50 [btrfs]
[ 1559.512296]  [<ffffffff814d47bb>] ? _raw_spin_unlock+0x2b/0x50
[ 1559.518151]  [<ffffffffa0568963>] ? start_transaction+0x403/0x490 [btrfs]
[ 1559.524946]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1559.530387]  [<ffffffffa0560003>] transaction_kthread+0x123/0x210 [btrfs]
[ 1559.537210]  [<ffffffffa055fee0>] ? btrfs_bio_wq_end_io+0x90/0x90 [btrfs]
[ 1559.544017]  [<ffffffff8106aa24>] kthread+0xb4/0xc0
[ 1559.548916]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1559.555529]  [<ffffffff814de924>] kernel_thread_helper+0x4/0x10
[ 1559.561454]  [<ffffffff814d4ad9>] ? retint_restore_args+0xe/0xe
[ 1559.567387]  [<ffffffff8106a970>] ? __init_kthread_worker+0x70/0x70
[ 1559.573662]  [<ffffffff814de920>] ? gs_change+0xb/0xb
[ 1559.578717] INFO: lockdep is turned off.
[ 1559.582654] INFO: task flush-btrfs-141:78560 blocked for more than 120 seconds.
[ 1559.589952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.597771] flush-btrfs-141 D ffff8802cba07780     0 78560      2 0x00000000
[ 1559.604854]  ffff8806225ad420 0000000000000046 0000000000000286 ffff8806225adfd8
[ 1559.612338]  ffff8806225ac000 ffff8806225ac010 ffff8806225ac000 ffff8806225ac000
[ 1559.619823]  ffff8806225adfd8 ffff8806225ac000 ffffffff81a13420 ffff88048b3c5df0
[ 1559.627319] Call Trace:
[ 1559.629801]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1559.634799]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.641592]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1559.647024]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1559.653657]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1559.660230]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1559.667400]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1559.674039]  [<ffffffffa057cdf7>] ? free_extent_map+0x87/0x90 [btrfs]
[ 1559.680519]  [<ffffffffa055a9fd>] btrfs_lookup_file_extent+0x3d/0x40 [btrfs]
[ 1559.687595]  [<ffffffffa057aa11>] __btrfs_drop_extents+0x171/0xad0 [btrfs]
[ 1559.694466]  [<ffffffff81165c63>] ? kmem_cache_alloc+0xd3/0x1b0
[ 1559.700400]  [<ffffffffa0567280>] ? join_transaction+0xc0/0x370 [btrfs]
[ 1559.707040]  [<ffffffffa057bd73>] btrfs_drop_extents+0x73/0xa0 [btrfs]
[ 1559.713588]  [<ffffffffa056f225>] cow_file_range_inline+0xe5/0x1c0 [btrfs]
[ 1559.720496]  [<ffffffffa0585c1c>] ? test_range_bit+0x17c/0x190 [btrfs]
[ 1559.727071]  [<ffffffffa056f472>] cow_file_range+0x172/0x4b0 [btrfs]
[ 1559.733447]  [<ffffffffa057175b>] run_delalloc_range+0x7b/0xa0 [btrfs]
[ 1559.739991]  [<ffffffffa05866d0>] __extent_writepage+0x280/0x7b0 [btrfs]
[ 1559.746690]  [<ffffffff811144ef>] ? find_get_pages_tag+0x28f/0x2f0
[ 1559.752863]  [<ffffffff81114507>] ? find_get_pages_tag+0x2a7/0x2f0
[ 1559.759036]  [<ffffffff81114298>] ? find_get_pages_tag+0x38/0x2f0
[ 1559.765131]  [<ffffffff8118e760>] ? igrab+0x40/0x70
[ 1559.770014]  [<ffffffff8111ffc5>] ? clear_page_dirty_for_io+0xe5/0x100
[ 1559.776574]  [<ffffffffa0587012>] extent_write_cache_pages.clone.3+0x242/0x3c0 [btrfs]
[ 1559.784494]  [<ffffffff810a3d9d>] ? __lock_acquire+0x3dd/0x480
[ 1559.790343]  [<ffffffffa05871df>] extent_writepages+0x4f/0x70 [btrfs]
[ 1559.796816]  [<ffffffffa0576460>] ? can_nocow_odirect+0x260/0x260 [btrfs]
[ 1559.803620]  [<ffffffffa056bff7>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1559.809980]  [<ffffffff81120733>] do_writepages+0x23/0x40
[ 1559.815393]  [<ffffffff8119d77b>] __writeback_single_inode+0x5b/0x1e0
[ 1559.821832]  [<ffffffff811a03a9>] writeback_sb_inodes+0x2c9/0x3e0
[ 1559.827929]  [<ffffffff814d47bb>] ? _raw_spin_unlock+0x2b/0x50
[ 1559.833764]  [<ffffffff811a0546>] __writeback_inodes_wb+0x86/0xd0
[ 1559.839850]  [<ffffffff811a083b>] wb_writeback+0x20b/0x550
[ 1559.845355]  [<ffffffff81049a7d>] ? local_bh_enable_ip+0xcd/0xe0
[ 1559.851371]  [<ffffffff811a0dc3>] wb_do_writeback+0x243/0x310
[ 1559.857129]  [<ffffffff811a0fc3>] bdi_writeback_thread+0x133/0x3f0
[ 1559.863323]  [<ffffffff811a0e90>] ? wb_do_writeback+0x310/0x310
[ 1559.869249]  [<ffffffff811a0e90>] ? wb_do_writeback+0x310/0x310
[ 1559.875182]  [<ffffffff8106aa24>] kthread+0xb4/0xc0
[ 1559.880067]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1559.886677]  [<ffffffff814de924>] kernel_thread_helper+0x4/0x10
[ 1559.892592]  [<ffffffff814d4ad9>] ? retint_restore_args+0xe/0xe
[ 1559.898505]  [<ffffffff8106a970>] ? __init_kthread_worker+0x70/0x70
[ 1559.904786]  [<ffffffff814de920>] ? gs_change+0xb/0xb
[ 1559.909835] INFO: lockdep is turned off.
[ 1559.917333] INFO: task ceph-osd:88950 blocked for more than 120 seconds.
[ 1559.924022] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.931839] ceph-osd        D ffff8802cba07780     0 88950      1 0x00000004
[ 1559.938943]  ffff880b646a19c8 0000000000000046 0000000000000282 ffff880b646a1fd8
[ 1559.946424]  ffff880b646a0000 ffff880b646a0010 ffff880b646a0000 ffff880b646a0000
[ 1559.953935]  ffff880b646a1fd8 ffff880b646a0000 ffff8806245d0000 ffff880c0a539f50
[ 1559.961467] Call Trace:
[ 1559.963933]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1559.968927]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.975702]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1559.981127]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1559.987784]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1559.994342]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1560.001489]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1560.008136]  [<ffffffffa055a30d>] btrfs_lookup_dir_item+0x7d/0xd0 [btrfs]
[ 1560.014952]  [<ffffffffa0573214>] btrfs_lookup_dentry+0xe4/0x420 [btrfs]
[ 1560.021709]  [<ffffffffa057356d>] btrfs_lookup+0x1d/0x70 [btrfs]
[ 1560.027736]  [<ffffffff8117e27b>] ? lookup_dcache+0x9b/0xd0
[ 1560.033312]  [<ffffffff8117dc76>] lookup_real+0x36/0x60
[ 1560.038546]  [<ffffffff8117e2e8>] __lookup_hash+0x38/0x50
[ 1560.043954]  [<ffffffff8117e364>] lookup_slow+0x64/0xe0
[ 1560.049190]  [<ffffffff811825e7>] path_lookupat+0xf7/0x6e0
[ 1560.054691]  [<ffffffff81165be7>] ? kmem_cache_alloc+0x57/0x1b0
[ 1560.060617]  [<ffffffff81182c01>] do_path_lookup+0x31/0xd0
[ 1560.066117]  [<ffffffff81183adc>] user_path_at_empty+0x6c/0xb0
[ 1560.071977]  [<ffffffff81074593>] ? lg_local_unlock+0x23/0x50
[ 1560.077742]  [<ffffffff811777a6>] ? cp_new_stat+0x116/0x130
[ 1560.083324]  [<ffffffff81183b31>] user_path_at+0x11/0x20
[ 1560.088653]  [<ffffffff81177a07>] vfs_fstatat+0x47/0x80
[ 1560.093900]  [<ffffffff81177b6b>] vfs_stat+0x1b/0x20
[ 1560.098867]  [<ffffffff81177b94>] sys_newstat+0x24/0x50
[ 1560.104105]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1560.110727]  [<ffffffff812794ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1560.117184]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1560.123186] INFO: lockdep is turned off.
[ 1560.127116] INFO: task ceph-osd:88953 blocked for more than 120 seconds.
[ 1560.133814] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.141633] ceph-osd        D 0000000000000246     0 88953      1 0x00000004
[ 1560.148748]  ffff8808f73ed388 0000000000000046 00007fffeced05a0 ffff8808f73edfd8
[ 1560.156235]  ffff8808f73ec000 ffff8808f73ec010 ffff8808f73ec000 ffff8808f73ec000
[ 1560.163704]  ffff8808f73edfd8 ffff8808f73ec000 ffff880a74d1ddf0 ffff880add0a9f50
[ 1560.171187] Call Trace:
[ 1560.173644]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1560.178616]  [<ffffffff814d3307>] schedule_preempt_disabled+0x27/0x40
[ 1560.185048]  [<ffffffff814d15c5>] __mutex_lock_common+0x255/0x3a0
[ 1560.191169]  [<ffffffffa05514f3>] ? do_chunk_alloc+0x183/0x290 [btrfs]
[ 1560.197738]  [<ffffffffa05514f3>] ? do_chunk_alloc+0x183/0x290 [btrfs]
[ 1560.204257]  [<ffffffff814d187a>] mutex_lock_nested+0x4a/0x60
[ 1560.210022]  [<ffffffffa05514f3>] do_chunk_alloc+0x183/0x290 [btrfs]
[ 1560.216409]  [<ffffffffa05571bc>] find_free_extent+0xa9c/0xbc0 [btrfs]
[ 1560.222955]  [<ffffffffa05499e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1560.230458]  [<ffffffffa0557362>] btrfs_reserve_extent+0x82/0x1e0 [btrfs]
[ 1560.237263]  [<ffffffffa0557545>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1560.244234]  [<ffffffffa0542a7a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1560.250868]  [<ffffffffa059b3a3>] ? btrfs_set_lock_blocking_rw+0xe3/0x160 [btrfs]
[ 1560.258367]  [<ffffffffa054347d>] btrfs_cow_block+0x18d/0x2d0 [btrfs]
[ 1560.264845]  [<ffffffffa05466e8>] btrfs_search_slot+0x368/0x720 [btrfs]
[ 1560.271497]  [<ffffffffa05474dd>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1560.278630]  [<ffffffff81165c63>] ? kmem_cache_alloc+0xd3/0x1b0
[ 1560.284595]  [<ffffffffa058c5d5>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
[ 1560.291576]  [<ffffffffa0591017>] __btrfs_alloc_chunk+0x6e7/0x790 [btrfs]
[ 1560.298377]  [<ffffffffa059111e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1560.304852]  [<ffffffffa05512b1>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1560.311665]  [<ffffffffa055158e>] do_chunk_alloc+0x21e/0x290 [btrfs]
[ 1560.318037]  [<ffffffffa0551e9c>] btrfs_check_data_free_space+0x13c/0x2f0 [btrfs]
[ 1560.325548]  [<ffffffffa0553a20>] btrfs_delalloc_reserve_space+0x20/0x60 [btrfs]
[ 1560.332942]  [<ffffffffa05799be>] __btrfs_buffered_write+0x15e/0x350 [btrfs]
[ 1560.340018]  [<ffffffffa0579ee9>] btrfs_file_aio_write+0x209/0x320 [btrfs]
[ 1560.346912]  [<ffffffffa0579ce0>] ? __btrfs_direct_write+0x130/0x130 [btrfs]
[ 1560.353957]  [<ffffffff81171894>] do_sync_readv_writev+0x94/0xe0
[ 1560.359963]  [<ffffffff811727a3>] do_readv_writev+0xe3/0x1e0
[ 1560.365620]  [<ffffffff81174448>] ? fget_light+0x388/0x3e0
[ 1560.371101]  [<ffffffff811728e6>] vfs_writev+0x46/0x60
[ 1560.376230]  [<ffffffff81172a01>] sys_writev+0x51/0xb0
[ 1560.381363]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1560.387361] INFO: lockdep is turned off.
[ 1560.391291] INFO: task ceph-osd:88964 blocked for more than 120 seconds.
[ 1560.397976] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.405789] ceph-osd        D 0000000000000246     0 88964      1 0x00000004
[ 1560.412876]  ffff8809107ef5c8 0000000000000046 ffff8809107ef6b8 ffff8809107effd8
[ 1560.420343]  ffff8809107ee000 ffff8809107ee010 ffff8809107ee000 ffff8809107ee000
[ 1560.427854]  ffff8809107effd8 ffff8809107ee000 ffff880af56d3ea0 ffff8809107f1f50
[ 1560.435350] Call Trace:
[ 1560.437819]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1560.442789]  [<ffffffff814d3307>] schedule_preempt_disabled+0x27/0x40
[ 1560.449224]  [<ffffffff814d15c5>] __mutex_lock_common+0x255/0x3a0
[ 1560.455347]  [<ffffffffa055152e>] ? do_chunk_alloc+0x1be/0x290 [btrfs]
[ 1560.461888]  [<ffffffffa055152e>] ? do_chunk_alloc+0x1be/0x290 [btrfs]
[ 1560.468419]  [<ffffffff814d187a>] mutex_lock_nested+0x4a/0x60
[ 1560.474187]  [<ffffffffa055152e>] do_chunk_alloc+0x1be/0x290 [btrfs]
[ 1560.480570]  [<ffffffffa05571bc>] find_free_extent+0xa9c/0xbc0 [btrfs]
[ 1560.487123]  [<ffffffffa05499e9>] ? btrfs_reduce_alloc_profile+0xa9/0x120 [btrfs]
[ 1560.494624]  [<ffffffffa0557362>] btrfs_reserve_extent+0x82/0x1e0 [btrfs]
[ 1560.501442]  [<ffffffffa0557545>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1560.508417]  [<ffffffffa054604c>] split_leaf+0x3cc/0x700 [btrfs]
[ 1560.514474]  [<ffffffffa05469b8>] btrfs_search_slot+0x638/0x720 [btrfs]
[ 1560.521108]  [<ffffffffa05474dd>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1560.528239]  [<ffffffff814d47bb>] ? _raw_spin_unlock+0x2b/0x50
[ 1560.534082]  [<ffffffffa05709d6>] btrfs_new_inode+0x1b6/0x4f0 [btrfs]
[ 1560.540515]  [<ffffffff8109f29d>] ? trace_hardirqs_off+0xd/0x10
[ 1560.546441]  [<ffffffffa0550000>] ? walk_down_tree+0x40/0x100 [btrfs]
[ 1560.552909]  [<ffffffffa0575150>] btrfs_create+0xc0/0x200 [btrfs]
[ 1560.559013]  [<ffffffff8121b6d5>] ? security_inode_permission+0x25/0x30
[ 1560.565623]  [<ffffffff8117f6df>] vfs_create+0x9f/0xd0
[ 1560.570767]  [<ffffffff811812a1>] ? do_last+0x231/0x720
[ 1560.575995]  [<ffffffff8118032a>] lookup_open+0x16a/0x1c0
[ 1560.581407]  [<ffffffff811812bb>] do_last+0x24b/0x720
[ 1560.586457]  [<ffffffff8117ed6d>] ? inode_permission+0x4d/0x50
[ 1560.592291]  [<ffffffff81183de7>] path_openat+0xc7/0x470
[ 1560.597602]  [<ffffffff8117ef83>] ? putname+0x33/0x50
[ 1560.602656]  [<ffffffff811842b9>] do_filp_open+0x49/0xb0
[ 1560.607961]  [<ffffffff814d47bb>] ? _raw_spin_unlock+0x2b/0x50
[ 1560.613801]  [<ffffffff8119223d>] ? alloc_fd+0x1ed/0x200
[ 1560.619133]  [<ffffffff81171375>] do_sys_open+0x135/0x1d0
[ 1560.624548]  [<ffffffff81171451>] sys_open+0x21/0x30
[ 1560.629510]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1560.635506] INFO: lockdep is turned off.
[ 1560.639429] INFO: task ceph-osd:89821 blocked for more than 120 seconds.
[ 1560.646112] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.653928] ceph-osd        D ffff8802cba07780     0 89821      1 0x00000004
[ 1560.661034]  ffff880a03afd9c8 0000000000000046 0000000000000282 ffff880a03afdfd8
[ 1560.668515]  ffff880a03afc000 ffff880a03afc010 ffff880a03afc000 ffff880a03afc000
[ 1560.676000]  ffff880a03afdfd8 ffff880a03afc000 ffff8806245e0000 ffff88096c6a1f50
[ 1560.683485] Call Trace:
[ 1560.685949]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1560.690962]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1560.697753]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1560.703162]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1560.709797]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1560.716370]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1560.723514]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1560.730156]  [<ffffffffa055a30d>] btrfs_lookup_dir_item+0x7d/0xd0 [btrfs]
[ 1560.736973]  [<ffffffffa0573214>] btrfs_lookup_dentry+0xe4/0x420 [btrfs]
[ 1560.743680]  [<ffffffffa057356d>] btrfs_lookup+0x1d/0x70 [btrfs]
[ 1560.749684]  [<ffffffff8117e27b>] ? lookup_dcache+0x9b/0xd0
[ 1560.755244]  [<ffffffff8117dc76>] lookup_real+0x36/0x60
[ 1560.760472]  [<ffffffff8117e2e8>] __lookup_hash+0x38/0x50
[ 1560.765874]  [<ffffffff8117e364>] lookup_slow+0x64/0xe0
[ 1560.771103]  [<ffffffff811825e7>] path_lookupat+0xf7/0x6e0
[ 1560.776600]  [<ffffffff81165be7>] ? kmem_cache_alloc+0x57/0x1b0
[ 1560.782522]  [<ffffffff81182c01>] do_path_lookup+0x31/0xd0
[ 1560.788013]  [<ffffffff81183adc>] user_path_at_empty+0x6c/0xb0
[ 1560.793847]  [<ffffffff81074593>] ? lg_local_unlock+0x23/0x50
[ 1560.799601]  [<ffffffff811777a6>] ? cp_new_stat+0x116/0x130
[ 1560.805177]  [<ffffffff81183b31>] user_path_at+0x11/0x20
[ 1560.810491]  [<ffffffff81177a07>] vfs_fstatat+0x47/0x80
[ 1560.815723]  [<ffffffff81177b6b>] vfs_stat+0x1b/0x20
[ 1560.820699]  [<ffffffff81177b94>] sys_newstat+0x24/0x50
[ 1560.825938]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1560.832551]  [<ffffffff812794ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1560.838997]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1560.845013] INFO: lockdep is turned off.
[ 1560.848951] INFO: task ceph-osd:89829 blocked for more than 120 seconds.
[ 1560.855648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.863468] ceph-osd        D 0000000000000246     0 89829      1 0x00000004
[ 1560.870551]  ffff88096c6adbb8 0000000000000046 ffffffff8118c6ce ffff88096c6adfd8
[ 1560.878021]  ffff88096c6ac000 ffff88096c6ac010 ffff88096c6ac000 ffff88096c6ac000
[ 1560.885537]  ffff88096c6adfd8 ffff88096c6ac000 ffff8806245d3ea0 ffff88096c6b0000
[ 1560.893020] Call Trace:
[ 1560.895483]  [<ffffffff8118c6ce>] ? __d_lookup+0x20e/0x300
[ 1560.900971]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1560.905937]  [<ffffffff814d3307>] schedule_preempt_disabled+0x27/0x40
[ 1560.912386]  [<ffffffff814d15c5>] __mutex_lock_common+0x255/0x3a0
[ 1560.918482]  [<ffffffff8117e356>] ? lookup_slow+0x56/0xe0
[ 1560.923886]  [<ffffffff8117e356>] ? lookup_slow+0x56/0xe0
[ 1560.929291]  [<ffffffff814d187a>] mutex_lock_nested+0x4a/0x60
[ 1560.935038]  [<ffffffff8117e356>] lookup_slow+0x56/0xe0
[ 1560.940265]  [<ffffffff811825e7>] path_lookupat+0xf7/0x6e0
[ 1560.945753]  [<ffffffff81165be7>] ? kmem_cache_alloc+0x57/0x1b0
[ 1560.951675]  [<ffffffff81182c01>] do_path_lookup+0x31/0xd0
[ 1560.957152]  [<ffffffff81183adc>] user_path_at_empty+0x6c/0xb0
[ 1560.962981]  [<ffffffff81183b31>] user_path_at+0x11/0x20
[ 1560.968302]  [<ffffffff81177a07>] vfs_fstatat+0x47/0x80
[ 1560.973528]  [<ffffffff81177b6b>] vfs_stat+0x1b/0x20
[ 1560.978512]  [<ffffffff81177b94>] sys_newstat+0x24/0x50
[ 1560.983746]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1560.990345]  [<ffffffff812794ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1560.996792]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1561.002793] INFO: lockdep is turned off.
[ 1561.006712] INFO: task ceph-osd:89839 blocked for more than 120 seconds.
[ 1561.013394] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1561.021205] ceph-osd        D ffff8802cba07780     0 89839      1 0x00000004
[ 1561.028293]  ffff880a736a19c8 0000000000000046 0000000000000282 ffff880a736a1fd8
[ 1561.035764]  ffff880a736a0000 ffff880a736a0010 ffff880a736a0000 ffff880a736a0000
[ 1561.043251]  ffff880a736a1fd8 ffff880a736a0000 ffff8806245e1f50 ffff88096c6b5df0
[ 1561.050726] Call Trace:
[ 1561.053178]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1561.058171]  [<ffffffffa059b0e3>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1561.064951]  [<ffffffff8106b0a0>] ? wake_up_bit+0x40/0x40
[ 1561.070385]  [<ffffffffa053ef08>] ? btrfs_root_node+0x198/0x230 [btrfs]
[ 1561.077019]  [<ffffffffa053eda0>] ? btrfs_root_node+0x30/0x230 [btrfs]
[ 1561.083581]  [<ffffffffa053efc3>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1561.090759]  [<ffffffffa0546570>] btrfs_search_slot+0x1f0/0x720 [btrfs]
[ 1561.097426]  [<ffffffffa055a30d>] btrfs_lookup_dir_item+0x7d/0xd0 [btrfs]
[ 1561.104274]  [<ffffffffa0573214>] btrfs_lookup_dentry+0xe4/0x420 [btrfs]
[ 1561.110996]  [<ffffffffa057356d>] btrfs_lookup+0x1d/0x70 [btrfs]
[ 1561.116996]  [<ffffffff8117e27b>] ? lookup_dcache+0x9b/0xd0
[ 1561.122578]  [<ffffffff8117dc76>] lookup_real+0x36/0x60
[ 1561.127803]  [<ffffffff8117e2e8>] __lookup_hash+0x38/0x50
[ 1561.133211]  [<ffffffff8117e364>] lookup_slow+0x64/0xe0
[ 1561.138458]  [<ffffffff811825e7>] path_lookupat+0xf7/0x6e0
[ 1561.143955]  [<ffffffff81165be7>] ? kmem_cache_alloc+0x57/0x1b0
[ 1561.149897]  [<ffffffff81182c01>] do_path_lookup+0x31/0xd0
[ 1561.155385]  [<ffffffff81183adc>] user_path_at_empty+0x6c/0xb0
[ 1561.161223]  [<ffffffff81183b31>] user_path_at+0x11/0x20
[ 1561.166534]  [<ffffffff81177a07>] vfs_fstatat+0x47/0x80
[ 1561.171758]  [<ffffffff81177b6b>] vfs_stat+0x1b/0x20
[ 1561.176724]  [<ffffffff81177b94>] sys_newstat+0x24/0x50
[ 1561.181955]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1561.188564]  [<ffffffff812794ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1561.195000]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1561.201000] INFO: lockdep is turned off.
[ 1561.204933] INFO: task ceph-osd:89859 blocked for more than 120 seconds.
[ 1561.211619] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1561.219434] ceph-osd        D 0000000000000246     0 89859      1 0x00000004
[ 1561.226542]  ffff880a7f725bb8 0000000000000046 ffffffff8118c6ce ffff880a7f725fd8
[ 1561.234038]  ffff880a7f724000 ffff880a7f724010 ffff880a7f724000 ffff880a7f724000
[ 1561.241531]  ffff880a7f725fd8 ffff880a7f724000 ffff880624600000 ffff880a736b5df0
[ 1561.249042] Call Trace:
[ 1561.251526]  [<ffffffff8118c6ce>] ? __d_lookup+0x20e/0x300
[ 1561.257020]  [<ffffffff814d2fdd>] schedule+0x5d/0x60
[ 1561.261995]  [<ffffffff814d3307>] schedule_preempt_disabled+0x27/0x40
[ 1561.268435]  [<ffffffff814d15c5>] __mutex_lock_common+0x255/0x3a0
[ 1561.274531]  [<ffffffff8117e356>] ? lookup_slow+0x56/0xe0
[ 1561.279935]  [<ffffffff8117e356>] ? lookup_slow+0x56/0xe0
[ 1561.285348]  [<ffffffff814d187a>] mutex_lock_nested+0x4a/0x60
[ 1561.291095]  [<ffffffff8117e356>] lookup_slow+0x56/0xe0
[ 1561.296327]  [<ffffffff811825e7>] path_lookupat+0xf7/0x6e0
[ 1561.301808]  [<ffffffff81165be7>] ? kmem_cache_alloc+0x57/0x1b0
[ 1561.307715]  [<ffffffff81182c01>] do_path_lookup+0x31/0xd0
[ 1561.313200]  [<ffffffff81183adc>] user_path_at_empty+0x6c/0xb0
[ 1561.319029]  [<ffffffff81183b31>] user_path_at+0x11/0x20
[ 1561.324361]  [<ffffffff81177a07>] vfs_fstatat+0x47/0x80
[ 1561.329599]  [<ffffffff81177b6b>] vfs_stat+0x1b/0x20
[ 1561.334568]  [<ffffffff81177b94>] sys_newstat+0x24/0x50
[ 1561.339784]  [<ffffffff810a29d0>] ? trace_hardirqs_on_caller+0x20/0x1e0
[ 1561.346403]  [<ffffffff812794ee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 1561.352849]  [<ffffffff814dd792>] system_call_fastpath+0x16/0x1b
[ 1561.358852] INFO: lockdep is turned off.



-- Jim


