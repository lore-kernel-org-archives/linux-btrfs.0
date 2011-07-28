From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: btrfs hung tasks
Date: Thu, 28 Jul 2011 07:23:43 +0100
Message-ID: <20110728062343.GA4656@yahoo.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hiya, I got below those last night. That was 3 minutes after a
bunch of rsync and ntfsclone processes started.

It's the first time it happens. I upgraded from 3.0rc6 to 3.0
yesterday.

sysrq-t output attached.

[30961.476020] INFO: task kthreadd:2 blocked for more than 120 seconds.
[30961.482414] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30961.490271] kthreadd        D ffff880149526e20     0     2      0 0x00000000
[30961.497489]  ffff880149526e20 0000000000000046 ffff88014fffb700 ffffea00007eb520
[30961.504977]  ffff880147045890 0000000000012800 ffff88014952ffd8 ffff88014952ffd8
[30961.512525]  0000000000012800 ffff880149526e20 0000000000012800 0000000000012800
[30961.520179] Call Trace:
[30961.522702]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[30961.527850]  [<ffffffff81066feb>] ? timekeeping_get_ns+0xd/0x2a
[30961.533861]  [<ffffffff810b5c70>] ? lock_page+0x20/0x20
[30961.539134]  [<ffffffff813354f3>] ? io_schedule+0x5b/0x75
[30961.548853]  [<ffffffff810b5c79>] ? sleep_on_page+0x9/0x10
[30961.554424]  [<ffffffff81335b74>] ? __wait_on_bit+0x3e/0x71
[30961.560042]  [<ffffffff810b5e11>] ? wait_on_page_bit+0x6a/0x70
[30961.565912]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[30961.572478]  [<ffffffff810ef92d>] ? migrate_pages+0x1b6/0x39b
[30961.578243]  [<ffffffff810e851b>] ? suitable_migration_target+0x35/0x35
[30961.584877]  [<ffffffff810e8ee2>] ? compact_zone+0x68e/0x6a1
[30961.590567]  [<ffffffff8110b5f1>] ? shrink_dcache_memory+0x132/0x15d
[30961.596934]  [<ffffffff810e9075>] ? compact_zone_order+0x9e/0xab
[30961.602954]  [<ffffffff810e9112>] ? try_to_compact_pages+0x90/0xe6
[30961.609147]  [<ffffffff810bc393>] ? __alloc_pages_direct_compact+0xac/0x163
[30961.616124]  [<ffffffff810bc8cf>] ? __alloc_pages_nodemask+0x485/0x75c
[30961.622665]  [<ffffffff81044a50>] ? copy_process+0x109/0x10eb
[30961.628462]  [<ffffffff8103b012>] ? perf_event_task_sched_out+0x48/0x54
[30961.635108]  [<ffffffff81045b60>] ? do_fork+0xff/0x263
[30961.640262]  [<ffffffff8100f1e0>] ? kernel_thread+0x7b/0x83
[30961.645846]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30961.651955]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30961.657193]  [<ffffffff8105ff3e>] ? kthreadd+0xe7/0x125
[30961.662434]  [<ffffffff8103b0a2>] ? finish_task_switch+0x84/0xaf
[30961.668477]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30961.674587]  [<ffffffff8105fe57>] ? tsk_fork_get_node+0x1a/0x1a
[30961.680518]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30961.685772] INFO: task btrfs-delayed-m:785 blocked for more than 120 seconds.
[30961.692919] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30961.700793] btrfs-delayed-m D ffff88014628a300     0   785      2 0x00000000
[30961.707874]  ffff88014628a300 0000000000000046 ffff88014549cc28 000000000000eb3f
[30961.715347]  ffff880147044ab0 0000000000012800 ffff8801484c3fd8 ffff8801484c3fd8
[30961.722816]  0000000000012800 ffff88014628a300 0000000000012800 0000000000012800
[30961.730283] Call Trace:
[30961.732750]  [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
[30961.739056]  [<ffffffffa02bb89c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
[30961.745524]  [<ffffffffa02bb754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
[30961.752337]  [<ffffffffa027a16d>] ? btrfs_lock_root_node+0x1d/0x3f [btrfs]
[30961.759231]  [<ffffffffa027d7a1>] ? btrfs_search_slot+0xe6/0x4d6 [btrfs]
[30961.765948]  [<ffffffff81335ce4>] ? mutex_lock+0xd/0x2d
[30961.771190]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30961.776809]  [<ffffffffa028c82a>] ? btrfs_lookup_inode+0x25/0x87 [btrfs]
[30961.783527]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30961.789062]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30961.794654]  [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
[30961.800155]  [<ffffffff81335ce4>] ? mutex_lock+0xd/0x2d
[30961.805412]  [<ffffffffa02cd6c3>] ? btrfs_update_delayed_inode+0x6b/0x126 [btrfs]
[30961.812967]  [<ffffffffa02ce2a0>] ? btrfs_async_run_delayed_node_done+0x9f/0x1cb [btrfs]
[30961.821126]  [<ffffffffa02b6f8a>] ? worker_loop+0x17e/0x498 [btrfs]
[30961.827420]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30961.834320]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30961.841209]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30961.846276]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30961.852381]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30961.858487]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30961.863725] INFO: task btrfs-transacti:892 blocked for more than 120 seconds.
[30961.870870] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30961.878727] btrfs-transacti D ffff880147e24ee0     0   892      2 0x00000000
[30961.885811]  ffff880147e24ee0 0000000000000046 ffffea000006f318 ffff880000000000
[30961.893280]  ffff8801495660c0 0000000000012800 ffff880144357fd8 ffff880144357fd8
[30961.900743]  0000000000012800 ffff880147e24ee0 0000000000012800 0000000000012800
[30961.908210] Call Trace:
[30961.910669]  [<ffffffff8100e342>] ? read_tsc+0x5/0x14
[30961.915737]  [<ffffffff810b5c70>] ? lock_page+0x20/0x20
[30961.920978]  [<ffffffff813354f3>] ? io_schedule+0x5b/0x75
[30961.926390]  [<ffffffff810b5c79>] ? sleep_on_page+0x9/0x10
[30961.931888]  [<ffffffff81335b74>] ? __wait_on_bit+0x3e/0x71
[30961.937473]  [<ffffffff810b5e11>] ? wait_on_page_bit+0x6a/0x70
[30961.943320]  [<ffffffff810600ad>] ? autoremove_wake_function+0x2a/0x2a
[30961.949871]  [<ffffffffa02ac5f5>] ? lock_page+0x11/0x20 [btrfs]
[30961.955817]  [<ffffffffa02af4e3>] ? extent_write_cache_pages.clone.10.clone.17+0xed/0x21f [btrfs]
[30961.964730]  [<ffffffff810be856>] ? pagevec_lookup_tag+0x18/0x1f
[30961.970757]  [<ffffffff810b6468>] ? filemap_fdatawait_range+0x12c/0x14a
[30961.977400]  [<ffffffffa02af864>] ? extent_writepages+0x44/0x5a [btrfs]
[30961.984042]  [<ffffffffa0296e09>] ? uncompress_inline.clone.32+0x117/0x117 [btrfs]
[30961.991639]  [<ffffffff810b6729>] ? __filemap_fdatawrite_range+0x4b/0x50
[30961.998365]  [<ffffffffa02abd38>] ? btrfs_wait_ordered_range+0x53/0x11e [btrfs]
[30962.005706]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30962.011202]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30962.016799]  [<ffffffffa02abf30>] ? btrfs_run_ordered_operations+0x12d/0x1b6 [btrfs]
[30962.024584]  [<ffffffffa029354b>] ? btrfs_commit_transaction+0x22e/0x6fd [btrfs]
[30962.032011]  [<ffffffff810ece49>] ? kmem_cache_alloc+0x86/0xf0
[30962.037867]  [<ffffffffa0292c7b>] ? join_transaction.clone.23+0xbb/0x1fc [btrfs]
[30962.045293]  [<ffffffff81060083>] ? wake_up_bit+0x23/0x23
[30962.050705]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30962.056202]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30962.061800]  [<ffffffffa028ddd7>] ? transaction_kthread+0x171/0x229 [btrfs]
[30962.068785]  [<ffffffffa028dc66>] ? btrfs_congested_fn+0x7b/0x7b [btrfs]
[30962.075508]  [<ffffffffa028dc66>] ? btrfs_congested_fn+0x7b/0x7b [btrfs]
[30962.082223]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30962.087288]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30962.093393]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30962.099501]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30962.104755] INFO: task btrfs-delalloc-:2380 blocked for more than 120 seconds.
[30962.112007] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.119860] btrfs-delalloc- D ffff880143f9a340     0  2380      2 0x00000000
[30962.126941]  ffff880143f9a340 0000000000000046 ffff88014fffbe00 ffffffff00000000
[30962.134410]  ffffffff8160b020 0000000000012800 ffff880111f49fd8 ffff880111f49fd8
[30962.141876]  0000000000012800 ffff880143f9a340 0000000000012800 0000000000012800
[30962.149344] Call Trace:
[30962.151803]  [<ffffffff81335939>] ? schedule_timeout+0x2d/0xd7
[30962.157651]  [<ffffffff8100e28d>] ? paravirt_read_tsc+0x5/0x8
[30962.163411]  [<ffffffff8100e74a>] ? native_sched_clock+0x28/0x30
[30962.169430]  [<ffffffff8100e757>] ? sched_clock+0x5/0x8
[30962.174669]  [<ffffffff81335713>] ? wait_for_common+0x9d/0x116
[30962.180518]  [<ffffffff8103f0a4>] ? try_to_wake_up+0x199/0x199
[30962.186365]  [<ffffffff8105fdb6>] ? kthread_create_on_node+0x8f/0x10a
[30962.192825]  [<ffffffffa02827be>] ? btrfs_put_block_group+0x73/0x73 [btrfs]
[30962.199802]  [<ffffffff810eccd8>] ? __kmalloc+0xde/0xf0
[30962.205040]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30962.210555]  [<ffffffffa028271a>] ? cache_block_group+0x1f3/0x224 [btrfs]
[30962.217367]  [<ffffffffa028620b>] ? find_free_extent.clone.64+0x41a/0x932 [btrfs]
[30962.224890]  [<ffffffffa02b0a14>] ? map_extent_buffer+0x6a/0xa1 [btrfs]
[30962.231525]  [<ffffffffa0287006>] ? btrfs_reserve_extent+0xb0/0x18e [btrfs]
[30962.238512]  [<ffffffffa028767a>] ? btrfs_alloc_free_block+0x219/0x33f [btrfs]
[30962.245769]  [<ffffffffa027d24c>] ? split_leaf+0x2c6/0x523 [btrfs]
[30962.251969]  [<ffffffffa027dad6>] ? btrfs_search_slot+0x41b/0x4d6 [btrfs]
[30962.258777]  [<ffffffffa027ea43>] ? btrfs_insert_empty_items+0x62/0xb3 [btrfs]
[30962.266041]  [<ffffffffa0298da3>] ? insert_inline_extent+0xa5/0x231 [btrfs]
[30962.273029]  [<ffffffffa0299056>] ? cow_file_range_inline+0x127/0x166 [btrfs]
[30962.280189]  [<ffffffffa029a431>] ? compress_file_range+0x326/0x55a [btrfs]
[30962.287176]  [<ffffffffa029a693>] ? async_cow_start+0x2e/0x43 [btrfs]
[30962.293644]  [<ffffffffa02b6f8a>] ? worker_loop+0x17e/0x498 [btrfs]
[30962.299934]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.306831]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.313721]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30962.318787]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30962.324893]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30962.330999]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30962.336256] INFO: task btrfs-endio-wri:2442 blocked for more than 120 seconds.
[30962.343504] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.351361] btrfs-endio-wri D ffff88013ee4d550     0  2442      2 0x00000000
[30962.358445]  ffff88013ee4d550 0000000000000046 ffff880028ef7b20 ffff880100e3ce20
[30962.365911]  ffff88003a95ea70 0000000000012800 ffff880028ef7fd8 ffff880028ef7fd8
[30962.373377]  0000000000012800 ffff88013ee4d550 0000000000012800 0000000000012800
[30962.380845] Call Trace:
[30962.383301]  [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
[30962.389595]  [<ffffffffa02bb89c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
[30962.396063]  [<ffffffffa02bb754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
[30962.402871]  [<ffffffffa0279edb>] ? btrfs_set_path_blocking+0x21/0x32 [btrfs]
[30962.410027]  [<ffffffffa027da81>] ? btrfs_search_slot+0x3c6/0x4d6 [btrfs]
[30962.416840]  [<ffffffffa028b5fb>] ? btrfs_lookup_file_extent+0x34/0x39 [btrfs]
[30962.424103]  [<ffffffffa02a03c1>] ? btrfs_drop_extents+0xe4/0x6eb [btrfs]
[30962.430904]  [<ffffffff810bd65d>] ? __set_page_dirty_nobuffers+0x16/0xd6
[30962.437619]  [<ffffffff810ed076>] ? kmem_cache_free+0x2d/0x69
[30962.443389]  [<ffffffffa0297beb>] ? insert_reserved_file_extent.clone.34+0x66/0x215 [btrfs]
[30962.451777]  [<ffffffffa0293e52>] ? start_transaction+0x1ec/0x227 [btrfs]
[30962.458585]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30962.464095]  [<ffffffffa0298a41>] ? btrfs_finish_ordered_io+0x1b6/0x298 [btrfs]
[30962.471433]  [<ffffffff810be064>] ? test_clear_page_writeback+0xb8/0xcc
[30962.478074]  [<ffffffffa02ad4dd>] ? end_bio_extent_writepage+0xa2/0x152 [btrfs]
[30962.489565]  [<ffffffffa02b6f8a>] ? worker_loop+0x17e/0x498 [btrfs]
[30962.495858]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.502755]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.509646]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30962.514710]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30962.520815]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30962.526921]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30962.532177] INFO: task rsync:3139 blocked for more than 120 seconds.
[30962.538543] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.546402] rsync           D ffff88013bb86040     0  3139   3040 0x00000000
[30962.553485]  ffff88013bb86040 0000000000000082 0000000000000000 ffffffff00000000
[30962.560951]  ffffffff8160b020 0000000000012800 ffff88010d093fd8 ffff88010d093fd8
[30962.568416]  0000000000012800 ffff88013bb86040 0000000000012800 0000000000012800
[30962.575876] Call Trace:
[30962.578357]  [<ffffffffa0292b91>] ? wait_current_trans.clone.22+0xa1/0xd0 [btrfs]
[30962.585870]  [<ffffffff81060083>] ? wake_up_bit+0x23/0x23
[30962.591292]  [<ffffffffa0293d3f>] ? start_transaction+0xd9/0x227 [btrfs]
[30962.598010]  [<ffffffff810ed076>] ? kmem_cache_free+0x2d/0x69
[30962.603782]  [<ffffffffa029dbb1>] ? btrfs_create+0x33/0x18d [btrfs]
[30962.610062]  [<ffffffff810eccd8>] ? __kmalloc+0xde/0xf0
[30962.615304]  [<ffffffff811038d1>] ? generic_permission+0xe/0x9b
[30962.621234]  [<ffffffff811053d2>] ? vfs_create+0x66/0x88
[30962.626558]  [<ffffffff81103bf2>] ? d_alloc_and_lookup+0x3a/0x60
[30962.632577]  [<ffffffff81105636>] ? do_last+0x242/0x584
[30962.637814]  [<ffffffff81106bea>] ? path_openat+0xc7/0x349
[30962.643313]  [<ffffffff810fb5f1>] ? do_sync_read+0xb1/0xea
[30962.648816]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30962.654400]  [<ffffffff81106e98>] ? do_filp_open+0x2c/0x72
[30962.659898]  [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
[30962.665402]  [<ffffffff811ac741>] ? __strncpy_from_user+0x19/0x4a
[30962.671509]  [<ffffffff81110208>] ? alloc_fd+0x69/0x110
[30962.676746]  [<ffffffff810fb138>] ? do_sys_open+0x5f/0xe6
[30962.682160]  [<ffffffff8133ba92>] ? system_call_fastpath+0x16/0x1b
[30962.688355] INFO: task btrfs-delayed-m:3321 blocked for more than 120 seconds.
[30962.695602] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.703459] btrfs-delayed-m D ffff880147044ab0     0  3321      2 0x00000000
[30962.710549]  ffff880147044ab0 0000000000000046 ffff88014549cc28 000000000000eb3f
[30962.718016]  ffff880143e6e340 0000000000012800 ffff88006c569fd8 ffff88006c569fd8
[30962.725482]  0000000000012800 ffff880147044ab0 0000000000012800 0000000000012800
[30962.732948] Call Trace:
[30962.735405]  [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
[30962.741698]  [<ffffffffa02bb89c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
[30962.748167]  [<ffffffffa02bb754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
[30962.754973]  [<ffffffffa027a16d>] ? btrfs_lock_root_node+0x1d/0x3f [btrfs]
[30962.761869]  [<ffffffffa027d7a1>] ? btrfs_search_slot+0xe6/0x4d6 [btrfs]
[30962.768584]  [<ffffffff81335ce4>] ? mutex_lock+0xd/0x2d
[30962.773822]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30962.779418]  [<ffffffffa028c82a>] ? btrfs_lookup_inode+0x25/0x87 [btrfs]
[30962.786133]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30962.791631]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30962.797215]  [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
[30962.802716]  [<ffffffff81335ce4>] ? mutex_lock+0xd/0x2d
[30962.807965]  [<ffffffffa02cd6c3>] ? btrfs_update_delayed_inode+0x6b/0x126 [btrfs]
[30962.815485]  [<ffffffffa02ce2a0>] ? btrfs_async_run_delayed_node_done+0x9f/0x1cb [btrfs]
[30962.823616]  [<ffffffffa02b6f8a>] ? worker_loop+0x17e/0x498 [btrfs]
[30962.829907]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.836807]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30962.843694]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30962.848760]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30962.854868]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30962.860972]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30962.866210] INFO: task ntfsclone:3437 blocked for more than 120 seconds.
[30962.872923] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.880777] ntfsclone       D ffff8800b26250a0     0  3437   3399 0x00000000
[30962.887856]  ffff8800b26250a0 0000000000000086 0000000000000296 ffffffff00000001
[30962.895323]  ffff8801428e6ee0 0000000000012800 ffff88003d6a3fd8 ffff88003d6a3fd8
[30962.902789]  0000000000012800 ffff8800b26250a0 0000000000012800 0000000000012800
[30962.910256] Call Trace:
[30962.912730]  [<ffffffffa0292b91>] ? wait_current_trans.clone.22+0xa1/0xd0 [btrfs]
[30962.920243]  [<ffffffff81060083>] ? wake_up_bit+0x23/0x23
[30962.925668]  [<ffffffffa029fb73>] ? __btrfs_buffered_write.clone.14+0x24b/0x29a [btrfs]
[30962.933711]  [<ffffffffa029ff5d>] ? btrfs_file_aio_write+0x39b/0x435 [btrfs]
[30962.940775]  [<ffffffff810fb507>] ? do_sync_write+0xb1/0xea
[30962.946363]  [<ffffffff811650d9>] ? security_file_permission+0x18/0x33
[30962.952907]  [<ffffffff810fbb1e>] ? vfs_write+0xa6/0xf9
[30962.958147]  [<ffffffff810fbd13>] ? sys_write+0x45/0x6b
[30962.963384]  [<ffffffff8133ba92>] ? system_call_fastpath+0x16/0x1b
[30962.969577] INFO: task btrfs-delayed-m:3438 blocked for more than 120 seconds.
[30962.976828] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30962.984684] btrfs-delayed-m D ffff8801428e6ee0     0  3438      2 0x00000000
[30962.991762]  ffff8801428e6ee0 0000000000000046 ffff8800299ebcf0 ffff88010df02c70
[30962.999229]  ffff880101862ab0 0000000000012800 ffff8800299ebfd8 ffff8800299ebfd8
[30963.006695]  0000000000012800 ffff8801428e6ee0 0000000000012800 0000000000012800
[30963.014163] Call Trace:
[30963.016625]  [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
[30963.022917]  [<ffffffffa02bb89c>] ? btrfs_tree_lock+0x9a/0xa7 [btrfs]
[30963.029384]  [<ffffffffa02bb754>] ? btrfs_spin_on_block+0x49/0x49 [btrfs]
[30963.036193]  [<ffffffffa0279edb>] ? btrfs_set_path_blocking+0x21/0x32 [btrfs]
[30963.043346]  [<ffffffffa027da81>] ? btrfs_search_slot+0x3c6/0x4d6 [btrfs]
[30963.050150]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30963.055746]  [<ffffffffa028c82a>] ? btrfs_lookup_inode+0x25/0x87 [btrfs]
[30963.062460]  [<ffffffff810383fc>] ? need_resched+0x1a/0x23
[30963.067961]  [<ffffffff8103840a>] ? should_resched+0x5/0x24
[30963.073547]  [<ffffffff8133565f>] ? _cond_resched+0x9/0x20
[30963.079045]  [<ffffffff81335ce4>] ? mutex_lock+0xd/0x2d
[30963.084296]  [<ffffffffa02cd6c3>] ? btrfs_update_delayed_inode+0x6b/0x126 [btrfs]
[30963.091818]  [<ffffffffa02ce2a0>] ? btrfs_async_run_delayed_node_done+0x9f/0x1cb [btrfs]
[30963.099947]  [<ffffffffa02b6f8a>] ? worker_loop+0x17e/0x498 [btrfs]
[30963.106239]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30963.113138]  [<ffffffffa02b6e0c>] ? btrfs_queue_worker+0x25c/0x25c [btrfs]
[30963.120028]  [<ffffffff8105fc0b>] ? kthread+0x7a/0x82
[30963.125093]  [<ffffffff8133cba4>] ? kernel_thread_helper+0x4/0x10
[30963.131199]  [<ffffffff8105fb91>] ? kthread_worker_fn+0x149/0x149
[30963.137308]  [<ffffffff8133cba0>] ? gs_change+0x13/0x13
[30963.142544] INFO: task rsync:3439 blocked for more than 120 seconds.
[30963.148908] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30963.156765] rsync           D ffff880114e02870     0  3439   3172 0x00000000
[30963.163843]  ffff880114e02870 0000000000000082 00000000000c0fff ffff880114e02ef8
[30963.171307]  ffff880146786040 0000000000012800 ffff8800d335bfd8 ffff8800d335bfd8
[30963.178775]  0000000000012800 ffff880114e02870 0000000000012800 0000000000012800
[30963.186240] Call Trace:
[30963.188704]  [<ffffffff813367ec>] ? _raw_spin_lock_irqsave+0x9/0x25
[30963.194994]  [<ffffffffa0292b91>] ? wait_current_trans.clone.22+0xa1/0xd0 [btrfs]
[30963.202511]  [<ffffffff81060083>] ? wake_up_bit+0x23/0x23
[30963.207936]  [<ffffffffa029fb73>] ? __btrfs_buffered_write.clone.14+0x24b/0x29a [btrfs]
[30963.215979]  [<ffffffffa029ff5d>] ? btrfs_file_aio_write+0x39b/0x435 [btrfs]
[30963.223043]  [<ffffffff811035df>] ? dget+0x12/0x1e
[30963.227846]  [<ffffffff8110ba59>] ? dput+0x29/0xea
[30963.232651]  [<ffffffff81111b05>] ? mntput_no_expire+0x21/0xd5
[30963.238499]  [<ffffffff810fb507>] ? do_sync_write+0xb1/0xea
[30963.244084]  [<ffffffff811650d9>] ? security_file_permission+0x18/0x33
[30963.250621]  [<ffffffff810fbb1e>] ? vfs_write+0xa6/0xf9
[30963.255860]  [<ffffffff810fbd13>] ? sys_write+0x45/0x6b
[30963.261097]  [<ffffffff8133ba92>] ? system_call_fastpath+0x16/0x1b

