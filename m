Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37660 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbbJXWTX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Oct 2015 18:19:23 -0400
Received: by wicfv8 with SMTP id fv8so71775504wic.0
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2015 15:19:21 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Sun, 25 Oct 2015 03:19:07 +0500
Message-ID: <CABXGCsMy8mOWbnu-dhZX67oa3=kufbVV+qz4H8miCsE5u_5CUg@mail.gmail.com>
Subject: btrfs file system stop working
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I see this is the second once in my life:

[  480.007335] INFO: task kworker/u16:1:106 blocked for more than 120 seconds.
[  480.007338]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007339] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007340] kworker/u16:1   D ffff8807fe9d76d8 11112   106      2 0x00000000
[  480.007348] Workqueue: writeback wb_workfn (flush-btrfs-1)
[  480.007350]  ffff8807f539f438 0000000000000092 ffff8807f539f408
0000000000000000
[  480.007351]  ffff8807fa365480 ffff8807f53a0000 ffff8807f539f458
ffff8807f53a0000
[  480.007353]  ffff8806b7939eb0 ffff8807f53a0000 ffff8807f53a0000
ffff8807f539f480
[  480.007355] Call Trace:
[  480.007358]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007372]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007374]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007379]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007384]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007385]  [<ffffffff81871cab>] ? _raw_spin_unlock+0x2b/0x40
[  480.007391]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.007398]  [<ffffffffa07cea9d>] run_delalloc_nocow+0x15d/0xb40 [btrfs]
[  480.007400]  [<ffffffff810e7e2c>] ? local_clock+0x1c/0x20
[  480.007407]  [<ffffffffa07e8118>] ? test_range_bit+0x48/0x130 [btrfs]
[  480.007410]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007416]  [<ffffffffa07e81b5>] ? test_range_bit+0xe5/0x130 [btrfs]
[  480.007422]  [<ffffffffa07cf820>] run_delalloc_range+0x3a0/0x400 [btrfs]
[  480.007429]  [<ffffffffa07e83e7>] ?
find_lock_delalloc_range.constprop.46+0x1e7/0x210 [btrfs]
[  480.007435]  [<ffffffffa07e8515>]
writepage_delalloc.isra.34+0x105/0x170 [btrfs]
[  480.007441]  [<ffffffffa07ea2c5>] __extent_writepage+0xf5/0x4a0 [btrfs]
[  480.007446]  [<ffffffffa07ea97a>]
extent_write_cache_pages.isra.31.constprop.44+0x30a/0x400 [btrfs]
[  480.007452]  [<ffffffffa07ebb4c>] extent_writepages+0x5c/0x90 [btrfs]
[  480.007458]  [<ffffffffa07cc140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  480.007464]  [<ffffffffa07c9aa8>] btrfs_writepages+0x28/0x30 [btrfs]
[  480.007466]  [<ffffffff811f3711>] do_writepages+0x21/0x30
[  480.007468]  [<ffffffff812a4bb0>] __writeback_single_inode+0x70/0xa20
[  480.007469]  [<ffffffff812a5d26>] writeback_sb_inodes+0x2d6/0x6d0
[  480.007471]  [<ffffffff812a61ac>] __writeback_inodes_wb+0x8c/0xc0
[  480.007473]  [<ffffffff812a65ad>] wb_writeback+0x3cd/0x720
[  480.007475]  [<ffffffff81435575>] ? find_next_bit+0x15/0x20
[  480.007476]  [<ffffffff812a7485>] wb_workfn+0x405/0x8d0
[  480.007479]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.007480]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.007482]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007484]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.007485]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.007487]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.007488]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.007490]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007491]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.007493]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007494] 4 locks held by kworker/u16:1/106:
[  480.007495]  #0:  ("writeback"){.+.+.+}, at: [<ffffffff810cc39b>]
process_one_work+0x19b/0x840
[  480.007499]  #1:  ((&(&wb->dwork)->work)){+.+.+.}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007501]  #2:  (&type->s_umount_key#57){.+.+..}, at:
[<ffffffff81273e9b>] trylock_super+0x1b/0x50
[  480.007505]  #3:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.007514] INFO: task kworker/u16:2:140 blocked for more than 120 seconds.
[  480.007515]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007515] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007516] kworker/u16:2   D ffff8807fe5d76d8 11800   140      2 0x00000000
[  480.007526] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.007527]  ffff8807f4dc3848 0000000000000096 ffff8807f4dc3818
0000000000000000
[  480.007529]  ffff8807fa360000 ffff8807f534aa40 ffff8807f4dc3868
ffff8807f4dc4000
[  480.007530]  ffff8806b7939eb0 ffff8807f534aa40 ffff8807f534aa40
ffff8807f4dc3890
[  480.007532] Call Trace:
[  480.007533]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007539]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007541]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007545]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007549]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007551]  [<ffffffff81109139>] ? __lock_acquire+0xcb9/0x1d00
[  480.007556]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.007562]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.007564]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.007567]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.007573]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.007578]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.007583]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.007586]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.007591]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.007598]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.007603]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.007605]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.007607]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.007608]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007610]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.007612]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.007613]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.007615]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.007616]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007618]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.007619]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007620] 3 locks held by kworker/u16:2/140:
[  480.007621]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007624]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007626]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.007634] INFO: task kworker/u16:3:141 blocked for more than 120 seconds.
[  480.007634]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007636] kworker/u16:3   D ffff8807fe3d76d8  9752   141      2 0x00000000
[  480.007643] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.007644]  ffff8807f4dc7848 0000000000000096 ffff8807f4dc7818
0000000000000000
[  480.007646]  ffff8807fa345480 ffff8807f5348000 ffff8807f4dc7868
ffff8807f4dc8000
[  480.007647]  ffff8806b7939eb0 ffff8807f5348000 ffff8807f5348000
ffff8807f4dc7890
[  480.007649] Call Trace:
[  480.007650]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007656]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007658]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007662]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007665]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007667]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.007672]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.007678]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.007679]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.007683]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.007688]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.007693]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.007698]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.007700]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.007705]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.007711]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.007716]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.007718]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.007719]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.007721]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007722]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.007724]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.007726]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.007727]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.007729]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007730]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.007732]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007733] 3 locks held by kworker/u16:3/141:
[  480.007733]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007736]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007739]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.007746] INFO: task kworker/u16:4:142 blocked for more than 120 seconds.
[  480.007747]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007747] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007748] kworker/u16:4   D ffff8807fddd76d8  9320   142      2 0x00000000
[  480.007755] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.007756]  ffff8807f4de3848 0000000000000096 ffff8807f4de3818
0000000000000000
[  480.007758]  ffffffff81e12500 ffff8807f5325480 ffff8807f4de3868
ffff8807f4de4000
[  480.007759]  ffff8806b7939eb0 ffff8807f5325480 ffff8807f5325480
ffff8807f4de3890
[  480.007761] Call Trace:
[  480.007762]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007768]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007769]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007773]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007776]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007778]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.007783]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.007789]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.007790]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.007793]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.007799]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.007804]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.007809]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.007810]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.007815]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.007821]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.007826]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.007828]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.007829]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.007831]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007832]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.007834]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.007835]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.007837]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.007838]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007840]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.007841]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007842] 3 locks held by kworker/u16:4/142:
[  480.007843]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007845]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007848]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.007855] INFO: task kworker/u16:5:143 blocked for more than 120 seconds.
[  480.007856]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007856] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007857] kworker/u16:5   D ffff8807fe5d76d8 10888   143      2 0x00000000
[  480.007864] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.007865]  ffff8807f4de7848 0000000000000096 ffff8807f4de7818
0000000000000000
[  480.007867]  ffff8807fa360000 ffff8807f5322a40 ffff8807f4de7868
ffff8807f4de8000
[  480.007868]  ffff8806b7939eb0 ffff8807f5322a40 ffff8807f5322a40
ffff8807f4de7890
[  480.007870] Call Trace:
[  480.007871]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007877]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007878]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007882]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007885]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007887]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.007892]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.007897]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.007899]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.007902]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.007907]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.007912]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.007917]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.007919]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.007923]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.007929]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.007935]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.007936]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.007938]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.007939]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.007941]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.007943]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.007944]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.007945]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.007947]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007948]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.007950]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.007951] 3 locks held by kworker/u16:5/143:
[  480.007951]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007954]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.007956]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.007964] INFO: task kworker/u16:7:154 blocked for more than 120 seconds.
[  480.007965]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.007965] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.007966] kworker/u16:7   D ffff8807fe5d76d8 11448   154      2 0x00000000
[  480.007973] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.007974]  ffff8807f4e73848 0000000000000096 ffff8807f4e73818
0000000000000000
[  480.007976]  ffff8807fa360000 ffff8807f52ed480 ffff8807f4e73868
ffff8807f4e74000
[  480.007977]  ffff8806b7939eb0 ffff8807f52ed480 ffff8807f52ed480
ffff8807f4e73890
[  480.007979] Call Trace:
[  480.007980]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.007986]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.007987]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.007991]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.007994]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.007996]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.008001]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.008006]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.008008]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.008009]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.008012]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.008017]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.008022]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.008027]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.008029]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.008033]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.008039]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.008045]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.008046]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.008048]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.008049]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.008051]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.008053]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.008054]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.008055]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.008057]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008058]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.008060]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008061] 3 locks held by kworker/u16:7/154:
[  480.008061]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.008064]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.008066]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.008073] INFO: task kworker/u16:8:191 blocked for more than 120 seconds.
[  480.008074]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.008075] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.008075] kworker/u16:8   D ffff8807fe3d76d8 11448   191      2 0x00000000
[  480.008083] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  480.008084]  ffff88009c68f848 0000000000000096 ffff88009c68f818
0000000000000000
[  480.008085]  ffff8807fa345480 ffff8807f4c88000 ffff88009c68f868
ffff88009c690000
[  480.008087]  ffff8806b7939eb0 ffff8807f4c88000 ffff8807f4c88000
ffff88009c68f890
[  480.008088] Call Trace:
[  480.008090]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.008095]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.008097]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.008100]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.008104]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.008105]  [<ffffffff81107f2d>] ? mark_held_locks+0x7d/0xb0
[  480.008110]  [<ffffffffa07b98d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  480.008116]  [<ffffffffa07dc007>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  480.008117]  [<ffffffff8124cf1e>] ? kmem_cache_alloc+0x33e/0x360
[  480.008120]  [<ffffffffa07993da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  480.008126]  [<ffffffffa07ca9f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  480.008130]  [<ffffffffa07c5cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  480.008136]  [<ffffffffa07d0cbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  480.008140]  [<ffffffffa07d12a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  480.008146]  [<ffffffffa07fb7c5>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  480.008152]  [<ffffffffa07fbfce>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  480.008153]  [<ffffffff810cc432>] process_one_work+0x232/0x840
[  480.008155]  [<ffffffff810cc39b>] ? process_one_work+0x19b/0x840
[  480.008156]  [<ffffffff8112851d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  480.008158]  [<ffffffff810ccb15>] ? worker_thread+0xd5/0x450
[  480.008160]  [<ffffffff810cca8e>] worker_thread+0x4e/0x450
[  480.008161]  [<ffffffff810cca40>] ? process_one_work+0x840/0x840
[  480.008162]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.008164]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008165]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.008167]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008168] 3 locks held by kworker/u16:8/191:
[  480.008168]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.008171]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc39b>] process_one_work+0x19b/0x840
[  480.008174]  #2:  (sb_internal#2){.+.+..}, at: [<ffffffffa07c7fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  480.008187] INFO: task btrfs-transacti:777 blocked for more than 120 seconds.
[  480.008188]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.008188] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.008189] btrfs-transacti D ffff8807fe3d76d8 10648   777      2 0x00000080
[  480.008192]  ffff8807e45c3aa8 0000000000000092 ffff8807e45c3a78
0000000000000000
[  480.008193]  ffff8807fa345480 ffff8807f26a8000 ffff8807e45c3ac8
ffff8807e45c4000
[  480.008195]  ffff8806b7939eb0 ffff8807f26a8000 ffff8807f26a8000
ffff8807e45c3af0
[  480.008197] Call Trace:
[  480.008198]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.008204]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.008205]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.008209]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.008212]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.008214]  [<ffffffff8186eaf9>] ? mutex_lock_nested+0x279/0x3e0
[  480.008220]  [<ffffffffa082438c>] ?
__btrfs_run_delayed_items+0xfc/0x600 [btrfs]
[  480.008224]  [<ffffffffa07a07c1>] btrfs_insert_empty_items+0x71/0xc0 [btrfs]
[  480.008230]  [<ffffffffa08243c5>]
__btrfs_run_delayed_items+0x135/0x600 [btrfs]
[  480.008231]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[  480.008237]  [<ffffffffa0824ee3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[  480.008242]  [<ffffffffa07c7220>]
btrfs_commit_transaction+0x2f0/0xc80 [btrfs]
[  480.008247]  [<ffffffffa07c21a8>] transaction_kthread+0x208/0x270 [btrfs]
[  480.008251]  [<ffffffffa07c1fa0>] ?
btrfs_cleanup_transaction+0x6e0/0x6e0 [btrfs]
[  480.008253]  [<ffffffff810d36d4>] kthread+0x104/0x120
[  480.008254]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008256]  [<ffffffff81872bdf>] ret_from_fork+0x3f/0x70
[  480.008257]  [<ffffffff810d35d0>] ? kthread_create_on_node+0x250/0x250
[  480.008258] 2 locks held by btrfs-transacti/777:
[  480.008259]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
at: [<ffffffffa07c2012>] transaction_kthread+0x72/0x270 [btrfs]
[  480.008264]  #1:  (&delayed_node->mutex){+.+...}, at:
[<ffffffffa082438c>] __btrfs_run_delayed_items+0xfc/0x600 [btrfs]
[  480.008298] INFO: task pool:4655 blocked for more than 120 seconds.
[  480.008298]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.008299] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.008300] pool            D ffff8807fe5d76d8 13176  4655   2015 0x00000000
[  480.008303]  ffff880668c27a28 0000000000000096 ffff880668c279f8
0000000000000000
[  480.008304]  ffff8807fa360000 ffff8806ad95aa40 ffff880668c27a48
ffff880668c28000
[  480.008306]  ffff8806b7939eb0 ffff8806ad95aa40 ffff8806ad95aa40
ffff880668c27a70
[  480.008307] Call Trace:
[  480.008309]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.008339]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.008340]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.008344]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.008348]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.008350]  [<ffffffff813c6e10>] ? crypto_shash_update+0x30/0xe0
[  480.008355]  [<ffffffffa07b8ad8>] btrfs_lookup_dir_item+0x78/0xc0 [btrfs]
[  480.008362]  [<ffffffffa07d4ff2>] btrfs_lookup_dentry+0xb2/0x510 [btrfs]
[  480.008364]  [<ffffffff81871cab>] ? _raw_spin_unlock+0x2b/0x40
[  480.008369]  [<ffffffffa07d5466>] btrfs_lookup+0x16/0x40 [btrfs]
[  480.008371]  [<ffffffff8127ac9d>] lookup_real+0x1d/0x60
[  480.008372]  [<ffffffff81280449>] path_openat+0xa49/0x12b0
[  480.008374]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[  480.008376]  [<ffffffff812bb400>] ?
__fsnotify_update_child_dentry_flags.part.1+0xf0/0x120
[  480.008378]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[  480.008379]  [<ffffffff8128212a>] do_filp_open+0x8a/0x100
[  480.008380]  [<ffffffff81871cab>] ? _raw_spin_unlock+0x2b/0x40
[  480.008382]  [<ffffffff8129274f>] ? __alloc_fd+0xaf/0x180
[  480.008385]  [<ffffffff8126f5da>] do_sys_open+0x13a/0x230
[  480.008386]  [<ffffffff8126f6ee>] SyS_open+0x1e/0x20
[  480.008388]  [<ffffffff818727ae>] entry_SYSCALL_64_fastpath+0x12/0x76
[  480.008389] 1 lock held by pool/4655:
[  480.008389]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
[<ffffffff81280097>] path_openat+0x697/0x12b0
[  480.008393] INFO: task pool:4775 blocked for more than 120 seconds.
[  480.008394]       Not tainted 4.2.3-300.fc23.x86_64+debug #1
[  480.008394] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  480.008395] pool            D ffff8807fe5d76d8 13176  4775   2015 0x00000000
[  480.008398]  ffff8807f828b908 0000000000000092 ffff8807f828b8d8
0000000000000000
[  480.008400]  ffff8807fa360000 ffff8807f9cd5480 ffff8807f828b928
ffff8807f828c000
[  480.008401]  ffff8806b7939eb0 ffff8807f9cd5480 ffff8807f9cd5480
ffff8807f828b950
[  480.008403] Call Trace:
[  480.008404]  [<ffffffff8186bc9e>] schedule+0x3e/0x90
[  480.008410]  [<ffffffffa0806352>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[  480.008411]  [<ffffffff810fbf50>] ? wake_atomic_t_function+0x70/0x70
[  480.008415]  [<ffffffffa0799834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[  480.008419]  [<ffffffffa079ebbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[  480.008421]  [<ffffffff813c6e10>] ? crypto_shash_update+0x30/0xe0
[  480.008426]  [<ffffffffa07b8ad8>] btrfs_lookup_dir_item+0x78/0xc0 [btrfs]
[  480.008432]  [<ffffffffa07d4ff2>] btrfs_lookup_dentry+0xb2/0x510 [btrfs]
[  480.008433]  [<ffffffff81871cab>] ? _raw_spin_unlock+0x2b/0x40
[  480.008438]  [<ffffffffa07d5466>] btrfs_lookup+0x16/0x40 [btrfs]
[  480.008439]  [<ffffffff8127f210>] ? walk_component+0x1d0/0x2a0
[  480.008441]  [<ffffffff8127ac9d>] lookup_real+0x1d/0x60
[  480.008442]  [<ffffffff8127bc82>] __lookup_hash+0x42/0x60
[  480.008443]  [<ffffffff8127f21f>] walk_component+0x1df/0x2a0
[  480.008444]  [<ffffffff8127f46e>] link_path_walk+0x18e/0x590
[  480.008445]  [<ffffffff8127ea92>] ? path_init+0x552/0x7f0
[  480.008446]  [<ffffffff8127ea4a>] ? path_init+0x50a/0x7f0
[  480.008447]  [<ffffffff8127faab>] path_openat+0xab/0x12b0
[  480.008449]  [<ffffffff81135b10>] ? clock_was_set_work+0x30/0x30
[  480.008451]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[  480.008452]  [<ffffffff8128212a>] do_filp_open+0x8a/0x100
[  480.008454]  [<ffffffff81871cab>] ? _raw_spin_unlock+0x2b/0x40
[  480.008455]  [<ffffffff8129274f>] ? __alloc_fd+0xaf/0x180
[  480.008457]  [<ffffffff8126f5da>] do_sys_open+0x13a/0x230
[  480.008458]  [<ffffffff8126f6ee>] SyS_open+0x1e/0x20
[  480.008460]  [<ffffffff818727ae>] entry_SYSCALL_64_fastpath+0x12/0x76
[  480.008461] 1 lock held by pool/4775:
[  480.008462]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
[<ffffffff8127f210>] walk_component+0x1d0/0x2a0


My /home partition stored in btrfs after it occurs all programs which
try accessed to /home hangs

--
Best Regards,
Mike Gavrilov.
