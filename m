Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:44330 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471Ab2IYT1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 15:27:13 -0400
Message-ID: <50620147.4060106@sandia.gov>
Date: Tue, 25 Sep 2012 13:08:55 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
cc: "Josef Bacik" <jbacik@fusionio.com>
Subject: various processes blocked in btrfs_tree_read_lock for more than
 120 secs
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm hitting the following on a btrfs filesystem used as
a Ceph OSD data store, under a heavy write load.

My kernel is current Linus master (commit 56d27adcb536)
merged with Josef Bacik's btrfs-next master (commit d5b04fb3bbb6).

What can I do to help resolve this?

[ 1558.754105] INFO: task btrfs-endio-wri:28012 blocked for more than 120 seconds.
[ 1558.761569] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1558.769575] btrfs-endio-wri D ffffffff8160b9c0     0 28012      2 0x00000000
[ 1558.777063]  ffff8806230b39c0 0000000000000046 0000000000000002 ffff8806230b3fd8
[ 1558.785725]  ffff8806230b2010 ffff8806230b2000 ffff8806230b2000 ffff8806230b2000
[ 1558.793776]  ffff8806230b3fd8 ffff8806230b2000 ffff8806245a9740 ffff880615825d00
[ 1558.802396] Call Trace:
[ 1558.805018]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1558.810189]  [<ffffffffa05c7423>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1558.817223]  [<ffffffff810660a0>] ? wake_up_bit+0x40/0x40
[ 1558.822851]  [<ffffffffa056cf53>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1558.830150]  [<ffffffffa0575000>] btrfs_search_slot+0x1f0/0x730 [btrfs]
[ 1558.837722]  [<ffffffffa0588dbd>] btrfs_lookup_file_extent+0x3d/0x40 [btrfs]
[ 1558.845099]  [<ffffffffa05a80e1>] __btrfs_drop_extents+0x171/0xad0 [btrfs]
[ 1558.852506]  [<ffffffff8114b3eb>] ? kmem_cache_alloc+0xcb/0x160
[ 1558.858602]  [<ffffffffa05a9443>] btrfs_drop_extents+0x73/0xa0 [btrfs]
[ 1558.865457]  [<ffffffffa059a1c0>] insert_reserved_file_extent.clone.0+0x80/0x2a0 [btrfs]
[ 1558.873999]  [<ffffffffa059640b>] ? start_transaction+0x3cb/0x450 [btrfs]
[ 1558.881239]  [<ffffffffa05a4bc9>] btrfs_finish_ordered_io+0x339/0x4d0 [btrfs]
[ 1558.888608]  [<ffffffffa05a4d75>] finish_ordered_fn+0x15/0x20 [btrfs]
[ 1558.895352]  [<ffffffffa05bfbd2>] worker_loop+0x1a2/0x400 [btrfs]
[ 1558.901753]  [<ffffffffa05bfa30>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[ 1558.910128]  [<ffffffffa05bfa30>] ? check_pending_worker_creates+0xe0/0xe0 [btrfs]
[ 1558.918228]  [<ffffffff81065b66>] kthread+0x96/0xa0
[ 1558.923339]  [<ffffffff81495c24>] kernel_thread_helper+0x4/0x10
[ 1558.929821]  [<ffffffff8148ca46>] ? retint_restore_args+0xe/0xe
[ 1558.935920]  [<ffffffff81065ad0>] ? __init_kthread_worker+0x40/0x40
[ 1558.942694]  [<ffffffff81495c20>] ? gs_change+0xb/0xb
[ 1558.948170] INFO: task flush-btrfs-21:31685 blocked for more than 120 seconds.
[ 1558.955408] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1558.963274] flush-btrfs-21  D ffffffff8160b9c0     0 31685      2 0x00000000
[ 1558.970602]  ffff8806074d3470 0000000000000046 0000000000000002 ffff8806074d3fd8
[ 1558.978333]  ffff8806074d2010 ffff8806074d2000 ffff8806074d2000 ffff8806074d2000
[ 1558.986052]  ffff8806074d3fd8 ffff8806074d2000 ffff8806245aae80 ffff8804cf048000
[ 1558.993744] Call Trace:
[ 1558.996238]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1559.001243]  [<ffffffffa05c7423>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.008057]  [<ffffffff810660a0>] ? wake_up_bit+0x40/0x40
[ 1559.013554]  [<ffffffffa056cf53>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1559.020788]  [<ffffffffa0575000>] btrfs_search_slot+0x1f0/0x730 [btrfs]
[ 1559.027451]  [<ffffffffa05aa4c7>] ? free_extent_map+0x87/0x90 [btrfs]
[ 1559.033957]  [<ffffffffa0588dbd>] btrfs_lookup_file_extent+0x3d/0x40 [btrfs]
[ 1559.041062]  [<ffffffffa05a80e1>] __btrfs_drop_extents+0x171/0xad0 [btrfs]
[ 1559.047977]  [<ffffffff8114b3eb>] ? kmem_cache_alloc+0xcb/0x160
[ 1559.053948]  [<ffffffffa05a9443>] btrfs_drop_extents+0x73/0xa0 [btrfs]
[ 1559.060698]  [<ffffffffa059cc85>] cow_file_range_inline+0xe5/0x1c0 [btrfs]
[ 1559.067807]  [<ffffffffa059ced2>] cow_file_range+0x172/0x4a0 [btrfs]
[ 1559.074296]  [<ffffffffa059f27b>] run_delalloc_range+0x7b/0xa0 [btrfs]
[ 1559.080967]  [<ffffffffa05b406d>] __extent_writepage+0x22d/0x740 [btrfs]
[ 1559.087868]  [<ffffffffa0597757>] ? btrfs_add_delayed_iput+0x77/0xe0 [btrfs]
[ 1559.095034]  [<ffffffff810fcad8>] ? find_get_pages_tag+0x148/0x190
[ 1559.101329]  [<ffffffffa05b4972>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1559.109465]  [<ffffffffa05b4b47>] extent_writepages+0x47/0x60 [btrfs]
[ 1559.116008]  [<ffffffffa05a2790>] ? btrfs_update_time+0xb0/0xb0 [btrfs]
[ 1559.122716]  [<ffffffffa0599987>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1559.129211]  [<ffffffff81108a03>] do_writepages+0x23/0x40
[ 1559.134701]  [<ffffffff8117f94b>] __writeback_single_inode+0x4b/0x180
[ 1559.141198]  [<ffffffff81065f77>] ? bit_waitqueue+0x17/0xc0
[ 1559.147201]  [<ffffffff811820f6>] writeback_sb_inodes+0x286/0x390
[ 1559.153365]  [<ffffffff81182286>] __writeback_inodes_wb+0x86/0xd0
[ 1559.159509]  [<ffffffff811824fb>] wb_writeback+0x18b/0x320
[ 1559.165082]  [<ffffffff81182884>] wb_do_writeback+0x1f4/0x290
[ 1559.170988]  [<ffffffff814897b2>] ? schedule_timeout+0x1d2/0x240
[ 1559.177249]  [<ffffffff81182a03>] bdi_writeback_thread+0xe3/0x2c0
[ 1559.183685]  [<ffffffff81182920>] ? wb_do_writeback+0x290/0x290
[ 1559.189740]  [<ffffffff81182920>] ? wb_do_writeback+0x290/0x290
[ 1559.195878]  [<ffffffff81065b66>] kthread+0x96/0xa0
[ 1559.200874]  [<ffffffff81495c24>] kernel_thread_helper+0x4/0x10
[ 1559.207540]  [<ffffffff8148ca46>] ? retint_restore_args+0xe/0xe
[ 1559.213718]  [<ffffffff81065ad0>] ? __init_kthread_worker+0x40/0x40
[ 1559.220087]  [<ffffffff81495c20>] ? gs_change+0xb/0xb
[ 1559.226637] INFO: task ceph-osd:38318 blocked for more than 120 seconds.
[ 1559.233338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.241157] ceph-osd        D 000000000000000e     0 38318      1 0x00000000
[ 1559.248729]  ffff880320e499c8 0000000000000086 0000000000000002 ffff880320e49fd8
[ 1559.256282]  ffff880320e48010 ffff880320e48000 ffff880320e48000 ffff880320e48000
[ 1559.263784]  ffff880320e49fd8 ffff880320e48000 ffff88032a7fc5c0 ffff880320e40000
[ 1559.271254] Call Trace:
[ 1559.273783]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1559.278805]  [<ffffffffa05c7423>] btrfs_tree_read_lock+0xf3/0x140 [btrfs]
[ 1559.285636]  [<ffffffff810660a0>] ? wake_up_bit+0x40/0x40
[ 1559.291082]  [<ffffffffa056cf53>] btrfs_read_lock_root_node+0x23/0x50 [btrfs]
[ 1559.298278]  [<ffffffffa0575000>] btrfs_search_slot+0x1f0/0x730 [btrfs]
[ 1559.304910]  [<ffffffffa05886cd>] btrfs_lookup_dir_item+0x7d/0xd0 [btrfs]
[ 1559.311720]  [<ffffffffa059fd34>] btrfs_lookup_dentry+0xe4/0x360 [btrfs]
[ 1559.318439]  [<ffffffffa059ffcd>] btrfs_lookup+0x1d/0x70 [btrfs]
[ 1559.324543]  [<ffffffff811622db>] ? lookup_dcache+0x9b/0xd0
[ 1559.330117]  [<ffffffff81161ce6>] lookup_real+0x36/0x60
[ 1559.335352]  [<ffffffff81162348>] __lookup_hash+0x38/0x50
[ 1559.340761]  [<ffffffff811623c2>] lookup_slow+0x62/0xe0
[ 1559.345990]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1559.351494]  [<ffffffff8114b36f>] ? kmem_cache_alloc+0x4f/0x160
[ 1559.357465]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1559.362990]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1559.368871]  [<ffffffff8115c399>] ? cp_new_stat+0x129/0x140
[ 1559.374551]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1559.379855]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1559.385077]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1559.390086]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1559.395415]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1559.401871]  [<ffffffff81162ea3>] ? putname+0x33/0x50
[ 1559.406939]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1559.412949] INFO: task ceph-osd:38320 blocked for more than 120 seconds.
[ 1559.419648] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.427471] ceph-osd        D ffffffff8160b9c0     0 38320      1 0x00000000
[ 1559.434574]  ffff880320e4d578 0000000000000086 ffff880320e4d538 ffff880320e4dfd8
[ 1559.442059]  ffff880320e4c010 ffff880320e4c000 ffff880320e4c000 ffff880320e4c000
[ 1559.449571]  ffff880320e4dfd8 ffff880320e4c000 ffff8806244d5d00 ffff880320e42e80
[ 1559.457108] Call Trace:
[ 1559.459591]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1559.464589]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1559.471055]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1559.477175]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1559.483291]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1559.488489]  [<ffffffffa057c6f4>] do_chunk_alloc+0x1c4/0x300 [btrfs]
[ 1559.494872]  [<ffffffffa05855cc>] find_free_extent+0x9fc/0xb30 [btrfs]
[ 1559.501439]  [<ffffffffa0585782>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 1559.508279]  [<ffffffffa0585915>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1559.515272]  [<ffffffffa05b1a82>] ? clear_extent_bit+0x352/0x3d0 [btrfs]
[ 1559.522000]  [<ffffffffa057188a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1559.528611]  [<ffffffff8148c70e>] ? _raw_spin_unlock+0xe/0x20
[ 1559.534376]  [<ffffffffa057228d>] btrfs_cow_block+0x18d/0x230 [btrfs]
[ 1559.540852]  [<ffffffffa0575170>] btrfs_search_slot+0x360/0x730 [btrfs]
[ 1559.547493]  [<ffffffffa0575f7d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1559.554637]  [<ffffffffa0578e2b>] ? can_overcommit+0x8b/0xf0 [btrfs]
[ 1559.560995]  [<ffffffffa05888c3>] insert_with_overflow+0x43/0x120 [btrfs]
[ 1559.567782]  [<ffffffffa0588c66>] btrfs_insert_xattr_item+0xb6/0x1d0 [btrfs]
[ 1559.574821]  [<ffffffff8114b3eb>] ? kmem_cache_alloc+0xcb/0x160
[ 1559.580754]  [<ffffffffa05ab8aa>] do_setxattr+0x17a/0x240 [btrfs]
[ 1559.586857]  [<ffffffffa05ab9fb>] __btrfs_setxattr+0x8b/0x110 [btrfs]
[ 1559.593309]  [<ffffffffa05abc97>] btrfs_setxattr+0xa7/0xc0 [btrfs]
[ 1559.599485]  [<ffffffff8117b18b>] __vfs_setxattr_noperm+0x7b/0x150
[ 1559.605665]  [<ffffffff8117b2ec>] vfs_setxattr+0x8c/0xc0
[ 1559.610975]  [<ffffffff8117b4be>] setxattr+0x19e/0x210
[ 1559.616118]  [<ffffffff81148510>] ? kmem_cache_free+0x20/0x120
[ 1559.621941]  [<ffffffff81162ea3>] ? putname+0x33/0x50
[ 1559.626985]  [<ffffffff811590f3>] ? __sb_start_write+0xe3/0x130
[ 1559.632903]  [<ffffffff81158c40>] ? __fput+0x280/0x290
[ 1559.638039]  [<ffffffff8117b72f>] sys_setxattr+0x6f/0xb0
[ 1559.643341]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1559.649778]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1559.655773] INFO: task ceph-osd:38324 blocked for more than 120 seconds.
[ 1559.662459] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.670273] ceph-osd        D ffffffff8160b9c0     0 38324      1 0x00000000
[ 1559.677362]  ffff880320e6f258 0000000000000086 0000000000000000 ffff880320e6ffd8
[ 1559.684838]  ffff880320e6e010 ffff880320e6e000 ffff880320e6e000 ffff880320e6e000
[ 1559.692325]  ffff880320e6ffd8 ffff880320e6e000 ffff8806245f1740 ffff880320e71740
[ 1559.699807] Call Trace:
[ 1559.702267]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1559.707233]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1559.713661]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1559.719745]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1559.725831]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1559.730979]  [<ffffffffa057c6b1>] do_chunk_alloc+0x181/0x300 [btrfs]
[ 1559.737351]  [<ffffffffa05855cc>] find_free_extent+0x9fc/0xb30 [btrfs]
[ 1559.743896]  [<ffffffffa0585782>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 1559.750686]  [<ffffffffa0585915>] btrfs_alloc_free_block+0x85/0x230 [btrfs]
[ 1559.757663]  [<ffffffffa056c8ac>] ? generic_bin_search+0xac/0x170 [btrfs]
[ 1559.764477]  [<ffffffffa057188a>] __btrfs_cow_block+0x14a/0x4b0 [btrfs]
[ 1559.771148]  [<ffffffffa057228d>] btrfs_cow_block+0x18d/0x230 [btrfs]
[ 1559.777604]  [<ffffffffa0575170>] btrfs_search_slot+0x360/0x730 [btrfs]
[ 1559.784229]  [<ffffffffa0575f7d>] btrfs_insert_empty_items+0x8d/0x100 [btrfs]
[ 1559.791351]  [<ffffffff8114b3eb>] ? kmem_cache_alloc+0xcb/0x160
[ 1559.797288]  [<ffffffffa05b9735>] btrfs_alloc_dev_extent+0xb5/0x190 [btrfs]
[ 1559.804267]  [<ffffffffa05bd807>] __btrfs_alloc_chunk+0x6a7/0x750 [btrfs]
[ 1559.811076]  [<ffffffffa05b0265>] ? free_extent_buffer+0x75/0x90 [btrfs]
[ 1559.817842]  [<ffffffffa05bd90e>] btrfs_alloc_chunk+0x5e/0x90 [btrfs]
[ 1559.824324]  [<ffffffffa057aa01>] ? check_system_chunk+0x71/0x130 [btrfs]
[ 1559.831192]  [<ffffffffa057c7be>] do_chunk_alloc+0x28e/0x300 [btrfs]
[ 1559.837588]  [<ffffffffa05855cc>] find_free_extent+0x9fc/0xb30 [btrfs]
[ 1559.844132]  [<ffffffffa0585782>] btrfs_reserve_extent+0x82/0x190 [btrfs]
[ 1559.850950]  [<ffffffffa059cff6>] cow_file_range+0x296/0x4a0 [btrfs]
[ 1559.857350]  [<ffffffffa059f27b>] run_delalloc_range+0x7b/0xa0 [btrfs]
[ 1559.863935]  [<ffffffffa05b406d>] __extent_writepage+0x22d/0x740 [btrfs]
[ 1559.870642]  [<ffffffff810fcad8>] ? find_get_pages_tag+0x148/0x190
[ 1559.876870]  [<ffffffffa05b4972>] extent_write_cache_pages.clone.3+0x242/0x3d0 [btrfs]
[ 1559.884865]  [<ffffffffa05b4b47>] extent_writepages+0x47/0x60 [btrfs]
[ 1559.891351]  [<ffffffffa05a2790>] ? btrfs_update_time+0xb0/0xb0 [btrfs]
[ 1559.897991]  [<ffffffffa0599987>] btrfs_writepages+0x27/0x30 [btrfs]
[ 1559.904350]  [<ffffffff81108a03>] do_writepages+0x23/0x40
[ 1559.909793]  [<ffffffff810fd79e>] __filemap_fdatawrite_range+0x4e/0x50
[ 1559.916340]  [<ffffffff810fda53>] filemap_fdatawrite_range+0x13/0x20
[ 1559.922701]  [<ffffffff811863fc>] sys_sync_file_range+0x10c/0x170
[ 1559.928825]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1559.934837] INFO: task ceph-osd:38834 blocked for more than 120 seconds.
[ 1559.941541] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1559.949360] ceph-osd        D 0000000000000013     0 38834      1 0x00000000
[ 1559.956459]  ffff880332339bc8 0000000000000086 ffff880c1ae97878 ffff880332339fd8
[ 1559.963954]  ffff880332338010 ffff880332338000 ffff880332338000 ffff880332338000
[ 1559.971478]  ffff880332339fd8 ffff880332338000 ffff88051c1c0000 ffff88038f535d00
[ 1559.979005] Call Trace:
[ 1559.981465]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1559.986421]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1559.992869]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1559.998963]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1560.005071]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1560.010211]  [<ffffffff811623b4>] lookup_slow+0x54/0xe0
[ 1560.015443]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1560.020956]  [<ffffffff8114b36f>] ? kmem_cache_alloc+0x4f/0x160
[ 1560.026904]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1560.032400]  [<ffffffff810076f9>] ? emulate_vsyscall+0x1d9/0x360
[ 1560.038403]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1560.044240]  [<ffffffff81034843>] ? bad_area_nosemaphore+0x13/0x20
[ 1560.050414]  [<ffffffff81490338>] ? do_page_fault+0x228/0x4a0
[ 1560.056156]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1560.061482]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1560.066719]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1560.071690]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1560.076948]  [<ffffffff8125018a>] ? trace_hardirqs_off_thunk+0x3a/0x6c
[ 1560.083470]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1560.089898]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1560.095893] INFO: task ceph-osd:38835 blocked for more than 120 seconds.
[ 1560.102581] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.110393] ceph-osd        D 000000000000000b     0 38835      1 0x00000000
[ 1560.117482]  ffff8803672d5bc8 0000000000000086 ffff880c1ae97878 ffff8803672d5fd8
[ 1560.124969]  ffff8803672d4010 ffff8803672d4000 ffff8803672d4000 ffff8803672d4000
[ 1560.132457]  ffff8803672d5fd8 ffff8803672d4000 ffff88060f092e80 ffff8803672d8000
[ 1560.139940] Call Trace:
[ 1560.142401]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1560.147368]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1560.153810]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1560.159929]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1560.166015]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1560.171153]  [<ffffffff811623b4>] lookup_slow+0x54/0xe0
[ 1560.176374]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1560.181851]  [<ffffffff8114b36f>] ? kmem_cache_alloc+0x4f/0x160
[ 1560.187767]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1560.193266]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1560.199099]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1560.204415]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1560.209640]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1560.214602]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1560.219819]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1560.226255]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1560.232257] INFO: task ceph-osd:38841 blocked for more than 120 seconds.
[ 1560.238945] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.246783] ceph-osd        D ffffffff8160b9c0     0 38841      1 0x00000000
[ 1560.253897]  ffff880610037bc8 0000000000000086 ffff880c1ae97878 ffff880610037fd8
[ 1560.261372]  ffff880610036010 ffff880610036000 ffff880610036000 ffff880610036000
[ 1560.268866]  ffff880610037fd8 ffff880610036000 ffff8806245cae80 ffff8803672dc5c0
[ 1560.276335] Call Trace:
[ 1560.278793]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1560.283763]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1560.290204]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1560.296293]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1560.302384]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1560.307518]  [<ffffffff811623b4>] lookup_slow+0x54/0xe0
[ 1560.312732]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1560.318226]  [<ffffffff81162827>] ? getname_flags+0x37/0x100
[ 1560.323886]  [<ffffffff8114b3bc>] ? kmem_cache_alloc+0x9c/0x160
[ 1560.329815]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1560.335304]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1560.341136]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1560.346456]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1560.351694]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1560.356686]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1560.361918]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1560.368371]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1560.374385] INFO: task ceph-osd:38844 blocked for more than 120 seconds.
[ 1560.381082] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.388911] ceph-osd        D ffffffff8160b9c0     0 38844      1 0x00000000
[ 1560.396023]  ffff88061003dbc8 0000000000000086 ffff880c1ae97878 ffff88061003dfd8
[ 1560.403509]  ffff88061003c010 ffff88061003c000 ffff88061003c000 ffff88061003c000
[ 1560.411003]  ffff88061003dfd8 ffff88061003c000 ffff8806245c8000 ffff8803672ddd00
[ 1560.418522] Call Trace:
[ 1560.420995]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1560.425972]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1560.432421]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1560.438545]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1560.444647]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1560.449801]  [<ffffffff811623b4>] lookup_slow+0x54/0xe0
[ 1560.455039]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1560.460542]  [<ffffffff8114b36f>] ? kmem_cache_alloc+0x4f/0x160
[ 1560.466463]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1560.471953]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1560.477788]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1560.483098]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1560.488330]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1560.493296]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1560.498528]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1560.504962]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b
[ 1560.510961] INFO: task ceph-osd:38847 blocked for more than 120 seconds.
[ 1560.517647] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1560.525458] ceph-osd        D 000000000000000b     0 38847      1 0x00000000
[ 1560.532555]  ffff88061003fbc8 0000000000000086 ffff880c1ae97878 ffff88061003ffd8
[ 1560.540041]  ffff88061003e010 ffff88061003e000 ffff88061003e000 ffff88061003e000
[ 1560.547516]  ffff88061003ffd8 ffff88061003e000 ffff880347818000 ffff8803672e0000
[ 1560.554994] Call Trace:
[ 1560.557455]  [<ffffffff8148b51d>] schedule+0x5d/0x60
[ 1560.562423]  [<ffffffff8148b817>] schedule_preempt_disabled+0x27/0x40
[ 1560.568861]  [<ffffffff81489ce5>] __mutex_lock_common+0x205/0x360
[ 1560.574962]  [<ffffffff81489e5b>] __mutex_lock_slowpath+0x1b/0x20
[ 1560.581066]  [<ffffffff81489e91>] mutex_lock+0x31/0x50
[ 1560.586229]  [<ffffffff811623b4>] lookup_slow+0x54/0xe0
[ 1560.591482]  [<ffffffff81165cf7>] path_lookupat+0xf7/0x6c0
[ 1560.596971]  [<ffffffff8114b36f>] ? kmem_cache_alloc+0x4f/0x160
[ 1560.602889]  [<ffffffff811662f1>] do_path_lookup+0x31/0xd0
[ 1560.608379]  [<ffffffff811671ac>] user_path_at_empty+0x6c/0xb0
[ 1560.614217]  [<ffffffff81167201>] user_path_at+0x11/0x20
[ 1560.619536]  [<ffffffff8115c0b7>] vfs_fstatat+0x47/0x80
[ 1560.624772]  [<ffffffff8115c17b>] vfs_stat+0x1b/0x20
[ 1560.629749]  [<ffffffff8115c474>] sys_newstat+0x24/0x50
[ 1560.634973]  [<ffffffff8125014e>] ? trace_hardirqs_on_thunk+0x3a/0x3c
[ 1560.641412]  [<ffffffff81494b12>] system_call_fastpath+0x16/0x1b


Thanks -- Jim