-- 
Stephane

--GvXjxJ+pjyke8COw
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="sysrq-t.txt.xz"
Content-Transfer-Encoding: base64

/Td6WFoAAATm1rRGAgAhARYAAAB0L+Wj5L3DRqZdAC2NwhgyGQuheTL4plNeEjiwjNJKJ/gc
vt8aCC6pVRmLAGwF4b2EflRxiSrJGmrEYG7XjFKVvESNewawtqhNxHjKYNNI61Mb7gEAPwJx
yJIqlO+U0SbmJe+UpEnTT6lpGBtfurIjXw7LsMW9WC9N5ZgmchLxZGoYC6q1tkDwh8OquC5+
S1yUFZouEuYF44C02PU7JsKd/417b7IKkLV3bAm3VgSwXKcpZsktUKXhueoUmVbUrbAwGzUp
LhvWu/CBFFEG4YjnRzC/IZ+gRPcrIwXDNL3NBkGWU77z3mhiq1dn6n2cJo5P68AATwnPKPur
dVbCsRYy37qrmMYmnVey/2EwJzRWfSH6lMzRDQWd5xceUZqCzBtcLzw27DtrmgmGOehvqQCm
FE48WSsf1cLzIkZKeglbnw27bu7k7ZHaLhtoMB3nTuk8bTqBCJHiB9OEo5N2gncqn32gXZQi
yXMeBQ+3WXYWbx2cHw3SZrFeUG5kIAjigJIXomT3SdhfamkxE+FOY4W+LtPTh9vJQtPJY/74
MxAyz2vsyOBg6TIV2usDZmtptmHarLwpFWzbewqNeCLw2Z/mF1PsRQzvO532ccLmerhUq8Sl
g5eSEMfx+ruNWc5i2djdaa2OZCV/D2FaItbi8dWow1amuB2tQMHepcWKoC3+ukIPzwxMhzUy
pvVzfd7LmFImXa6CyTJKGPQFx/QU29ZMgfbXH7v4E9YutYhhBGO2RBoa+6SNePLee7+8UDGs
6e9Xi70LnJsXs3a0eBR7K9iVBcU7ck3jUNpuzMkh8orF9LHtzP7lGQjAy4p9pOwpRKPtsnto
gMeBWci2OCo16Z8xBISyXJy5CIwDm0E/r64ryUEHXzf1KxECwR5BY6wemIdp12BIwviZ830l
hX4of7dmhYGSF2Kb69YwYa0qr+rx2QkBc5a/Z3E1fNl7prfKfF8RM4rBEZW9/pIm4xkf8y67
y94pzbkI1w3nyQowPlb0fdHMVqU2d7Za6PPBInUYKf2E+yaSrtvD6mWNhfJYhW9q8MzAL6pW
YR2vD9POFUIG91ECe1dUOM0UxSgc5Bri5L42B0DtgyaH5TJCfYn/v4sMc/yuOlbYxIoGUqfY
Gl5Vfa4qRAueD3M+Bnl07AU6soiK6OUyOtcfVwUbeH734fB/FvjBQz454TrO+kVI4a/B5d94
4MhPTuqJVMdVBHWNjJauNtrJRski6uazdW2FG2afPhDkJtYixcz5mfAHRSFMAuuHZZ9C11df
AAIZxQGjENvyB3BvfGEzRVRpToEdClFxT5CW4Zio7l/GGo6uZ6c/dHX0NRKRsh7qTHnrZEhe
ftPTBmffp17PNWPcLyZ6rfrZxDxwP2UT1rcsYEXGTvFSFke3/Nz8Jl5Rulr+dVux4BPGFgwg
o0CqStQe6YkD2hpj5W3u5hO8p6LDX0FJdgVNIrvKtKZIZOfBDj+WcSR8ZT28KwUuIr93Kj1J
cox7zy5RmhkWk3if7KVf4itAsVPYPYHbltVcgEPjoda+abokgaGHA4BIOjY4V0lY05PjkMl9
vOWEU8LL8F+BmlD/YFhe/eilmHan+IqUfodKw/eBk4JQw8+yKeQuOVUAxqhxIKTdLsreCXml
RFyE3MPy8IyJDgKABeJczTgP+P+eEgx3p3JEdzGRBOhK2e5FOxrECPiptOGRvXRd8ms9l1Nn
ZCqixOM8XhkGLT7CeAiNS4k6Pva3/EIL/YV3MkGO5INqZ+yElAnRsM4urzuXqUJ3lvNqh4Gs
ssMZ0CqKbLzuoNq1Epyb15okXkcyjR9+uvoTwZ6wJ8/2WGV3Bkl+IalLK7+f6btTxGXJgqZ+
emVeVQBB85XykJwlyPgl9DQbedYPR2hrSRV0tMGTfDP++9pYsD8muHmQf+Asjt876PxuFb9J
YkuH/jS3WO/RrjqEH8svG6pUDYpzW6cC787B8xm6preLvOfK3itO5iQ4aW3jhCF1SrG9R9Yl
nHvK7NkpKCBCu+6S/izpzSZuQR4t7QjrXJTKWX+u4VQRpgjCUwiyV/TW3YfJL1Ep9G04p9Vl
5dWh/mqgaWeHYymmNhzyU+RKTeuVfg3GPbJsHdswLjiw8s7iMDqImIQROUs95YaDT95by2rN
KJ+JpeSTgzLUocOG9iZfkQkOfBqOkyMBqEACoxz3fJgqQvxqVd7I5Yw8Ql1r1+sQdbgC52Lq
4JQ9AwJpCDLWJbx5gMg47fa3L2b3RM3Qkx8OAJ1/sCTobqIUK1GJLnsC81w/gm2LV+2eSaMZ
wgnxWxDZAbW1Xh5hGUK5Ex73Z77Di+8I+GdYC1CzSuOopiMVc7BgqK4mOmWGQFQKnEBAEDBq
OP81F3SF8mBelTr8QQwJGcHMUm1qyEtRTHKaNUAP1u2a2oe8ItJNs7JquIe5LmdT2XFDwCtx
9QOk0JlKh6Sa4yFhXJADfyu3NyKY6CTvWQuw+ffLsMiNBhmAOyDMMue0sYEE4UauaVqfpfMG
mqzeePHA83s6JU5oS3ORTXds9SLPyCwL25seH+qeh4NQ0YFRLJWZF7EmADUdi+F+eZcDqikt
BhMhtqnWWBFSkxjVc/YRkoSccrS7Jgh1j3nUqRgfW74YYPR2PrkmB7foWbIkKhwlsfWtYfgU
lBn1jqIG3HijjWwLK3pNugi5d1iTqvfZKoicJgF1a2+KzVu/ptOIlbsTFApaBv3/cK8PqLAg
WkzGZnBVxSP33B7AQSaXZXK8DMchjcAHWvZQIpGe+x9XAg34EKUO3Nko6ewS3wnD7t6kTDpg
PkQ5sSRe+F9og1oLDAonYccDyZoPHVpczmZedAJ0HgCiO7EZMLJG+/kYcmip7hiV9oBrPTEy
wxg5lgLscMBECI9WDBIuR5WsHTrqgNzdKaewR9rIWPKOWV7+fbabBgLcc0080mw8isYe+3Rv
C1IRA0m2MMi0Yk04BZEskkTdhGn7UpMhfU9TQQ9+4uqmxqGTHchSc0AOe2ye6NaA/KkQyLwJ
d3WFaDS/MW573wwwU5R9F9RoyPCAywYOCiel5tfSfG2O2WDzeI7C3NID6O033mtVwmXGc0NS
skHqUoSukxat91nvPlcShlpNBax49A/F6+AscNQH75ahN5AKBoeeI5DoC21RwkffZRZTBjGf
lb6H9xs7MJltr3BazIqYkDKLAaAo3QKjO63aSBKDROx4xwQ1VC1a8+QSyYNqbx77gnMyADKz
pvLzd8tVM+nW5cTMz1bRTZpzkfvUPYHhQ66oR/roHeyCE8BKiAowpvQPYy3e4UGFGHMkQy0L
bgj/lFJj0m1Nn4l0QaK2RXgJgIypllA2+Ms/8KdjqO5z0SJepPRr/8mnGx/IjOT3oWKYvYLj
JlYxdI6lDNhTMRU4ADsbWwUJUlqawLKRNiIdxELx5PYtegMPlNl7+Ot6w6T3Cp5sLQCpk2KD
kzIOLRpi0S4xyP0etnj4iJgd3zpStlGt6hNsXQ+WNmoLAcYHrQ4Mf2PyqsxLsRd1sUqKNZpU
vRxprCXZsS4yJkNq0AVJMwBrfaGAfIoHuhcnqINWkc91eF+z3k3Ge0crPW9ObJWTQRVJzhzR
5HvgmjVn9DCtw15OJiyucl8Ok+scKOc/p6SzLAK+vMdPw8gDyEQx/LZLIVphY5a7Ffmu7tt4
zqtfByNmjm2rOGYe5UhSTuJGCi1JRdwOGBUbhtDcgUDYW/XvpCN8oZ+w+B0qugG9nS7f1ZM0
L+ekQZ2PiMXGVBQDoS/2CU4QMMAqLJ/QyRT0vsj7ONM9Ls1p0qYdsl6GEHxseGc0soX8thnu
OCeVvZMe0L4bEvbJKvvuteXPgvzZ8vM+KgEbG5thbJh3GHCayev4Frjv/LuaIeoymAebTFQM
CK2Tu8KSmZgF6KhNrrD92GgDkgRCQqq1X0ANEy+Us+53nIgSOHuyf0AfnqC4WafRqb2VZ+QV
bnmP0k/W4xA71YC+BcB2LnKlmEuE5wwcnbYX6rV5W+MiP+hnijBzGb9bMi5VdQkWtH06VeDW
aiYzKr+6iolfYuH9mQquEOXs26ziU93X5OQ11m3X+l4KI+SIcEdWoVxMIY1edHEGkEtt75VS
MwFLm/WWRkvJEGXnJuJOU1jWUej05zmrNQL0BCPeAdWPGMkQMwUHaQ8CddYFA3TojePh8sKz
5po+qoZPZFSwyYT+UFWYMQD6+OeO+uG0rxq4zxbWPFw0qIhnAhQD2+vemOMQZFDl2IlkolGS
l49PGix+fzStvq3wSKVpxawkQVUnpm2sQVejGAAK/SlMZ+iypD7IhI+m0LvTUKBpVx1TE9jR
JS0z0SzQp4fjQmO1O2nBViQcUfn+0vBWNbQsKbcNdKFrlvYcWFkY7HMJFQunbpCaGrME/RKd
Fk+8p6ImkFTNUrUUMeTVIbDT6nRNHU2NS4ZiiyPxy4vkFR9YfkT4wYcV6T32fVLSCJApOkUj
y2jCpq1xzDZKlaqXzLy8QrBO1rZbG4LY+4A4TRAtEzeDqzOAdPtKjfbEpDkNLCZThBOBZh/b
b/mGwrenzUC8m11o4imp9lTj5dyaREefa3hAXVJyR3h1dO85560MbkHRIPWZTJvSlylIU1zj
WfFeDwr/7PKoCqHvsuweT3//6MvnrfpdU8HJ1XpxVddCGcsw+UvT9a00Ht/XyfjnI6bh3PPK
N04sBrfoAIM9+MMD7608fbWXc5odLYkXTzjdJ6dbPr/KeeiJxVZC5wkwWsCjPYH6IPjjvtdZ
kbDOe6BGfKiM5bfmd//pDoZjnk7Hk/vDx0Ge9K29cFXu2kSo/lqbC4SdeJy6K0/ehdK9Ltj+
GDDF4lmoXMUFUAH+HsTPzegB+pnk6jtpYRxlGJKan6TzVNWCFnpiysA8alsPOOCuX6TKNHPA
se/hPkBmgQ9YHBTeyBM5Fb5BEK9Pt11HE7fy3KfxQdJBELipuGEU408zJdn2tPeHp1+xv0Is
a8wjlw0kIINJxvPry1jEixNnuIOS68c/9YnhDg9x8gzHcXEZNvD/de/htpXy7+ME9rX2uDA3
BEgWuzdeRIbwlwdc74U2pU1UN4+/i0sb1kf8LQmTLkoW3tU6TyuJDPsSCDoeUNxvhvfAtobV
09xDFuRKkvVAZ2bFwZ9Q/AegSiojYBS+SmO9OCo7ZcpNzcWZOOZe+UB6Php797mo0jwgpJBz
d6SMQ2hYCndHJ9JBlNGDOq+xKBohzkMjfyYitl9Nv5bB0x1oeI2l5pxFpbusMqzswuoEPOzD
fRPuKSO7JsR2yREVuii1oWnde7lpTCH7tSCyTfaYQni5Y4vF9eGFRhHBUz9ErLHRKkSwSUpz
SFIXC/qRHyR9BmYYubFtq5NZg0C8sUHCLv0xYStvaePlhJ5Y/joaKbBTkCMXETG4oYbRm8Cu
QnuR8XHgpZEqPG5NmqjgoNwEUIrkqoFGDIa7+OU+yxEzjGMMxV/fF1GVxHyK/i06Pw0hi9Fq
rYYwM0WmyaJaDd28IR+Z73XWUYRwWpHiaOKMQAqmigaHW/+8s7Q/NWN6OiKgvOWM5fQddXLU
iDe9G/9sQKjk4V+Lqp4qnZtnkKQhDk60vhPWlvAdUFfEdGvjCseYHVENLg2MWKUlYoIL/AM4
Uryao2E6S2wlhC06xk06uGxDEev0sK3F9/wXvgam0ahRRGgtt1bmrugqF0CxdhmL0huAcw+5
vvvwYv+ZHy1gVENU8vpcVsfky0a2me63t6r1/J/glGyxpDouStLyR115CmP36HGAbR0ifVdK
gqeYi/fEiHdbzl/22XoTd3VPX74jsX1C0qIxrdCnnolhICNJu34JFPeyLUNsz5MVIEqw28bW
OJT4NELxCtKRtURRBAKFKjNIgqbLqFq+ANL2dSmX5upn7oogORut0KO/ODCZBo3j1whUwexn
RDUg/YfVVVL16K9y2ZaKPtYNC0XYLixLepZt3OmSoTiaxmwlfjGwNq34rYdnyDk77g+6yzQu
296VXhxGIH8JTacFm8DNCPvsBaHAoVOo63wdgfgRBCBLM1kZqeFCTtQ6jMxb9MO6BUN7a0xo
7FqMoHcvFB8S5dGx4rlbIoVQjQdgpUGsq86oJQ8uEnx5Bir7T7EYlisNXO/KGn1BzL+Y46Ra
6govAcaRmTh0b1hhrO+wd8ts/CkSfu1hQ9JE8vnxKD0o4bDrXDuyqGtOiC0WfNIPey89Fagm
tKtw8c791ZPBliqG+UNeEejgi/AkI56KUl3SXSakuVwMTZOuBPew89iZQfVOCw3Wa5ho49Pl
NyTlm+x2aeeSFHtAbcFhEpcp2gSIw5ylHwN7XJSwtSeTjttBr9AsOR+sVO7y8/ZjTawVTOVR
Gsd/ziAgWbfXn62YF4R1ooY0tu6Fc7bn/x+/qC0dSDoz6pbec2fCcsoIQo5e+HgSvWc3CVBo
eDYs5LmtqZgANcKFPc2TdCq01v6MAPGZh2EnwPOCgwOPzFu4aBPLPYyBA6iwzdyDOSmU7DrM
unT1LGLHF0epfR7PGLcMtAg5H1q7OmK/FdoGPnafaFAJVSES0MwC4EohevGIT0vUjNJbaLmr
UvMTOnn9106pG0VHISL097oh3k6cdmfzOwC63vCvSjvvY78u3RMODZkQ/2GOpvVgrtgffJkw
JMFmX6i9ncFv6TUsxoNrAM2OixyGC/qorCFU7tPLkrTxsVoHp5d84JRMgyCiY8xpzhyDBzqk
7DS8G69jVFFu5Qy3+/cfi6vQS/4Jln4M6qbOFwiLSCgRHIy0ikVNw9Qv57XexwUAhQkdP0Vd
NHjBgonam1ASjOpmIh1TuVGohyozR5Y2cgokzVqd9M/i83B8LEXFgbSx3mMXCF5iLRRWiEwP
wkTitjB3tXI0q/13/MXa174JkXNRf9Llfc0OpZp7+wvFMnTULSvSc1km1KyJBuJzoDNqRfSM
HH4wzq8hdv2YEX9B1kwidVem/CTAmwBKNBUqttKlmKgiHcB10UB0nAJZ7eMfgvsInJ9RYCcj
Au6LEA7ucYvIb+07FIqzeSLNeaIQOYODvHHPJgHmgxpOuOlIsh41s7qdbmNQRO8bssm+Xes2
mT4gaMmmtTy52EQL0EXv8u1tkBsdS8Ak/936lP9bVOcTNYd0iTHSjB60JXBnMcTvdQ9QodPf
l6I/ipapL39OkATXCqrnJOGZCYiRqzXs+qlcZ4JIr3UL30w66Pyf+WWXWh2EYrn7REOXtwkf
zGtAMbFTo/MAFFolZ1wFylkmx9oFVJckfv/PXeQII+5taHL+eyJB1NHmXYzJCboqQWP0o8kX
3ddHRXnhPIc1527HgSvzTWk3YM+g6BJroLY/p4/dt6XgEB35DAJaBtXzdh8AoU/Hih76vX8k
EnHJHK/+7V8VbkK5u7Y9xRi3VIZJHktRUGVC32NZYQmQI/ird0+nZuk6P0jk07ZlozbWTMLw
b+ZQUJHb4iZuAypI9MfycyDLNQruCQ0CH40HhTgmzvCqE3wwfxmltXnBgP7b+qnelZMruQuz
BLP3kR7VVEw04Jgd1oKxeRHvVCf4oUSN6XNTnDXYZQpmNJ7Lct46M59F23lB2GKd6EnIGHwF
gpVeN5B7rMlNwtCz/dJyPhA7hXBT/mX/MTwLEmw6cHGkv/soE68ptnaTAtXdDXiBTTpeoSJO
wP2O8cKzQ6t4XL3t36ev0mkpJiQBx8c+vMoPABPgflZiCeRsTuWnfXwbWhTQrkyPhw8o+Um1
1LHKG/jS/DTEwCkx1QrlqeBi7NDdjGutBBsQiotMmf0amk0FZ9VAC1vDjo/oyyX7QDsgUUwA
fYq/yM13rqVmTA027fJd5vpXR+ZPv0YU27JzfnLjxqmCWbnv6k6h6yduu1TBWYaTaFoPH1Hl
oT4N6b4iJfN4OEFpk+hFzI/pW4gkzIBdKWk+3ajBs1DsZSxhoTLLfKW+fNBltjfd8aGmmn4+
nN2KicK2VVnDUZw0Efk9BIxiUWpCx3CiIryFzG+cm6hv8LB79bB0ztpQnj5tr/+P59L8uhRK
lIZC4bpi6vPFeK6rufk1dWee453rAS9bAJeVc48rNFoSJxTt3DApgTuf/A6a8K4RUpJ7RYMb
3xUF+GO0J3AcBKqoqgWCQ+ps/R4nsPY+Hy//7TNOkfOirSXTxN1aBOHG3w5nhvUrqXykMrKJ
y502UIOekmIeCrShtNx0tAzbDYi6q76CnoFwZdZYqvKQFyU7C+PmKbNr1jQ26V/yXi5LHRwA
plPUvwvRZHaH8yA2Lwxaz8NfiZLHpTb4EBuHIZygn6ZSyWRF9u0IrbmMp0DT0QyZcnqyjdCt
bn4VMaB1gncffoypk3Ay1ebiXxwa19DuTdry+QMILcuss02uOkfeEmtsQXVVFFaAnOFBfMrq
C0mH3nUlkwgPVfXPMcqpz9yF1AQLgUJEPjbnm/VLLLk/yk+kajFmB0KCG40ZV4Pc+r3F+eyN
2BV+GxRZ644oN/ElJfv1LKaD4Itzbtg6ol1/Vgink29dSNoliY6l1xFcOFhTMq4RfCd3+Lj3
LCUT6gAihR9puVLvGkJa1naLERVJNhKOlwLUIxS+kVtDzDrZh1ypzp/eojZtCPN1lpgJiBrr
eDBa6OdbUW5QXxvu+QqsPvfWTAYUANrNGTZw5QWD0F3s4xmkslEFcR/RCpi1y1nu7jzS+v53
jyodIUDRzaeCAPD7gZJ7tn8bZfxpwWgv7yodBQE3moOqdYgfW/u9SnEWh6BzZh8I49RR86XY
CC4mXVnnJ2c8xr6LODFxh/3HLZIUQY6/V0PQ44vDMEOihXDrc5fn8l2zuDfhg/f+LDbJsbco
Pib3CI5JsxpukfDK80LziwCWCJyFlLHixxcXOyUtJgFoeNLtFCn6gSK9e3owAqaCP/07cNRk
8bYlMJVaMx1vCX3QJuLWqpySIzyBl1K2plVXpfs2NXm8k2orkbY5gKlfVv6wp04PCAK9ibLp
3YtmHqT9QR/6aJBseS+nsY0ngLlGrNyzzTUc444WgFdmV9RHouVlFZf879z2QDXw3l1j6THa
uVcalG154dRQxFhvWrfGl83UTcFMUr8Hn8rRPupqA/f5+bP3IPSfuMRYBGixVuy4n0JqvN08
NmuZD2A1snxvLBd2CY7RDFxcsej44WPAvcZe4yllHhnweoIQ5I8mOyrNbuL6qTay8v4v+s4b
Sr+v/4gB0H0iZbvk8gY7bBmjUAXYL27XyT1bDeHu6CtyWkdLMIPwbtWK19YoZCbVZTwTL1P9
BJqmla0wxV1oFMAkPKeRJmNb0hRQ3I+PVzt+Bq2YEk1/C2xLLaWXE6+jIxW1droPA1ie/wEm
ud0d3K9+c5x5F9hWoI4CUKuP0sw1rLCfqI92LYHQ/QaF9ONqV91CQCPJRHnJmi7H5s8FdJP/
KaPHRcLkSlQlAEtSqQGQe0P0v825sml9+YJAQQb/Uvd8u018zA4irrRSPOS+ecCkOuDX9Ngo
Lt+/fJ91o7l6qo+eEiAupLiGNMQ+AJ0LGNTl4YSQRXFOIzQXZiIMmHFdEDfMqjU4rxPR8Ziz
OFnlgH0XylG7OK3dC14/Wqg4GrmMJ3CRoaDTsT+fzrd4xeDUTC4gE4e3+Zdug8UR2RB4MTjg
E1qi/wumnf1gZDjYNN7sPATuutHwyknzJIWdf2x0yhCxfYNq/TWyqmqh6PnWnS05/kUggJzr
s+gBR7jS3AXyuaOd0j4mp8RQQ9MAT9rxzFvyhrjLzYMqzBoJNaWVji/E9yfCVOeGPiVCWjo7
FdVHN6gffb11LIY6VhaDR+t1CI8tPQn81EvvRleQWbJlCd8GhFITFm6FmD7DRiRHQnapc9gf
UF/dA+l45aiAYXOrzM7ZKsCjY1HcgSXu7/ro/QdxvX9N8vkWH+z4v5sVUPRhWisk+o7v5Urt
waGd4fJSDrdCiKdAyOSQ5m5gM5ODsML4x77ixN5zmGbgHJHsM3wVijA0IsJnUidgVvY5APuF
CDrAZtmT0IhJiWuJu1pcJEcN8kV75VbEJSIhBQPqxoxA+JIqZVC+u2TFfcFMqmNFFg1Hjefw
LyhUbvHYkXh2jxsRmnd1lAU1xOZ50uatIWia4IMJaU3ckE7gRMe/Ac6N2uC9JPs6sfJiuGj+
XjqkC1slwkLFQXy5ubQV7i9gzwxqbEzjLPSKnXWsTpPANsjIsxPdzlKkJjzmSB5IBJ06RRec
rvQbQmze2rBgG8Zv4weN+NkhT/DN7QkuhwZE8N1x7BVwuQPGgRioVyna59zxXm65s9jjTVq0
m7SFPTimK4bokqWzANXXHwwoI4wfj+56skNTukVSEWJSaCOmUhZhWYix1DOrNZBaeBkHUNof
pbdOg7lYaVUAp5BzuxiIScIu2epUvRHqhtN4C3NYDtoSaMbDAp94G2cooAdU8H4DLCS+5kEq
8GajYf3X1kf0NsP+4dwIEieb4koMagm2QJmtRHG7+N0LQM5M0afmd1wQMUS+caThaFbUgRjU
O7h8aTP/S3DYaPFVpN5gRj2DemZ7RzbN83OimJjJU5+M032bwfTl2Q9zlWjphs+1LJ0Uh9lA
fXGmF8iU++TTJroZv1Qapo8rlBDapbJkzTvIweZBVF39UeVAWl+sUmnbb6gEEKvDxqAJtKAN
9d1gk42t+eamhzsZTv+QhywG26vO9w47fF1NAqhEdJkFfsx34Pul7iRO16BaTNa1thPwMvq0
3UCz9bE/NUmxSRPUNlRgPbPq9AM2p0SndjNQ/okYfD8KLc1t/TDc40P8Q1odNhEB+8YbHJUL
/HezQHaAdfW4GxKnH91BotOoeZdE/64N5A20bG1K3gCfPtp+4hPBILsjsHIDvR0z1q7rHZFb
K+vWB1Brp3DfxrxL7yEENYh342MzvEf8zfV82Pseq6jZcWMEMqH82YuCOU7KWnqAeMD8k8I4
w3T9y2nvD9t8rIC6MUePSf7yuRbi84bXNQDrFns5CVXWUbhoDLJ6SfOza2gVdDqIMY6guES2
dOhPpx1feIPKwy8KTVV1UA/6wosdjzdS+qkCOu1XC5rQeK+Jm2+s1GpDdqYRZakg/6Tm0wBs
feyUHgwBGAWWTSmiq1CyZQ4dggEWexRB8fiJLRkGoClGAmsct88Uo69LQQM4D32TMRtbWYXD
NzZqPQs5Q64TyjQ0HwMgoSQDkeQ17GdWWspDqwntXU20Ab0FhjwSSeE8mfnDSiaaAtbmci8y
ul4iaHjPwI3p07dzl8JJklkpriCj4YlKrJagv0InE6rqIXvSsil7RcB9EYT4dRV9Mlq2I6qk
iq12TwH6Q2LJuP6itiuycAFuBN9cqAeXwPT+YQJVjembr5Asm7CxYyjoKQR4ALLe/Oa6SeYW
2eUpNvtVu+eKahsYqvBWk6uu0+XWyIU6kRGCPDOLcSkdHDQB9oNZUoaxYnBp9sZomDnEwLSs
xxAGkUn7MkmcLyuz7jThUJjpICGZ5S5fpeB4G3O1i96vFsTbXvzOenCvwQ6o+PnlJptd5YZD
8JNZBTtuAjAUVsem0sq7USgJ1lFkYOX/RUdCFGnpq5dMDkJCVRVlsA/TOWXqZKhZJMkXviD/
HN8V/lK8wBteV2fjyJIrxlfvayrTmUBFV2I9Ga1N95KLRvMBGZgf7KcC9x49b364jACCCSZ9
Z9RnwMKwcoNn46Cku32kAK7UFXg/zVffKVJmJ25NgZQVsQT3ZDZPM9CPx2fFGuv6URkLGSau
QW0RnZsRrhFOQbfcFf4wrXKz5TitFXRSk+3OwKjGcdDuXDIxtpC8WthYRkP3X2zeudiow8mw
WP/K6JpBHx6JCpr+UwqmLRIAQuC6VVh5AFcrpUAgBqEn1Jy9TqJPTGhZm9BTiBrvC+0OAih/
FbxMINdajXXJNeNRqgnVrL3PVfvXJ1JTFqd/g8hMvjKJnuklXDS+ymSFTBHhgZurItoA8KNB
A22En8/Gl3Cr15TDOA2r+KVRF88e7K3L4PYus1i5/wk2vN+G0hAPXOGhHKT5hakxmr/EpZJ3
aEhTC+UKawzvOpMqUDEiE9AB87WaP3I8f+wXTAWhZt/d9PmFhtje+Lk7IKoVIIb5/RLiWy+R
H1rMKDC2/8BVNvXdFXEu+nsoY5iD2aFX50F6K/1u2WenR+mlF5eyWuvtia95m+1oFyvB5Q9o
nVKXv9318qmyStHlVpXORSNr5S2FAJ+y5noUHUgVPzdz2FNAjDX6wu8YTLQISMvGZLoYOocH
7IV9XDuXognecXRF86LDNg8zQSxdzzC2od1Qkt2JvPX1qI4bb9XaMQ+xqGvTmp95VOdJFW2G
Km2quvLyd51mC2i9RfMhMTxDQTfh8L9UntHYDNLa7pih15IiWzF3MVxZGp4WnTmj6T/CDf6L
+mNAkIvsMZQ264XsK6BGCCG8MKmRLiuAUZ6dBtiq5gDI9xFsuFQsXqwHPuLCtcs5NSyMm+PQ
aiGsO6Sh2FJihowG1umdWVCS0PrXLnQHnPDEH1wBBGRqhYCe1fhL+zeW9gvjg/ExFp4Xxs+t
nxWmKI8hSC/BZ5GHFGUUzEA0bY6gUy8emTcM1apV686NeExTP5XUM0Qg1km9uXCcmDHezlwg
+6kBZdqADduPA/peONb/LDg27OqgTVeEt/ttXDIv/ZckmJOqaJOYtQVkxV9Gin1qIDYpq3Ds
V6toEDMBWPwU/tgL1BGJFnyRDuS6y0NnCZ2ikwNA4e63QnGkFKA6FtwinHDYo090SI+XLoDp
4Sh0cG/shhBk780wJe5F2xX+G6WkVCF2D87rxihOAO/BBjcVC/iUuakHHAkx4J+pTI/A5rp4
8IXIfLA1BpqDNAgKz1k2th/BbHaz4R6selBFkBnikvoGsZj64ikUYgPA5WsK4lQk7GPLkDP+
dZAB6+Eg9KysdRHclT9RG+G8kF/oHyuh1VitZdsdN11XOykLuzcmbK/ecroQ2R1rMe5wFuYP
KG1V74Kh6szrR/5tupEdmJoPebxPGMY6jbAXAM/9GuDZUr4myXdUhlZrFEiSY0WXrn3EweK2
dhekvBsZz9b0/ICoyZSCqRRTt1T0S6oiJRdnKHeTnnIHxI2gOPqSNZ3YYeEbuYxKXRyKQkRN
fYYih4yuxCFXhqiTqduJ60MtOQBWpZvbInGRu+hogXpcvESZ/0Lt2OZEMwAYJL9rfMTMUITt
bdeLXaxkOukHzRMI4M/uHitsfmYtPiVCqjQhIlfpBcFC5S6YxTH+74LhBrSzKoeJizdiOrGj
k3WP8+9JVH0MQ5sJr97USW5SMDXW+1iQqNqoPyMUylTYYoIH2F9my5YdbYzjGxHeX1pKEepR
hZ1+3di/HEpAwju38JOFMLWi+i7kBek64KJK8IJx40hyqp+WMm4KI+nuqNy9q7JG7go6AYNB
jjhFZD5ELwrnWdfaHBqHdPETo1Kt3mdQywQlThesmefgJj7P+DXmsR9ac2/KLfaNMf/H+l23
0OjKZFakHRFqleIMPL6eS8Zi1Rw+f/yktFPh+LH1xi2dv9JdLlhIj2NnGosaoER3hGfS6Vgc
6S+alspdtp69UPnnLLt9S+uG+HbYO3drK3V6p+PSwQNH7lrm+AA6MGI8L2H3C9p8daFxBye8
gbj07qE6eerOXUGAfAS/ZnEcIjDyLpc1+0E6baxooBa4YbbhrEVAOU/BQ0s5bejJDBWhfeZX
AA3n395P4YQZf4WTUjzXYK65GroMWhjcEHe9t2x6Jd48Ri/ldSQl+SX72+HcjJcpGFZVn8An
PJUXjQQ2DarJ3PR8n2rsgrX4J0GqPwNUIrTwpXEAHdR3zFUvIgU0Iw59EIWEVwj1gkNXHWsX
rLy4R6cp/W9xagPKaR0YExzTlo6Q2RWQCWuDUlzFVvnA4hCFoBLQnu3ZA1l48ycPdrj0GZ+o
9afdt2QHUJR6u9a8AjaFVIeV7j6CeRCYWE61M8Gn/U/5/n0zObAsOA5W2oMIjnDKRSYeakCt
6v4SvgAgmLebXhEoOVjWUeICAkU2DOft0CArvqW1LQ6gdfbI8M6H7BTPlbJIu/dI2sd0HMWK
i4NK2Tuy9LGQLkSbrM6PQ1APSfMs1ff8wc6zB2107zxsl/H3ogwJJTe4mdyFqOoR6TX7PLa7
GyQM+A3LokEnwBaTDVg28jrIPDACN3fX1N9wmBGVQUEV7HDFKXqGNyNN+e2uDbaGP9w8+chQ
thODcYeNR91qb2Jvss9dVLtYQ7ZuWfJ4Ytmdvpv+RsH2f3YChHpbIVatefeEDMlCeUTvqfcM
a4s4X4g+AJsHjnKDht+x+DykxSCu/6gfIIwsVIPRAqQMHjg0fp+T3UqlmrG89OZsr4lkBoJ7
APqJXVzc6i7jsHCbKAI0kZAviP0epgks0k4yG3bti2dOVADeNqa6rwsNTepS6NHhwexEaS6x
XwHNXeXycSg+prILDH+PXMLu8MruXtcOwzr2EB69R2+w65b0cYMUoKOTUrqbh7r/8clbuRRH
HWlRwLgJ4eYB2CDTyjhj+3ALiXztSd2O5RP8t4PZss3zX558v+Ar8tdo0F7YJdSUoJM1lGkw
0arOE3+7Td98Nvfvp2VPgQyIzwLbxtAO7+hJ5JEdjd/nbBO0+DtVCQWEf6Uv60j/+liJpPCv
xCb5RVLw2b+h5DdLRvLOBLfrvE995HhALet4JeTvmth2LNpEwsAqQcFtaKE/3yg76pxOWkCo
+rTp/HluuTs9+SQmaJzDtLuJovy9Q+Hn8i1WnfHAdEq4TlT/HAix7E7rU3X5nqH0lJ7eBPLd
f450zRoOLNxazNvlmCUBqU1qbNVCaYPfSsHdH0GI+6x7WzgKQrJzL/XASJdl4hNB5QXNThfU
H83/xHvs3amZSfvAcADoI3qoVLcRK2nC/y9oBQtz3D+3QLQ7cOu0YdqyX4j9O1VFGk2ScABp
BSUvQc32n3wN8vwUeMv3jxa0T39+PlUU0ltFf+FaC7pI4e8zrlbe+5pdCndEuSp/2cm/racw
913XAecLvhTffTwW8VcjquGIDgBmgLKMKyUOqpzIzR/0WpH/VVZzDChzl6z2vn/MhfIadalz
XlC/3WMrm9NtIQ/WGGATe2IhY0TaLpPnj38vBVfiTgJWJ/81qhpXuiYQk4R5cbacFO30FTR6
63B2opQQFbunL3dXorYTJKWEYynuWER7bGYVyqgD8togxWwb4kbzQ4PNFYzuhDZPf1DFESpB
yTMAz9idXFWHAtdTGABvtyga75heWA6bPtrlj1MbguISfb5lA+cp9/19ALUgI3DYbIXcyGtB
vkYU/ns/IxNUpSSORgtjR1pzAceNO4XOSW7mcbSDLJyc9lRsMu2jdwL5+eGmQFDevqN8AxLT
RgEFeiTrgQwn9iWCssTDWWJggTDWl3dfhGuxxJR3jlrL1p3deWTUXGsOi8PvR4puSlCkVphA
R23d+DL1H8iisd+D3+nkstrmFLSaTZ8JMkG3+ajdpS1D1OFA4vmTvA1g4AJgah85n3oeQRww
l0ywFZgmqMYgObYmRChV770T/n8oqwOcdlwDJtyB7Vi6Tf1FE5JyekBsGkYYSjhIvnhlBePi
z7s+TFEdbvIr35fPcAUHSncLTNy8UfKX0jn6pY1pc/g+lvr4Pe6gCXWEehSpLCyQp7nyqNt1
5auErpFZh6ICh4GZNoMzgDbMR6PcG8pnGEnfHkTT/XHtw+LhwB0RpiWbEf0DwqfytRqn0pIk
9edCIDyKW19bbwQdYyUjt7l9L1Qa36l+UHsEOA/xtQ0KhSJP/AjdPKJ2h1WWFAbXWmeZIrXo
Hj29Odt8IQ1+RO/lNWhKF1e3cSPYR3OBn6oz7Nm5gyaEX8bivRYN7QBI5DllmlRSMySTpKJZ
c6T1j8QfV5YBYcjS1lVTmrF+e0ipOLP0yaFroKRtpgH1eOW2svTc+k/tD7N9sErZUxGCfXES
XbrY+H1ujUZJAD312UHejlFoLlztcD15IOxf23YFiIfx04tFXRjGW8pdMhhPZYzksoC/w2fc
dJKQDHsql5Z8bQNgi/coKTyG5aYRG4QkxUL8mlJSjmTGgrM+eGtkpsU/4HdIfya7IaPoA7hQ
cRN0Lg+1wjvTKbjUAHbCnHuLwokbGQ0dyoy0D/pXHalaWcpRG++kYnt1MJoFAPLUyFko3MQR
r+dvfIa5sBV3GMQ8SSLGWVrTceLFHyq+cwYbV9D4wojGXpIHqqzgnvoVZbPognuq8Emapw5/
Jc70wEZXDCb4RmWXqdwIP+1Js6/CZPlg/ut6fHkTBPDcCSOzjQwdQivGonKh7XlIdvfApHEt
kT90HpRf0eFmmcxQrG2oKUUk4VvalfeTYHc59gUrwmfznZOkTlVuZL+HJ8ABqDYF5oPILjlr
ssY4uc0qcJgDXXEPx6btfN2oawVT1zv1MCErycB4cPOdnzDfwbm8lSBgQX3NuB6IYV5lxAgZ
aK1CA8pXi/gs/X6b9+FR8FmztdwFm8AykvNBy6PHSUv0Ml+IyGdLZvMdg3Z6S/wsss/FdJNI
zfPWBD99LyA7msdHdNjKAi6x7vXPSkijJA5fmpSkTJOIJFmeYOeyIPbLUM9zIwxfP7RBajZ8
3+Lzivud+BYk6yZ0aS1tglYCOJVOYdSVNzhkHyLwMHOhpaz5jgO8YoyILSAO47Iy+TorxScv
HPZmTjflt0gWgkEn2CXDEnikMyd1FPFU1caazBhHYcJ+xDXYA8dwqfUPbZsWEgRlxN2xCQzf
JXCDn5m99UKFjx0CgXsFgbZbc6hxrortJIUsA2SKvnd8wQesLEy20kAambUuwtdZewVSyA5V
hkNNKjuRcvu4xGt3TL5z8JwBOAdmhHHtNjIwZ88L79TFAOghg8huw7rOQHge01vMTZ/KqS2P
Hwqb15Innvyx9qTDMrJDi3loNYy4654nEk/F6/+a+OL5Dzw5oAl45EtE4OO0sH/eKr6oqRn0
PgahaBk7gUatppIyN8FFk99UpIAIyb/XP7/RM3yqDvcHiNPUe9CdZaEpWIZHLyO3CzPw2Hyp
CIEQZRgmk8QjZdJeMy+QOkVHuahyvAdK9QY1jQebM2hI5zkWXZvY2yFwRHqx9F9RDMmu5BvN
gaSYg3ucH/XXEKgmnUGx1xIRW3ABDEC1RjwKMd81Wvk6KJfRTMKOvKywU0iJH2kvoPgwBVW/
qMQQhGH6LqmikqfCgxPP9k2J2iI6Bp+JUW2tvVEGsQ7qUxLDC5/jblKGUlMfaoQJCHXwuT/V
ncWgx2Yze5AK0sI36GuDnjcVKESC/+5XsG+h/h6m81Ql+o/t7zJxBnmzal2gS37kTDELH9SA
jTQ1MEgPsKJtLQFagj4QckzqsBG2l5uFH7f0phHkK6xsohbTBWYA8m+tWakO1KtPeSQnazvk
nOgy1vD3JYGRxc7a74KeyMP2owNpGbEnlNaCJlvzFlmY1KtFr9TT8K2sPo6SXembrE3UIJxr
dP6oxVcM4/qd3cu1Tg7AQgxreLNnyx5yaTBY2UhDhNW1RxL3sEyoUaRLlUYT+uRmut5H2lx3
frIJQOigXUQvK8KKqMaoKn7bLHHbyrdlrY/319KGrFNZ8IZlatjPm5kRBsIkfuKIiPe9O/IX
2KMWayL7V74QScGydNVXIUHceasyFaCP1ZLuTe9/gmzZMgjNdffelUj6UGegSuHQ3f4hDIBc
cdl95ZqPyKx7MWtOF2Y70ZHL8fHAcINEVmRQbZ2KCD3/aEPIhyQ5ok+6Aqu3sRCTG8kdslXs
iDrQXjQpCVlNdCUZSXlutfnk9dNzZiQBHVZbajpFTVnqBOCUBv/drSVahT+0tm8735cT189R
wwxbIEJ+Gky+118HmtHWhMU7ff12iVh/PndKuJ1GfkrkE1J8b0GFPDqNBW2pS1y8Z+3g7Lst
9aw6sb3HxDg43F3wH5B8ihl4h7EmrL8BGh+/uOhl9i6F7LHHkREAqi1sNL/nzcwF4wWS29Hg
z2w2UmCsQ6jzJxwJjL2KWVu8CFrUvsSBYouTwQW1q/miHyuQVjvbDUN/mN+vJIJXIUQHnwCg
cvbHcnbR69/Cgx4yC7OX0S4OGQ2XYuDtDr/mWUsGG67WO4CmauQgu0iiGthOQpL7rirdFagT
pCyWbG38ozF2x7Yg0PmJarFflJREvNvwpPG+HHkObZk7gO5uBCNUQwz0ipCD6tchEnHnGHkK
SQOkPuYWHDjkoKkfb9iUhO1M3ugTfq1rjAWuQw2rXNC48ceK7Rn3lFqUF4INZuVJwb/ZdJci
vYQyTE1oeyEi+p9JriZeAPx85kDxiQtML+2nC5+/lzV5MRABSlVvdkKN9zPfSR4PvNA85JaL
pCg6iff3ME9piB6MhjoeOYAlSrgER0j+nGNBe5Ymt39QOl100SvNQ/mVs4uMn0AEPa8PGWO+
vR6S+i6WlCPJnMQ6rdavlTEEowCsfOQ2KNnMJKfUh814FHVjoIOf6JqB5D8+mIGS5MQ4IxbQ
0uxUkrOd8GRFm9SCSgiwyn29YdURrJnc/G4j6FwIO9D9zfsQOWge8b8Z9Sod50GP0dgcEM4O
toTCicw7xPAwV5zsD/4SIxqDkhcHvInRgVIq0+wBLxJXAzSiJauHmYdiZVQVRrrjhQwcF/pk
bhDPFJAn1i3Z0RxuKF78JwpTpJ3uRioWRFNzEZOrOQCI3arzgnHxLSTajW/L+9jly377DBkW
KfA/MJNhpZXOAqKCpfberOchsnxxQQpzxmK0+IouTxMYHNsUwwAf8HQQZOyag1VYqIAtoz3E
9lO6ApDAQgkqqfP+H7G2Md9YmCRUxBBN6hVZmav53DevhIoTgqGoHmPjtgQZFenXwKeIg4tx
bdF/Bujum5IeLmyt6qiY1RauKOtDqX06GcNBCENPuCxWv7HS5kVqRayReoSY22Z22jWKy4uX
LJ86iUwpzOVxij1EAuFEcFaaGegAMSD3IKi84x48xpPDJIYgZH0ySDKT9KmJ6SK5xYIAAc1e
CNe5LtSXQ2Ny3HI40HkU9bUhDyZrNCQoPtRyvplPihoSbahPuQU1Ejr56E7JpWTcHa51RXdW
SDHC9OWjRQkMC1AdI3L4hN/nz/Z8AtoOGIProg96mquw+HLzihhoZQjRzD3tzEUooGzKXZG6
SuNIse4Cg+lZvGGQj34aZ84Ac/HZP4HcT8eZ5So8IJM97BiJRvBPZKjScYzBVSmliVQq22d5
Pvilux5Z/DXFKCo8+jvOTQAoJK8C/Rhn2otJcTJBszrVgPusWYKN2u5ecPKESNnK8maAx54o
baV4TprRUXY4kCpdSVEQYT4sbM0flO0ksAwrjX7Dpmya3GZZo1N7GL8hBF0N/pyT6IfURo/R
odCOlMSiL4xfMcd3mfSZUs+Ka1u0R/97kq6Q2AIaQQuwkG/UAXlqzQ72DH/lKxuFeKvrtViV
H4dv5d4wmZ+D7AInfBtosCHZY+xKDVgI1sEV3hU+xxcEB4lReBshQqB8dVYRkNG0ZnRw2Ux8
UVIkOiCZ/gqRUFpoZNvYBjR9+aPJM/NKTn/SNdKOt4mXT44SP8I7j6Dqr0mVvvrRPgnPDzoc
hrDQ4VDiIrgb4mgOuKCSFKQgSitNG/YN/iOZ8ScRavywfsZQVA493dhsHglkA23xoLxsdAxk
XTB2B160/3ZTKF0AiXddqh75TcdzSXrFCHr2mI43zGFRvJuMS+6CIp20eZ32nHXFIo2mXq9U
4JFIZf3vqJ/MXsnTd4J97mIBmvj4/qP7BaPItCTHEVxzM6nhpEeZgvbpdEH4wYCSmaoZHchL
rN2dHT51Ft9EnfikHbAjzjGJQK10hmURKf+kuPtfFbjTGbk2AXjYj+l/ypakOPo7+uhBkoaB
P9gA4c0xOnfegVmabxR8lAwwRk/bUyv5oDn3gersl/cY6/0Hi1d/PJ3ly87cux2Uk7fTLZXG
Q8lfdbiH62U8+VLxyke1vTgL7zHW/DpOk+s1f6P2VhX90wrUK2rB1LO2+SFUftlD+FRGviT7
5iRZTlJIQSiQ0cA0+iEBiRri2wiV1bhhejKjpp9hbKW8p6gpHoRjO9yc7jGnoMBJUJYpOY9/
aIefsXX+Rr2ddXUgDxzOOMFwQSqI4ZLY92ZyvxgafWl+JhCz9Dku2R0H7obeYcbGPY+ay/vL
kU5uR1gCK7gQnpGIJRi0pUJ6WHUhoZoJFb0h+XAXp+UyYwGFcRpvpdm/xw9O+/e+8UocAEhw
jU8O+dJYUcwhz0x4pxIhDve1rfP+3WVYp/4BIPnjb/5dvmLn/mU760x2J/HZCfFJr0VkPMPh
eUi5nG2K4Y3OVsbg8Q6IZ6qeax42eLcM62nVnE+SysDXrn2SicqBetLDzlOc63A1sZ84iu5M
g1iDAOMgi8q4N3rRcxhFbYEmVTjxFpKnfca8M6d+URePhOhX4ry+0Z+gRIRo1NGy13NmJ0fz
c3OEie4c+pz+GhqyKUwJkjBrHC1KMRR4Pc2QIYuf07ThFrZhMZQhHK3UxujiVD+OOQM/PZ8b
RYMOGJaDB9cJ6bvpUGm1xjH90uRXdi1BS21Y1Tbjtj4jKbLjNyp75q+H8CHciAuDyQ7aVLjd
goaf6fEBS1ndTTj9q3gStTR9iZRGW+PnZMCrs8V0gYpq5sngxL7gwzctjcjLz7cAKn/t5F3/
nSR/9suQDJO9faRgerT239Z/wrLrPYhfIoRsvsiUVTm7zqoL9m4U6UYNVTCUhYPh6fNTo7Ya
RvlM9UyajXJ8hN7gDuHrmXctPY3lWuP1rjCAF62gxzdvKxqKbBqcWLEhH/OPlZEv0waBtvpa
ty8vcP4wp7HcOH9zQp4vE6Z75+FqMaUFJrzN31ksntY2O2rr0H6AU5me+MOskawDWdNqyEzV
3S6z0TtlM/VxVzXzpsSiZreDRcQ5K9DFVnbW1HsajQ2uEExW0QyxCfImLetCYxprkzGAA9Jj
6xsD7CwNeml+QfLWRxs37nJjV88+X6EB1GmmNa3vLD4561ocbr83p8gASQIvZQ3KflhspGAp
ipdVrfipS0uLBh2HMtJECxzNrL8De0co23LuF6TbQ01M7YqM2wEJAkUH9ZQkrD2tJQz+53T5
JfajoLbdDfhXini2Dh6VCT5MtaV59KDCp5OhhHNfDLfB6cwwMNoAs1xiBSfK3cu0y6UTApcT
HQlkmvX8I722N5R4AArvqLCO1kcfooH2GCUfFIOLi0Cp/u9amFZqc0SM3Hv+DL6V8uZOekdI
+7IKCgF/qOkNG2ZZkCHfjZpFGuAq4i+mH+uhKPfzv2a+XFmznJaD6kErZ3Yf7VlZ1rjH0CdA
z8vaCHs8Em4y8L3yyrqr/IKDXMYqdpmS/mBKcEaAina6O404hFutXZYXsppKAhxPRclswZtM
6wW24MbpUU7FGgnykL9qgcqiW9kzRFUpgDn+jOYoqzzxIsxudznsF2p7B86TwaR9/AwwYz2y
cxK35pNpO6gFk5Ob/s7tmDcIDd7wIc4SsOAeaRiAmtOjiqQvwmrG3mothjAG1hZvENRTcq5o
2Zqdx0DFtkUg7xgKps+unv3xgECt9O4A9luG4asTCCnkR9B6qJrSlfwYvLg+jH2UJvXi6pK1
4WeyCrkqShi/O9XbNZdQC8RKmCuZMnFjXxFq+VCYvJFZcHR9uCqAWR0zIxxfXcmWbJt2yL3r
wZCA3qP8JOYnb7AksLOTgI+2IekH0FYPtPB+b5qq2otuEGIrlCtsOoYCN+5HE70xxslkQzEM
o56fC9xEW4cd9ZtVVlxzjSYws4hll2gkQo8P4Uw9dxTVZkGfLUsvPYRKnkKE3CvdC46kdAvk
XO0EhdoQ2Ac1Nmqcc73yIM0YpBaYaqM/6mkH9sGgXKYYOG8Zh9toStRTCMkErvIPvIwia/cU
w2dN9v22XQdX+jupn/Q471JXSIUXasLuycMlypytK60hfhLhOf6i2o7upSqcR6VkEW0vOQvv
oFDcMtrhpKNxFjhWwtKmA2+V1/XUJzeJ/ClFj5g5SBmdlsiq7q7x7++3qqbCJ6+lvOAQM8KI
fqmQFL58BNykmplPeZKfBl+ufdKBzy8duhlCUCKCATZAHslP20wIwdF6tmbTf62yss/Gd5qc
4rBWWbs2w5Df8J981hPyHitCKYnrDkDQWtpEczUKP3gcSfUnjHq92Ep6q8zBe0VfRXBLDhTc
gOmTLH3dau6GHi5neIC65uau4f6Ee8G9+NeeXi8/MYhGN5iUj2h8HAlARsGZN+DKNZKfOJia
FWvFvvijDL/ZhLFYgd8KcgbPXB7TQpx59b865tGZUaDls/JsYtUTXYDchxL1aUjFuSomf75T
vDO38znADeoOtzZxAuuRHa8mFFrlsdr8WTwhgEY/zrRC6LnzR69Gi1YLfFR7G+AFztLUi8hH
Y1KvfIjos3pJzsOuDLgegwOpwbcJpsJ2A19Gm79v/SvOTX2QzweMDzvnwW1x045rKB9QJB4D
CX/NqUtB8wXB6b7vc3f+0Ym4ZFVKjg1CxbyLqwoSmxwsRHm+W0AtNEj8Jz25XlTZrQJjMfCS
4XZHemIieBCixzGvlctHx6StJy0WoBzJdnvx4GzUH6T3cTQwxr7jIY0d9PpKanH4oWA5jwWe
BcIDyuDrqdL/KjeCWu20ek2EPeYdBxp9xqlrBu8YncOgp7nfXgLuDF9b/48cbDY4O3aGXwqt
54B3Tmk7rQHwriBVwCFb7cluMgg7yHvO5o6twZkFlN173g60eXuexxRI6XcJ/8UMbMoPJA2+
Nv/b7ucuwgB9l37AIRILJxBtdV7T3EpwazhDJDjZEL7jm0Iz+8L4nwEBQzUkFsaiLoIlQ3zT
HpG1iGbJ3PCHPmYUEABSzZSSgh2dyC1TKah1//tgG314mpLhYF1JqfclqHM9DOWf/AJa7qhs
7QJPjOR4kmyyMGIHG4HMGbcrpCWTvR5mBpAISbgkH1DkwTKqPmE5ZbwIOcwd9UauUyFCtkl1
MDGzaZGo9PByCZ/PFbwjbE5ewFRiBXj+uwujJfDmi/IlzqVS5BZmPo2yvjbLJggUcMq8nOid
VFIMO8vOVKdj8HTo7OLU/cAOWViDa8IBKA82tuuy/ZpkVkrGlo0JQo6utVTT+FMQpFzdGcUL
sIa0yxfVGWdxbkyeu2FTYa56xZ7HE8aSi3nr542QvduskV75iqpxnVZYjzDkCMnfUy43YI6i
JzqTO67rAbQoYzttiN+CbdxHwlLNsGwHiRLziDbtNcfCI4j1q/XtcRG3KT4xHDQt9HySvzRT
uQWOAQ8KlMaAEdg63mUc5xasLGuZilZkcl95a7TulIq8e1ItbUJ+L1/7R88r02ALTmO+DdRq
mJWQp5KrjDnSQEj0UGKcB6BeTe/4PS3DrZuNvXXGDLQB+6KfSVYmTlXH6ZdElFw4xhe/S5ll
IQxGOTuhoys/81pB5+XbMNc3jk8HM7LIJKJVAoSdxFpvjR7LU9gXW19STsZ8d6U0aVQm4rzB
7dUt64wH32X7q6twPqPN64jUkHiy9wfuh0WYMZgn8B19J1fRIzE2HptbuyHdiCAUz/W9zib7
2ehCmHNQBcW9PPr4mhB5ysDCducwXGglAhqyRRCfMdvfshEXOoLIGMs0YTDeIHLCdQbr5mPI
nK7UdPPhbljBLr/acxEvG9JTKkA3y10WOceWwf2b+YOWAb8KwmZow4lm5RrgpI7yjDiOLuer
nj0p1LioXujClFD9sezC1e21N29bQPsXOB1K4YIBuwhuMTHKNMHYdBg7I6xt7kn4DJg1c9pw
BjeNzaRwa6Rvg/QPQ2TtboWzjqXheE4CaWVeU4bjRQXmV/0jhnia/cn3l8mYDyEeswBsUkrj
8QwryE5+iTYWF/b7Q1X2JAqQAiW1k4KCNOebqy6g7ghm0gxN3/Q4WHsWNnWjgIhiq8bcu5a4
BGjNcazJvxCvE17IGGCSXwux23bigDjk4c/kdfZgKTKe/8F9BUn8PcGePlAO+GZqTOL25ObF
XeVY5/v8obiYhUtc6dxthvcU4pS17doqUTd8euBWTL7rJBJ+II9SxprxoSER3oUzEPBZatgg
0vb9re/NjSZ38icQy8dXZYAMNjVcsqDRXsvE52+n8R1PLcJSXV80dVfmboNMFdHZO0kC2sN1
OD1cOtjkaAJJnjT6RnoYlD3QqIp9hj3fITSv+n0FF0Ucgu3vnsKg30zpfMyW0NCnmhFzJqfG
fRbH+gBtEnGDMDdGqPYx3AN0pDkbtrczerklq53bx5Atgwz1NyEWxfTvEMcs89Hv9WuqTgAO
VNfOEI8GHB0epAzJxwPcEFyYOSrZMSRWFp4AAAAAttxjWBRNdzIAAcKNAcT7EoYP6PyxxGf7
AgAAAAAEWVo=

--GvXjxJ+pjyke8COw--
