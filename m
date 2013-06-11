Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:58772 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab3FKPnc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 11:43:32 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 45F4D8004B
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 08:43:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 250408004B
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 08:43:30 -0700 (PDT)
Date: Tue, 11 Jun 2013 08:43:30 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: hang on 3.9, 3.10-rc5
Message-ID: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm also seeing this hang regularly with both 3.9 and 3.10-rc5.  Is this 
is a known problem?  In this case there is no powercycling; just a regular 
ceph-osd workload.

Thanks-
sage


[ 2885.479116] INFO: task kworker/u64:1:28713 blocked for more than 120 seconds.
[ 2885.486277] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2885.494201] kworker/u64:1   D ffff880222b81f90     0 28713      2 0x00000000
[ 2885.501355] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-12)
[ 2885.507924]  ffff88021c3d7238 0000000000000046 0000000000000286 ffff880082af52e8
[ 2885.515456]  ffff880222b81f90 ffff88021c3d7fd8 ffff88021c3d7fd8 ffff88021c3d7fd8
[ 2885.522987]  ffff880225d2bf20 ffff880222b81f90 ffff88021c3d7248 ffff880082af51c0
[ 2885.530497] Call Trace:
[ 2885.532964]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2885.537972]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2885.544407]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2885.550760]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2885.557490]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2885.564196]  [<ffffffffa01ff76e>] ? free_extent_map+0x4e/0x90 [btrfs]
[ 2885.570738]  [<ffffffffa01dd198>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[ 2885.577823]  [<ffffffffa01fd1be>] __btrfs_drop_extents+0x12e/0xaf0 [btrfs]
[ 2885.584737]  [<ffffffff8107b093>] ? select_task_rq_fair+0x53/0x8a0
[ 2885.590977]  [<ffffffff81167788>] ? kmem_cache_alloc+0xd8/0x160
[ 2885.596934]  [<ffffffffa01fe63e>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
[ 2885.603531]  [<ffffffffa01f16c1>] cow_file_range_inline+0xf1/0x1e0 [btrfs]
[ 2885.610451]  [<ffffffffa01f1ad6>] __cow_file_range+0x326/0x4b0 [btrfs]
[ 2885.617014]  [<ffffffffa01e89ea>] ? join_transaction.isra.32+0x10a/0x3c0 [btrfs]
[ 2885.624520]  [<ffffffffa01f27d5>] cow_file_range+0x95/0xe0 [btrfs]
[ 2885.630772]  [<ffffffffa01f2b5b>] run_delalloc_range+0x33b/0x360 [btrfs]
[ 2885.637581]  [<ffffffffa0208120>] __extent_writepage+0x5e0/0x770 [btrfs]
[ 2885.644357]  [<ffffffff8111cf9f>] ? find_get_pages_tag+0x11f/0x1c0
[ 2885.650614]  [<ffffffff8111ceae>] ? find_get_pages_tag+0x2e/0x1c0
[ 2885.656744]  [<ffffffffa0208532>] extent_write_cache_pages.isra.29.constprop.41+0x282/0x3e0 [btrfs]
[ 2885.665906]  [<ffffffffa01ec8c0>] ? add_pending_csums.isra.44+0x70/0x70 [btrfs]
[ 2885.673325]  [<ffffffffa01ebde0>] ? btrfs_readpage_end_io_hook+0x270/0x270 [btrfs]
[ 2885.680990]  [<ffffffff8119815c>] ? __writeback_single_inode+0x6c/0x2a0
[ 2885.687792]  [<ffffffffa020892e>] extent_writepages+0x4e/0x70 [btrfs]
[ 2885.694296]  [<ffffffffa01eeec0>] ? can_nocow_odirect+0x330/0x330 [btrfs]
[ 2885.701787]  [<ffffffffa01ec698>] btrfs_writepages+0x28/0x30 [btrfs]
[ 2885.708164]  [<ffffffff811289e3>] do_writepages+0x23/0x40
[ 2885.713679]  [<ffffffff8119813e>] __writeback_single_inode+0x4e/0x2a0
[ 2885.720347]  [<ffffffff81199630>] writeback_sb_inodes+0x280/0x3e0
[ 2885.726528]  [<ffffffff8119982e>] __writeback_inodes_wb+0x9e/0xd0
[ 2885.732766]  [<ffffffff81199a5b>] wb_writeback+0x1fb/0x310
[ 2885.738271]  [<ffffffff81127a21>] ? bdi_dirty_limit+0x31/0xc0
[ 2885.744266]  [<ffffffff8119b3e8>] wb_do_writeback+0x138/0x1e0
[ 2885.750091]  [<ffffffff8119b50a>] bdi_writeback_workfn+0x7a/0x200
[ 2885.756207]  [<ffffffff8105f4ba>] process_one_work+0x1da/0x540
[ 2885.762111]  [<ffffffff8105f44f>] ? process_one_work+0x16f/0x540
[ 2885.768138]  [<ffffffff8106069c>] worker_thread+0x11c/0x370
[ 2885.773836]  [<ffffffff81060580>] ? manage_workers.isra.20+0x2e0/0x2e0
[ 2885.780513]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 2885.785412]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2885.791805]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 2885.797227]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2885.803694] INFO: lockdep is turned off.
[ 2885.807640] INFO: task btrfs-transacti:23992 blocked for more than 120 seconds.
[ 2885.815086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2885.823067] btrfs-transacti D ffff880222493f20     0 23992      2 0x00000000
[ 2885.830265]  ffff88020cebfa28 0000000000000046 0000000000000286 ffff880082af52e8
[ 2885.837761]  ffff880222493f20 ffff88020cebffd8 ffff88020cebffd8 ffff88020cebffd8
[ 2885.845281]  ffff880225d29f90 ffff880222493f20 ffff88020cebfa38 ffff880082af51c0
[ 2885.852840] Call Trace:
[ 2885.855306]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2885.860393]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2885.866772]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2885.873123]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2885.879881]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2885.886517]  [<ffffffff8163760b>] ? _raw_spin_unlock+0x2b/0x40
[ 2885.892465]  [<ffffffffa01c8f28>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 2885.899574]  [<ffffffffa0238d54>] btrfs_insert_delayed_items+0x84/0x460 [btrfs]
[ 2885.906936]  [<ffffffffa0239938>] __btrfs_run_delayed_items+0xb8/0x1e0 [btrfs]
[ 2885.914285]  [<ffffffffa0239a93>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 2885.921371]  [<ffffffffa01e7c32>] btrfs_flush_all_pending_stuffs+0xa2/0xe0 [btrfs]
[ 2885.929040]  [<ffffffffa01e9511>] btrfs_commit_transaction+0x201/0xa50 [btrfs]
[ 2885.937489]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2885.943838]  [<ffffffffa01e289d>] transaction_kthread+0x1ad/0x230 [btrfs]
[ 2885.950705]  [<ffffffffa01e26f0>] ? check_leaf.isra.108+0x330/0x330 [btrfs]
[ 2885.957692]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 2885.962630]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2885.969024]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 2885.974473]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2885.980918] INFO: lockdep is turned off.
[ 2885.984960] INFO: task ceph-osd:24240 blocked for more than 120 seconds.
[ 2885.991751] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2885.999743] ceph-osd        D ffff88022431f830     0 24240  24119 0x00000000
[ 2886.007005]  ffff88021af51be8 0000000000000046 0000000000000282 ffff88022431f8a0
[ 2886.014543]  ffff88021af48000 ffff88021af51fd8 ffff88021af51fd8 ffff88021af51fd8
[ 2886.022103]  ffff880225d2deb0 ffff88021af48000 ffff88021af51bf8 ffff88022431f8a0
[ 2886.029653] Call Trace:
[ 2886.032137]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.037220]  [<ffffffffa0222275>] log_one_extent.isra.22+0x485/0x750 [btrfs]
[ 2886.044315]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2886.050672]  [<ffffffffa022486c>] btrfs_log_inode+0x7bc/0x8e0 [btrfs]
[ 2886.057224]  [<ffffffffa02259b2>] btrfs_log_inode_parent+0x192/0x460 [btrfs]
[ 2886.064373]  [<ffffffff8118585c>] ? dget_parent+0x1c/0xd0
[ 2886.069893]  [<ffffffffa02267d6>] btrfs_log_dentry_safe+0x46/0x70 [btrfs]
[ 2886.076754]  [<ffffffffa01fadf5>] btrfs_sync_file+0x155/0x2c0 [btrfs]
[ 2886.083288]  [<ffffffff8118c400>] ? fget+0x90/0xe0
[ 2886.088122]  [<ffffffff8118c48c>] ? fget_light+0x3c/0x130
[ 2886.093602]  [<ffffffff8119ef3d>] do_fsync+0x5d/0x90
[ 2886.098588]  [<ffffffff8131e7fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2886.105069]  [<ffffffff8119f350>] SyS_fsync+0x10/0x20
[ 2886.110215]  [<ffffffff81640042>] system_call_fastpath+0x16/0x1b
[ 2886.116241] INFO: lockdep is turned off.
[ 2886.120232] INFO: task ceph-osd:24324 blocked for more than 120 seconds.
[ 2886.126978] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2886.134868] ceph-osd        D ffff8802228e1f90     0 24324  24119 0x00000000
[ 2886.141997]  ffff8802228eb948 0000000000000046 0000000000000282 ffff880082af52e8
[ 2886.149528]  ffff8802228e1f90 ffff8802228ebfd8 ffff8802228ebfd8 ffff8802228ebfd8
[ 2886.157041]  ffff880225d2bf20 ffff8802228e1f90 ffff8802228eb958 ffff880082af51c0
[ 2886.164550] Call Trace:
[ 2886.167015]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.172093]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2886.178471]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2886.184915]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2886.191689]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2886.198333]  [<ffffffffa01c457c>] ? comp_keys+0x2c/0x30 [btrfs]
[ 2886.204398]  [<ffffffffa01c8f28>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 2886.211530]  [<ffffffff812ee41b>] ? chksum_update+0x1b/0x30
[ 2886.217138]  [<ffffffffa01dc30c>] insert_with_overflow+0x3c/0x110 [btrfs]
[ 2886.224033]  [<ffffffffa01dc678>] btrfs_insert_xattr_item+0x98/0x190 [btrfs]
[ 2886.231174]  [<ffffffff8163760b>] ? _raw_spin_unlock+0x2b/0x40
[ 2886.237044]  [<ffffffffa02093d9>] ? free_extent_buffer+0x49/0xc0 [btrfs]
[ 2886.243853]  [<ffffffffa02093f1>] ? free_extent_buffer+0x61/0xc0 [btrfs]
[ 2886.250649]  [<ffffffffa0200759>] do_setxattr+0x1a9/0x2d0 [btrfs]
[ 2886.256778]  [<ffffffffa0200a83>] __btrfs_setxattr+0x93/0x110 [btrfs]
[ 2886.263379]  [<ffffffffa0200f60>] btrfs_setxattr+0x90/0xd0 [btrfs]
[ 2886.269642]  [<ffffffff81193cfb>] __vfs_setxattr_noperm+0x7b/0x1c0
[ 2886.275841]  [<ffffffff81193f04>] vfs_setxattr+0xc4/0xd0
[ 2886.281236]  [<ffffffff8119404e>] setxattr+0x13e/0x1e0
[ 2886.286393]  [<ffffffff8118cc92>] ? __fd_install+0x32/0x70
[ 2886.291999]  [<ffffffff811717f7>] ? __sb_start_write+0xe7/0x1b0
[ 2886.298016]  [<ffffffff8118f118>] ? mnt_want_write_file+0x28/0x60
[ 2886.304201]  [<ffffffff8118c48c>] ? fget_light+0x3c/0x130
[ 2886.309753]  [<ffffffff8118f118>] ? mnt_want_write_file+0x28/0x60
[ 2886.315938]  [<ffffffff8118f028>] ? __mnt_want_write+0x58/0x70
[ 2886.321869]  [<ffffffff811944ee>] SyS_fsetxattr+0xbe/0x100
[ 2886.327375]  [<ffffffff81640042>] system_call_fastpath+0x16/0x1b
[ 2886.333517] INFO: lockdep is turned off.
[ 2886.337487] INFO: task ceph-osd:24325 blocked for more than 120 seconds.
[ 2886.344213] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2886.352127] ceph-osd        D ffff8802228e3f20     0 24325  24119 0x00000000
[ 2886.359299]  ffff8802228ed948 0000000000000046 0000000000000282 ffff880082af52e8
[ 2886.366793]  ffff8802228e3f20 ffff8802228edfd8 ffff8802228edfd8 ffff8802228edfd8
[ 2886.374302]  ffff880225d38000 ffff8802228e3f20 ffff8802228ed958 ffff880082af51c0
[ 2886.381820] Call Trace:
[ 2886.384282]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.389275]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2886.395716]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2886.402063]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2886.408785]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2886.415501]  [<ffffffffa01c457c>] ? comp_keys+0x2c/0x30 [btrfs]
[ 2886.421487]  [<ffffffffa01c8f28>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 2886.428555]  [<ffffffff812ee41b>] ? chksum_update+0x1b/0x30
[ 2886.434205]  [<ffffffffa01dc30c>] insert_with_overflow+0x3c/0x110 [btrfs]
[ 2886.441080]  [<ffffffffa01dc678>] btrfs_insert_xattr_item+0x98/0x190 [btrfs]
[ 2886.448146]  [<ffffffff8163760b>] ? _raw_spin_unlock+0x2b/0x40
[ 2886.454117]  [<ffffffffa02093d9>] ? free_extent_buffer+0x49/0xc0 [btrfs]
[ 2886.460897]  [<ffffffffa02093f1>] ? free_extent_buffer+0x61/0xc0 [btrfs]
[ 2886.467626]  [<ffffffffa0200759>] do_setxattr+0x1a9/0x2d0 [btrfs]
[ 2886.473805]  [<ffffffffa0200a83>] __btrfs_setxattr+0x93/0x110 [btrfs]
[ 2886.480324]  [<ffffffffa0200f60>] btrfs_setxattr+0x90/0xd0 [btrfs]
[ 2886.486521]  [<ffffffff81193cfb>] __vfs_setxattr_noperm+0x7b/0x1c0
[ 2886.492826]  [<ffffffff81193f04>] vfs_setxattr+0xc4/0xd0
[ 2886.498225]  [<ffffffff8119404e>] setxattr+0x13e/0x1e0
[ 2886.503433]  [<ffffffff811717f7>] ? __sb_start_write+0xe7/0x1b0
[ 2886.509370]  [<ffffffff8118f118>] ? mnt_want_write_file+0x28/0x60
[ 2886.515561]  [<ffffffff8118c48c>] ? fget_light+0x3c/0x130
[ 2886.521030]  [<ffffffff8118f118>] ? mnt_want_write_file+0x28/0x60
[ 2886.527174]  [<ffffffff8118de82>] ? mnt_clone_write+0x12/0x30
[ 2886.532989]  [<ffffffff811944ee>] SyS_fsetxattr+0xbe/0x100
[ 2886.538492]  [<ffffffff81640042>] system_call_fastpath+0x16/0x1b
[ 2886.544576] INFO: lockdep is turned off.
[ 2886.548528] INFO: task ceph-osd:24340 blocked for more than 120 seconds.
[ 2886.555295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2886.563210] ceph-osd        D ffff88020aae1f90     0 24340  24119 0x00000000
[ 2886.570348]  ffff88020aaebbf8 0000000000000046 ffff88020aaebc18 0000000000000246
[ 2886.577847]  ffff88020aae1f90 ffff88020aaebfd8 ffff88020aaebfd8 ffff88020aaebfd8
[ 2886.585345]  ffff880225d3deb0 ffff88020aae1f90 0000000000000000 ffff88021a8b84e0
[ 2886.592993] Call Trace:
[ 2886.595498]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.600533]  [<ffffffff8163620e>] schedule_preempt_disabled+0xe/0x10
[ 2886.606904]  [<ffffffff8163357c>] mutex_lock_nested+0x15c/0x360
[ 2886.612887]  [<ffffffff8162eae1>] ? lookup_slow+0x38/0xab
[ 2886.618379]  [<ffffffff8162eae1>] lookup_slow+0x38/0xab
[ 2886.623717]  [<ffffffff8117c372>] path_lookupat+0x222/0x790
[ 2886.629306]  [<ffffffff811676e9>] ? kmem_cache_alloc+0x39/0x160
[ 2886.635300]  [<ffffffff8117c914>] filename_lookup+0x34/0xc0
[ 2886.640915]  [<ffffffff8117fbd9>] user_path_at_empty+0x59/0xa0
[ 2886.646767]  [<ffffffff8113e27e>] ? might_fault+0x8e/0xa0
[ 2886.652234]  [<ffffffff8113e235>] ? might_fault+0x45/0xa0
[ 2886.657726]  [<ffffffff811746a6>] ? cp_new_stat+0x116/0x130
[ 2886.663361]  [<ffffffff8117fc31>] user_path_at+0x11/0x20
[ 2886.668691]  [<ffffffff81174921>] vfs_fstatat+0x51/0xb0
[ 2886.674008]  [<ffffffff81174a4b>] vfs_stat+0x1b/0x20
[ 2886.678988]  [<ffffffff81174a65>] SYSC_newstat+0x15/0x30
[ 2886.684347]  [<ffffffff8131e7fe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 2886.690898]  [<ffffffff81174bbe>] SyS_newstat+0xe/0x10
[ 2886.696068]  [<ffffffff81640042>] system_call_fastpath+0x16/0x1b
[ 2886.702101] INFO: lockdep is turned off.
[ 2886.706075] INFO: task btrfs-endio-wri:26078 blocked for more than 120 seconds.
[ 2886.713450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2886.721404] btrfs-endio-wri D ffff8802187e1f90     0 26078      2 0x00000000
[ 2886.728564]  ffff8802152db918 0000000000000046 0000000000000282 ffff880082af52e8
[ 2886.736122]  ffff8802187e1f90 ffff8802152dbfd8 ffff8802152dbfd8 ffff8802152dbfd8
[ 2886.743676]  ffff880225d29f90 ffff8802187e1f90 ffff8802152db928 ffff880082af51c0
[ 2886.751311] Call Trace:
[ 2886.753774]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.758831]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2886.765259]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2886.771663]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2886.778438]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2886.785128]  [<ffffffff8163760b>] ? _raw_spin_unlock+0x2b/0x40
[ 2886.791036]  [<ffffffffa01dd198>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[ 2886.798119]  [<ffffffffa01fd1be>] __btrfs_drop_extents+0x12e/0xaf0 [btrfs]
[ 2886.805033]  [<ffffffff810a317d>] ? trace_hardirqs_on+0xd/0x10
[ 2886.810900]  [<ffffffff81167788>] ? kmem_cache_alloc+0xd8/0x160
[ 2886.816883]  [<ffffffffa01e8905>] ? join_transaction.isra.32+0x25/0x3c0 [btrfs]
[ 2886.824258]  [<ffffffffa01fe63e>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
[ 2886.830872]  [<ffffffffa01ecf9b>] insert_reserved_file_extent.constprop.59+0x7b/0x2c0 [btrfs]
[ 2886.839450]  [<ffffffffa01f6b3e>] btrfs_finish_ordered_io+0x51e/0x9d0 [btrfs]
[ 2886.846640]  [<ffffffffa02171e1>] ? worker_loop+0xa1/0x580 [btrfs]
[ 2886.852896]  [<ffffffffa01f7005>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2886.859372]  [<ffffffffa02172aa>] worker_loop+0x16a/0x580 [btrfs]
[ 2886.865504]  [<ffffffffa0217140>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
[ 2886.872456]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 2886.877371]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2886.883763]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 2886.889180]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2886.895574] INFO: lockdep is turned off.
[ 2886.899513] INFO: task btrfs-endio-wri:380 blocked for more than 120 seconds.
[ 2886.907921] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 2886.915833] btrfs-endio-wri D ffff88020c1ebf20     0   380      2 0x00000000
[ 2886.923008]  ffff880203e83a68 0000000000000046 0000000000000286 ffff880082af52e8
[ 2886.930711]  ffff88020c1ebf20 ffff880203e83fd8 ffff880203e83fd8 ffff880203e83fd8
[ 2886.938177]  ffff88020d0e9f90 ffff88020c1ebf20 ffff880203e83a78 ffff880082af51c0
[ 2886.945817] Call Trace:
[ 2886.948280]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 2886.953326]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 2886.959752]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 2886.966097]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 2886.972931]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 2886.979633]  [<ffffffffa01c8f28>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 2886.986750]  [<ffffffffa01ed01f>] insert_reserved_file_extent.constprop.59+0xff/0x2c0 [btrfs]
[ 2886.995495]  [<ffffffffa01f6b3e>] btrfs_finish_ordered_io+0x51e/0x9d0 [btrfs]
[ 2887.002712]  [<ffffffffa02171e1>] ? worker_loop+0xa1/0x580 [btrfs]
[ 2887.008919]  [<ffffffffa01f7005>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 2887.015434]  [<ffffffffa02172aa>] worker_loop+0x16a/0x580 [btrfs]
[ 2887.021585]  [<ffffffffa0217140>] ? btrfs_queue_worker+0x320/0x320 [btrfs]
[ 2887.028478]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 2887.033400]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2887.039779]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 2887.045215]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 2887.051637] INFO: lockdep is turned off.
[ 3007.122737] INFO: task kworker/u64:1:28713 blocked for more than 120 seconds.
[ 3007.129898] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3007.137877] kworker/u64:1   D ffff880222b81f90     0 28713      2 0x00000000
[ 3007.145094] Workqueue: writeback bdi_writeback_workfn (flush-btrfs-12)
[ 3007.151678]  ffff88021c3d7238 0000000000000046 0000000000000286 ffff880082af52e8
[ 3007.159483]  ffff880222b81f90 ffff88021c3d7fd8 ffff88021c3d7fd8 ffff88021c3d7fd8
[ 3007.167063]  ffff880225d2bf20 ffff880222b81f90 ffff88021c3d7248 ffff880082af51c0
[ 3007.174592] Call Trace:
[ 3007.177059]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 3007.182065]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 3007.188504]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 3007.194919]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 3007.201663]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 3007.208372]  [<ffffffffa01ff76e>] ? free_extent_map+0x4e/0x90 [btrfs]
[ 3007.214944]  [<ffffffffa01dd198>] btrfs_lookup_file_extent+0x38/0x40 [btrfs]
[ 3007.222144]  [<ffffffffa01fd1be>] __btrfs_drop_extents+0x12e/0xaf0 [btrfs]
[ 3007.229106]  [<ffffffff8107b093>] ? select_task_rq_fair+0x53/0x8a0
[ 3007.235436]  [<ffffffff81167788>] ? kmem_cache_alloc+0xd8/0x160
[ 3007.241394]  [<ffffffffa01fe63e>] btrfs_drop_extents+0x6e/0xa0 [btrfs]
[ 3007.248024]  [<ffffffffa01f16c1>] cow_file_range_inline+0xf1/0x1e0 [btrfs]
[ 3007.255058]  [<ffffffffa01f1ad6>] __cow_file_range+0x326/0x4b0 [btrfs]
[ 3007.261633]  [<ffffffffa01e89ea>] ? join_transaction.isra.32+0x10a/0x3c0 [btrfs]
[ 3007.269142]  [<ffffffffa01f27d5>] cow_file_range+0x95/0xe0 [btrfs]
[ 3007.275452]  [<ffffffffa01f2b5b>] run_delalloc_range+0x33b/0x360 [btrfs]
[ 3007.282316]  [<ffffffffa0208120>] __extent_writepage+0x5e0/0x770 [btrfs]
[ 3007.289136]  [<ffffffff8111cf9f>] ? find_get_pages_tag+0x11f/0x1c0
[ 3007.295491]  [<ffffffff8111ceae>] ? find_get_pages_tag+0x2e/0x1c0
[ 3007.301622]  [<ffffffffa0208532>] extent_write_cache_pages.isra.29.constprop.41+0x282/0x3e0 [btrfs]
[ 3007.310834]  [<ffffffffa01ec8c0>] ? add_pending_csums.isra.44+0x70/0x70 [btrfs]
[ 3007.318319]  [<ffffffffa01ebde0>] ? btrfs_readpage_end_io_hook+0x270/0x270 [btrfs]
[ 3007.325995]  [<ffffffff8119815c>] ? __writeback_single_inode+0x6c/0x2a0
[ 3007.332648]  [<ffffffffa020892e>] extent_writepages+0x4e/0x70 [btrfs]
[ 3007.339197]  [<ffffffffa01eeec0>] ? can_nocow_odirect+0x330/0x330 [btrfs]
[ 3007.346084]  [<ffffffffa01ec698>] btrfs_writepages+0x28/0x30 [btrfs]
[ 3007.352459]  [<ffffffff811289e3>] do_writepages+0x23/0x40
[ 3007.357999]  [<ffffffff8119813e>] __writeback_single_inode+0x4e/0x2a0
[ 3007.364535]  [<ffffffff81199630>] writeback_sb_inodes+0x280/0x3e0
[ 3007.370653]  [<ffffffff8119982e>] __writeback_inodes_wb+0x9e/0xd0
[ 3007.376908]  [<ffffffff81199a5b>] wb_writeback+0x1fb/0x310
[ 3007.382483]  [<ffffffff81127a21>] ? bdi_dirty_limit+0x31/0xc0
[ 3007.388313]  [<ffffffff8119b3e8>] wb_do_writeback+0x138/0x1e0
[ 3007.394196]  [<ffffffff8119b50a>] bdi_writeback_workfn+0x7a/0x200
[ 3007.400323]  [<ffffffff8105f4ba>] process_one_work+0x1da/0x540
[ 3007.406271]  [<ffffffff8105f44f>] ? process_one_work+0x16f/0x540
[ 3007.412356]  [<ffffffff8106069c>] worker_thread+0x11c/0x370
[ 3007.417974]  [<ffffffff81060580>] ? manage_workers.isra.20+0x2e0/0x2e0
[ 3007.424767]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 3007.429766]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 3007.436263]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 3007.441812]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 3007.448303] INFO: lockdep is turned off.
[ 3007.452250] INFO: task btrfs-transacti:23992 blocked for more than 120 seconds.
[ 3007.459765] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3007.467753] btrfs-transacti D ffff880222493f20     0 23992      2 0x00000000
[ 3007.475023]  ffff88020cebfa28 0000000000000046 0000000000000286 ffff880082af52e8
[ 3007.482676]  ffff880222493f20 ffff88020cebffd8 ffff88020cebffd8 ffff88020cebffd8
[ 3007.490257]  ffff880225d29f90 ffff880222493f20 ffff88020cebfa38 ffff880082af51c0
[ 3007.497889] Call Trace:
[ 3007.500354]  [<ffffffff81635ed9>] schedule+0x29/0x70
[ 3007.505452]  [<ffffffffa021ec95>] btrfs_tree_lock+0x75/0x270 [btrfs]
[ 3007.511956]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 3007.518358]  [<ffffffffa01c22cb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[ 3007.525223]  [<ffffffffa01c77ba>] btrfs_search_slot+0x87a/0x940 [btrfs]
[ 3007.531917]  [<ffffffff8163760b>] ? _raw_spin_unlock+0x2b/0x40
[ 3007.537876]  [<ffffffffa01c8f28>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[ 3007.545100]  [<ffffffffa0238d54>] btrfs_insert_delayed_items+0x84/0x460 [btrfs]
[ 3007.552485]  [<ffffffffa0239938>] __btrfs_run_delayed_items+0xb8/0x1e0 [btrfs]
[ 3007.559882]  [<ffffffffa0239a93>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[ 3007.567061]  [<ffffffffa01e7c32>] btrfs_flush_all_pending_stuffs+0xa2/0xe0 [btrfs]
[ 3007.574806]  [<ffffffffa01e9511>] btrfs_commit_transaction+0x201/0xa50 [btrfs]
[ 3007.582066]  [<ffffffff81067b50>] ? __init_waitqueue_head+0x60/0x60
[ 3007.588543]  [<ffffffffa01e289d>] transaction_kthread+0x1ad/0x230 [btrfs]
[ 3007.595429]  [<ffffffffa01e26f0>] ? check_leaf.isra.108+0x330/0x330 [btrfs]
[ 3007.602417]  [<ffffffff8106735a>] kthread+0xea/0xf0
[ 3007.607443]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 3007.613879]  [<ffffffff8163ff9c>] ret_from_fork+0x7c/0xb0
[ 3007.619299]  [<ffffffff81067270>] ? flush_kthread_worker+0x150/0x150
[ 3007.625788] INFO: lockdep is turned off.
