Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34782 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbKCMsg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 07:48:36 -0500
Received: by wikq8 with SMTP id q8so70852119wik.1
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2015 04:48:34 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Tue, 3 Nov 2015 17:48:19 +0500
Message-ID: <CABXGCsNhF0S_atK54K8xordzj8OeFD5EXokuKCJqFKEnsfZG=w@mail.gmail.com>
Subject: btrfs driver hangs again
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!
please, help me.


[  479.827555] INFO: task kworker/u16:2:140 blocked for more than 120 seconds.
[  479.827558]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.827559] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.827560] kworker/u16:2   D ffff8807fe3d76d8 11800   140      2 0x00000000
[  479.827578] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  479.827579]  ffff88009c56b848 0000000000000096 ffff88009c56b818
0000000000000000
[  479.827581]  ffff8807fa32d480 ffff8807f531d480 ffff88009c56b868
ffff88009c56c000
[  479.827583]  ffff8806c347d1f0 ffff8807f531d480 ffff8807f531d480
ffff88009c56b890
[  479.827585] Call Trace:
[  479.827588]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.827597]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.827600]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.827604]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.827608]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.827610]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
[  479.827616]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.827622]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  479.827625]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  479.827628]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  479.827634]  [<ffffffffa07b99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  479.827639]  [<ffffffffa07b4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  479.827645]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  479.827647]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.827652]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  479.827659]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  479.827665]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  479.827667]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  479.827668]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  479.827669]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.827670]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  479.827672]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  479.827673]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  479.827674]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  479.827676]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827678]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  479.827679]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827680] 3 locks held by kworker/u16:2/140:
[  479.827681]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827684]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827687]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  479.827694] INFO: task kworker/u16:3:141 blocked for more than 120 seconds.
[  479.827695]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.827695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.827696] kworker/u16:3   D ffff8807fe1d76d8 11240   141      2 0x00000000
[  479.827705] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  479.827706]  ffff88009c56f848 0000000000000096 ffff88009c56f818
0000000000000000
[  479.827708]  ffff8807fa32aa40 ffff8807f5318000 ffff88009c56f868
ffff88009c570000
[  479.827709]  ffff8806c347d1f0 ffff8807f5318000 ffff8807f5318000
ffff88009c56f890
[  479.827711] Call Trace:
[  479.827712]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.827719]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.827720]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.827724]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.827728]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.827729]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
[  479.827735]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.827741]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  479.827742]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  479.827746]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  479.827751]  [<ffffffffa07b99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  479.827756]  [<ffffffffa07b4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  479.827761]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  479.827763]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.827768]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  479.827774]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  479.827779]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  479.827780]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  479.827781]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  479.827782]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.827783]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  479.827785]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  479.827786]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  479.827787]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  479.827789]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827790]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  479.827792]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827793] 3 locks held by kworker/u16:3/141:
[  479.827793]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827796]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827798]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  479.827806] INFO: task kworker/u16:7:155 blocked for more than 120 seconds.
[  479.827806]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.827807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.827808] kworker/u16:7   D ffff8807fdfd76d8 11800   155      2 0x00000000
[  479.827816] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  479.827816]  ffff8807f4ee7848 0000000000000096 ffff8807f4ee7818
0000000000000000
[  479.827818]  ffff8807fa328000 ffff8807f4edaa40 ffff8807f4ee7868
ffff8807f4ee8000
[  479.827820]  ffff8806c347d1f0 ffff8807f4edaa40 ffff8807f4edaa40
ffff8807f4ee7890
[  479.827821] Call Trace:
[  479.827823]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.827829]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.827830]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.827834]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.827838]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.827839]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  479.827844]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.827850]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  479.827851]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  479.827855]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  479.827860]  [<ffffffffa07b99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  479.827865]  [<ffffffffa07b4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  479.827870]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  479.827872]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.827876]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  479.827882]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  479.827888]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  479.827889]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  479.827890]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  479.827891]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.827892]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  479.827893]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  479.827894]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  479.827895]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  479.827897]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827898]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  479.827900]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.827901] 3 locks held by kworker/u16:7/155:
[  479.827901]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827904]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.827906]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  479.827913] INFO: task kworker/u16:8:193 blocked for more than 120 seconds.
[  479.827913]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.827914] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.827915] kworker/u16:8   D ffff8807fddd76d8 12760   193      2 0x00000000
[  479.827923] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  479.827924]  ffff88009c6af848 0000000000000096 ffff88009c6af818
0000000000000000
[  479.827925]  ffff8807f4fb0000 ffff8807f4f92a40 ffff88009c6af868
ffff88009c6b0000
[  479.827927]  ffff8806c347d1f0 ffff8807f4f92a40 ffff8807f4f92a40
ffff88009c6af890
[  479.827928] Call Trace:
[  479.827930]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.827935]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.827937]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.827940]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.827944]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.827946]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
[  479.827951]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.827956]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  479.827958]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  479.827961]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  479.827966]  [<ffffffffa07b99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  479.827971]  [<ffffffffa07b4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  479.827976]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  479.827978]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.827982]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  479.827988]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  479.827994]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  479.827995]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  479.827996]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  479.827997]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.827998]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  479.827999]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  479.828000]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  479.828002]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  479.828004]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.828005]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  479.828006]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.828007] 3 locks held by kworker/u16:8/193:
[  479.828008]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.828010]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  479.828013]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  479.828026] INFO: task btrfs-transacti:808 blocked for more than 120 seconds.
[  479.828027]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828028] btrfs-transacti D ffff8807fe1d76d8 10632   808      2 0x00000080
[  479.828031]  ffff8807e3687a48 0000000000000096 ffff8807e3687a18
0000000000000000
[  479.828032]  ffff8807fa32aa40 ffff8807f74e2a40 ffff8807e3687a68
ffff8807e3688000
[  479.828034]  ffff8806c347d1f0 ffff8807f74e2a40 ffff8807f74e2a40
ffff8807e3687a90
[  479.828036] Call Trace:
[  479.828037]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828043]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828044]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828048]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828052]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828058]  [<ffffffffa0812c72>] ?
btrfs_delete_delayed_items+0x92/0x330 [btrfs]
[  479.828064]  [<ffffffffa0812cb8>]
btrfs_delete_delayed_items+0xd8/0x330 [btrfs]
[  479.828066]  [<ffffffff81108099>] ? trace_hardirqs_on_caller+0x129/0x1b0
[  479.828067]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  479.828072]  [<ffffffffa0813934>]
__btrfs_run_delayed_items+0x504/0x600 [btrfs]
[  479.828074]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.828080]  [<ffffffffa0814083>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[  479.828085]  [<ffffffffa07b6220>]
btrfs_commit_transaction+0x2f0/0xc80 [btrfs]
[  479.828090]  [<ffffffffa07b11a8>] transaction_kthread+0x208/0x270 [btrfs]
[  479.828095]  [<ffffffffa07b0fa0>] ?
btrfs_cleanup_transaction+0x6e0/0x6e0 [btrfs]
[  479.828096]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  479.828098]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.828099]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  479.828101]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  479.828102] 2 locks held by btrfs-transacti/808:
[  479.828102]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
at: [<ffffffffa07b1012>] transaction_kthread+0x72/0x270 [btrfs]
[  479.828108]  #1:  (&delayed_node->mutex){+.+...}, at:
[<ffffffffa0812c72>] btrfs_delete_delayed_items+0x92/0x330 [btrfs]
[  479.828140] INFO: task gnome-shell:2200 blocked for more than 120 seconds.
[  479.828141]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828142] gnome-shell     D ffff8807fddd76d8 11688  2200   1986 0x00000000
[  479.828145]  ffff880098157c48 0000000000000096 ffff880098157c18
0000000000000000
[  479.828146]  ffffffff81e12500 ffff8807b5e42a40 ffff880098157c68
ffff880098158000
[  479.828148]  ffff8806c347d1f0 ffff8807b5e42a40 ffff8807b5e42a40
ffff880098157c90
[  479.828150] Call Trace:
[  479.828151]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828157]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828158]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828162]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828166]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828167]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
[  479.828173]  [<ffffffffa07ba999>] btrfs_real_readdir+0xe9/0x590 [btrfs]
[  479.828175]  [<ffffffff81285ee7>] iterate_dir+0x97/0x130
[  479.828176]  [<ffffffff812921fa>] ? __fget_light+0x2a/0x90
[  479.828178]  [<ffffffff81286421>] SyS_getdents+0x91/0x120
[  479.828179]  [<ffffffff81286080>] ? fillonedir+0x100/0x100
[  479.828180]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
[  479.828182] 1 lock held by gnome-shell/2200:
[  479.828182]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
[<ffffffff81285eb1>] iterate_dir+0x61/0x130
[  479.828192] INFO: task tracker-store:2392 blocked for more than 120 seconds.
[  479.828192]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828193] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828193] tracker-store   D ffff8807febd76d8 10760  2392      1 0x00000000
[  479.828196]  ffff8807ac59f678 0000000000000096 ffff8807ac59f648
0000000000000000
[  479.828198]  ffff8807fa358000 ffff8807ada62a40 ffff8807ac59f698
ffff8807ac5a0000
[  479.828200]  ffff8806c347d1f0 ffff8807ada62a40 ffff8807ada62a40
ffff8807ac59f6c0
[  479.828201] Call Trace:
[  479.828202]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828208]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828209]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828213]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828217]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828222]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.828227]  [<ffffffffa07bb2ab>] btrfs_get_extent+0x16b/0xc40 [btrfs]
[  479.828228]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.828230]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
[  479.828236]  [<ffffffffa07d9cb2>] __do_readpage+0x1c2/0x940 [btrfs]
[  479.828237]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.828239]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
[  479.828240]  [<ffffffff818728c0>] ? _raw_spin_unlock_irq+0x30/0x50
[  479.828246]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828247]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  479.828253]  [<ffffffffa07da7f4>]
__extent_readpages.constprop.40+0x2c4/0x2e0 [btrfs]
[  479.828255]  [<ffffffff811e3118>] ? __add_to_page_cache_locked+0x408/0x470
[  479.828260]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828266]  [<ffffffffa07daebe>] extent_readpages+0x1de/0x1f0 [btrfs]
[  479.828271]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828272]  [<ffffffff811e1eb5>] ? __page_cache_alloc+0x135/0x150
[  479.828274]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.828275]  [<ffffffff811e1eb5>] ? __page_cache_alloc+0x135/0x150
[  479.828280]  [<ffffffffa07b8a6f>] btrfs_readpages+0x1f/0x30 [btrfs]
[  479.828281]  [<ffffffff811f427f>] __do_page_cache_readahead+0x2af/0x330
[  479.828282]  [<ffffffff811f414d>] ? __do_page_cache_readahead+0x17d/0x330
[  479.828284]  [<ffffffff81026d68>] ? native_sched_clock+0x28/0x90
[  479.828285]  [<ffffffff811f456b>] ondemand_readahead+0x26b/0x460
[  479.828286]  [<ffffffff811f4447>] ? ondemand_readahead+0x147/0x460
[  479.828288]  [<ffffffff811f4881>] page_cache_sync_readahead+0x31/0x50
[  479.828289]  [<ffffffff811e450e>] generic_file_read_iter+0x4fe/0x610
[  479.828291]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  479.828292]  [<ffffffff8126fd5c>] __vfs_read+0xcc/0x100
[  479.828294]  [<ffffffff8127067a>] vfs_read+0x8a/0x140
[  479.828295]  [<ffffffff81271428>] SyS_read+0x58/0xd0
[  479.828296]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
[  479.828298] 1 lock held by tracker-store/2392:
[  479.828298]  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<ffffffff81293089>] __fdget_pos+0x49/0x50
[  479.828308] INFO: task firefox:2910 blocked for more than 120 seconds.
[  479.828309]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828310] firefox         D ffff8807fddd76d8 11200  2910   2736 0x00000004
[  479.828313]  ffff8807808179f8 0000000000000092 ffff8807808179c8
0000000000000000
[  479.828315]  ffffffff81e12500 ffff8800983c5480 ffff880780817a18
ffff880780818000
[  479.828316]  ffff8806c347d1f0 ffff8800983c5480 ffff8800983c5480
ffff880780817a40
[  479.828318] Call Trace:
[  479.828319]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828325]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828327]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828330]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828334]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828337]  [<ffffffff813c7020>] ? crypto_shash_update+0x30/0xe0
[  479.828342]  [<ffffffffa07a7ad8>] btrfs_lookup_dir_item+0x78/0xc0 [btrfs]
[  479.828347]  [<ffffffffa07c4022>] btrfs_lookup_dentry+0xb2/0x510 [btrfs]
[  479.828349]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
[  479.828354]  [<ffffffffa07c4496>] btrfs_lookup+0x16/0x40 [btrfs]
[  479.828355]  [<ffffffff8127f3f0>] ? walk_component+0x1d0/0x2a0
[  479.828356]  [<ffffffff8127ae3d>] lookup_real+0x1d/0x60
[  479.828357]  [<ffffffff8127be22>] __lookup_hash+0x42/0x60
[  479.828359]  [<ffffffff8127f3ff>] walk_component+0x1df/0x2a0
[  479.828360]  [<ffffffff8127ec72>] ? path_init+0x552/0x7f0
[  479.828361]  [<ffffffff8127ec2a>] ? path_init+0x50a/0x7f0
[  479.828363]  [<ffffffff8144091d>] ? debug_check_no_obj_freed+0xbd/0x250
[  479.828364]  [<ffffffff8127fb2d>] path_lookupat+0x5d/0x110
[  479.828365]  [<ffffffff812816e9>] filename_lookup+0xa9/0x180
[  479.828367]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  479.828368]  [<ffffffff812812f6>] ? getname_flags+0x56/0x1f0
[  479.828369]  [<ffffffff8128189a>] user_path_at_empty+0x3a/0x50
[  479.828371]  [<ffffffff8126e959>] SyS_access+0xb9/0x250
[  479.828373]  [<ffffffff81003044>] ? lockdep_sys_exit_thunk+0x12/0x14
[  479.828374]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
[  479.828375] 1 lock held by firefox/2910:
[  479.828376]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
[<ffffffff8127f3f0>] walk_component+0x1d0/0x2a0
[  479.828381] INFO: task Cache2 I/O:2943 blocked for more than 120 seconds.
[  479.828382]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828382] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828383] Cache2 I/O      D ffff8807fe9d76d8 11384  2943   2736 0x00000000
[  479.828386]  ffff880092ad3678 0000000000000096 ffff880092ad3648
0000000000000000
[  479.828387]  ffff8807fa345480 ffff88009618d480 ffff880092ad3698
ffff880092ad4000
[  479.828389]  ffff8806c347d1f0 ffff88009618d480 ffff88009618d480
ffff880092ad36c0
[  479.828390] Call Trace:
[  479.828392]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828397]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828399]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828402]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828406]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828411]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  479.828416]  [<ffffffffa07bb2ab>] btrfs_get_extent+0x16b/0xc40 [btrfs]
[  479.828417]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.828419]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
[  479.828425]  [<ffffffffa07d9cb2>] __do_readpage+0x1c2/0x940 [btrfs]
[  479.828426]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.828428]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
[  479.828429]  [<ffffffff818728c0>] ? _raw_spin_unlock_irq+0x30/0x50
[  479.828434]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828436]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  479.828442]  [<ffffffffa07da7f4>]
__extent_readpages.constprop.40+0x2c4/0x2e0 [btrfs]
[  479.828443]  [<ffffffff811e3118>] ? __add_to_page_cache_locked+0x408/0x470
[  479.828448]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828454]  [<ffffffffa07daebe>] extent_readpages+0x1de/0x1f0 [btrfs]
[  479.828459]  [<ffffffffa07bb140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  479.828460]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  479.828461]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
[  479.828462]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  479.828465]  [<ffffffff81426220>] ? __radix_tree_lookup+0xc0/0x110
[  479.828469]  [<ffffffffa07b8a6f>] btrfs_readpages+0x1f/0x30 [btrfs]
[  479.828471]  [<ffffffff811f427f>] __do_page_cache_readahead+0x2af/0x330
[  479.828472]  [<ffffffff811f414d>] ? __do_page_cache_readahead+0x17d/0x330
[  479.828473]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
[  479.828474]  [<ffffffff811f43e3>] ondemand_readahead+0xe3/0x460
[  479.828476]  [<ffffffff811e325d>] ? pagecache_get_page+0x2d/0x200
[  479.828477]  [<ffffffff811f4881>] page_cache_sync_readahead+0x31/0x50
[  479.828478]  [<ffffffff811e450e>] generic_file_read_iter+0x4fe/0x610
[  479.828480]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  479.828481]  [<ffffffff8126fd5c>] __vfs_read+0xcc/0x100
[  479.828482]  [<ffffffff8127067a>] vfs_read+0x8a/0x140
[  479.828483]  [<ffffffff81271428>] SyS_read+0x58/0xd0
[  479.828485]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
[  479.828486] 1 lock held by Cache2 I/O/2943:
[  479.828486]  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<ffffffff81293089>] __fdget_pos+0x49/0x50
[  479.828491] INFO: task mozStorage #2:3046 blocked for more than 120 seconds.
[  479.828492]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  479.828493] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  479.828493] mozStorage #2   D ffff8807fe7d76d8 12904  3046   2736 0x00000000
[  479.828497]  ffff880779b0fb68 0000000000000092 ffff880779b0fb38
0000000000000000
[  479.828498]  ffff8807fa342a40 ffff880779898000 ffff880779b0fb88
ffff880779b10000
[  479.828500]  ffff8806c347d1f0 ffff880779898000 ffff880779898000
ffff880779b0fbb0
[  479.828502] Call Trace:
[  479.828503]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  479.828509]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  479.828510]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  479.828514]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  479.828518]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  479.828522]  [<ffffffffa078f7c1>] btrfs_insert_empty_items+0x71/0xc0 [btrfs]
[  479.828525]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  479.828531]  [<ffffffffa07f5be7>] btrfs_insert_orphan_item+0x67/0xa0 [btrfs]
[  479.828560]  [<ffffffffa07bc668>] btrfs_orphan_add+0xc8/0x1e0 [btrfs]
[  479.828566]  [<ffffffffa07c29ca>] btrfs_setattr+0x1aa/0x360 [btrfs]
[  479.828567]  [<ffffffff81291425>] notify_change+0x245/0x360
[  479.828569]  [<ffffffff8126e1a7>] do_truncate+0x77/0xc0
[  479.828571]  [<ffffffff8126e4fd>] ? do_sys_ftruncate.constprop.13+0xdd/0x160
[  479.828572]  [<ffffffff8126e532>] do_sys_ftruncate.constprop.13+0x112/0x160
[  479.828574]  [<ffffffff81003044>] ? lockdep_sys_exit_thunk+0x12/0x14
[  479.828576]  [<ffffffff8126e5be>] SyS_ftruncate+0xe/0x10
[  479.828577]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
[  479.828579] 3 locks held by mozStorage #2/3046:
[  479.828579]  #0:  (sb_writers#16){.+.+.+}, at: [<ffffffff8126e4fd>]
do_sys_ftruncate.constprop.13+0xdd/0x160
[  479.828582]  #1:  (&sb->s_type->i_mutex_key#19){+.+.+.}, at:
[<ffffffff8126e199>] do_truncate+0x69/0xc0
[  479.828586]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  502.886801] [drm:drm_mode_addfb2] [FB:72]
[  502.886815] [drm:drm_mode_setcrtc] [CRTC:21]


--
Best Regards,
Mike Gavrilov.
