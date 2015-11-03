Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:33339 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbbKCNAt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Nov 2015 08:00:49 -0500
Received: by wijp11 with SMTP id p11so71192339wij.0
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Nov 2015 05:00:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABXGCsNhF0S_atK54K8xordzj8OeFD5EXokuKCJqFKEnsfZG=w@mail.gmail.com>
References: <CABXGCsNhF0S_atK54K8xordzj8OeFD5EXokuKCJqFKEnsfZG=w@mail.gmail.com>
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Tue, 3 Nov 2015 18:00:31 +0500
Message-ID: <CABXGCsPnk7t2=RU=Vmnh6=+fjV+2wsZcsVVv19it+E=Wv-XRXQ@mail.gmail.com>
Subject: Re: btrfs driver hangs again
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

and again :'(

[  360.084133] INFO: task kworker/u16:0:6 blocked for more than 120 seconds.
[  360.084138]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.084139] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.084140] kworker/u16:0   D ffff8807fe5d76d8 10488     6      2 0x00000000
[  360.084165] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.084168]  ffff8807fa7db848 0000000000000096 ffff8807fa7db818
0000000000000000
[  360.084171]  ffff8807fa340000 ffff8807fa7c5480 ffff8807fa7db868
ffff8807fa7dc000
[  360.084173]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807fa7db890
ffff8807e46f0b48
[  360.084176] Call Trace:
[  360.084181]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.084195]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.084199]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.084207]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.084214]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.084217]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.084226]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.084238]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.084241]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.084248]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.084258]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.084267]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.084277]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.084281]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.084290]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.084301]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.084312]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.084314]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.084316]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.084319]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.084320]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.084322]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.084324]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.084327]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.084330]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084333]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.084335]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084337] 3 locks held by kworker/u16:0/6:
[  360.084338]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.084343]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.084346]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.084368] INFO: task kworker/u16:1:108 blocked for more than 120 seconds.
[  360.084369]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.084370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.084371] kworker/u16:1   D ffff8807fddd76d8 11448   108      2 0x00000000
[  360.084380] Workqueue: writeback wb_workfn (flush-btrfs-1)
[  360.084382]  ffff8807f531f278 0000000000000096 0000000000000018
0000000000000000
[  360.084385]  ffffffff81e12500 ffff8807f5312a40 ffff8807f531f298
ffff8807f5320000
[  360.084387]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f531f2c0
ffff8807e46f0b48
[  360.084390] Call Trace:
[  360.084392]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.084404]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.084406]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.084413]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.084419]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.084428]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.084438]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.084440]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.084442]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
[  360.084451]  [<ffffffffa05a6c41>] ? start_transaction+0x91/0x6c0 [btrfs]
[  360.084460]  [<ffffffffa05acfe5>] cow_file_range_inline+0x1c5/0x6d0 [btrfs]
[  360.084471]  [<ffffffffa05c5965>] ? __set_extent_bit+0x3f5/0x530 [btrfs]
[  360.084481]  [<ffffffffa05ad84d>] cow_file_range+0x35d/0x450 [btrfs]
[  360.084492]  [<ffffffffa05c71e5>] ? test_range_bit+0xe5/0x130 [btrfs]
[  360.084500]  [<ffffffffa05ae848>] run_delalloc_range+0x3c8/0x400 [btrfs]
[  360.084511]  [<ffffffffa05c7417>] ?
find_lock_delalloc_range.constprop.45+0x1e7/0x210 [btrfs]
[  360.084526]  [<ffffffffa05c7545>]
writepage_delalloc.isra.34+0x105/0x170 [btrfs]
[  360.084540]  [<ffffffffa05c9345>] __extent_writepage+0xf5/0x4a0 [btrfs]
[  360.084555]  [<ffffffffa05c99fa>]
extent_write_cache_pages.isra.31.constprop.43+0x30a/0x400 [btrfs]
[  360.084560]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.084562]  [<ffffffff81026d68>] ? native_sched_clock+0x28/0x90
[  360.084565]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.084578]  [<ffffffffa05cacac>] extent_writepages+0x5c/0x90 [btrfs]
[  360.084591]  [<ffffffffa05ab140>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[  360.084603]  [<ffffffffa05a8aa8>] btrfs_writepages+0x28/0x30 [btrfs]
[  360.084606]  [<ffffffff811f3891>] do_writepages+0x21/0x30
[  360.084609]  [<ffffffff812a4d90>] __writeback_single_inode+0x70/0xa20
[  360.084612]  [<ffffffff812a5f06>] writeback_sb_inodes+0x2d6/0x6d0
[  360.084615]  [<ffffffff812a638c>] __writeback_inodes_wb+0x8c/0xc0
[  360.084617]  [<ffffffff812a678d>] wb_writeback+0x3cd/0x720
[  360.084621]  [<ffffffff814357e5>] ? find_next_bit+0x15/0x20
[  360.084624]  [<ffffffff812a7665>] wb_workfn+0x405/0x8d0
[  360.084626]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.084628]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.084630]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.084631]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.084633]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.084635]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.084637]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.084640]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084643]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.084645]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084647] 4 locks held by kworker/u16:1/108:
[  360.084648]  #0:  ("writeback"){.+.+.+}, at: [<ffffffff810cc3ab>]
process_one_work+0x19b/0x840
[  360.084653]  #1:  ((&(&wb->dwork)->work)){+.+.+.}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.084657]  #2:  (&type->s_umount_key#57){.+.+..}, at:
[<ffffffff8127404b>] trylock_super+0x1b/0x50
[  360.084662]  #3:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.084678] INFO: task kworker/u16:2:141 blocked for more than 120 seconds.
[  360.084680]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.084681] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.084682] kworker/u16:2   D ffff8807fe3d76d8 10696   141      2 0x00000000
[  360.084700] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.084701]  ffff8807f4dcb848 0000000000000096 ffff8807f4dcb818
0000000000000000
[  360.084704]  ffff8807fa32d480 ffff8807f9f7d480 ffff8807f4dcb868
ffff8807f4dcc000
[  360.084707]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4dcb890
ffff8807e46f0b48
[  360.084710] Call Trace:
[  360.084713]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.084727]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.084729]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.084738]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.084746]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.084749]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.084760]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.084773]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.084776]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.084784]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.084796]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.084808]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.084821]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.084824]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.084836]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.084850]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.084864]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.084866]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.084868]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.084869]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.084871]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.084873]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.084875]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.084878]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.084881]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084883]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.084885]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.084887] 3 locks held by kworker/u16:2/141:
[  360.084888]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.084892]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.084896]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.084911] INFO: task kworker/u16:3:142 blocked for more than 120 seconds.
[  360.084912]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.084913] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.084915] kworker/u16:3   D ffff8807fe1d76d8 11720   142      2 0x00000000
[  360.084932] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.084933]  ffff8807f4dcf848 0000000000000096 ffff8807f4dcf818
0000000000000000
[  360.084936]  ffff8807fa32aa40 ffff8807f5295480 ffff8807f4dcf868
ffff8807f4dd0000
[  360.084939]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4dcf890
ffff8807e46f0b48
[  360.084942] Call Trace:
[  360.084944]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.084958]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.084960]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.084969]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.084977]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.084980]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.084991]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.085004]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.085007]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.085015]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.085027]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.085039]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.085052]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.085055]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.085067]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.085081]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.085121]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.085125]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.085128]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.085131]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.085133]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.085136]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.085139]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.085142]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.085146]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085149]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.085152]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085155] 3 locks held by kworker/u16:3/142:
[  360.085157]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085163]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085168]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.085186] INFO: task kworker/u16:4:143 blocked for more than 120 seconds.
[  360.085188]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.085190] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.085192] kworker/u16:4   D ffff8807fe9d76d8 11800   143      2 0x00000000
[  360.085212] Workqueue: btrfs-delayed-meta btrfs_delayed_meta_helper [btrfs]
[  360.085215]  ffff8807f4ddb988 0000000000000096 ffff8807f4ddb958
0000000000000000
[  360.085219]  ffff8807fa345480 ffff8807f5290000 ffff8807f4ddb9a8
ffff8807f4ddc000
[  360.085223]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4ddb9d0
ffff8807e46f0b48
[  360.085228] Call Trace:
[  360.085231]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.085246]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.085249]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.085257]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.085266]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.085269]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.085280]  [<ffffffffa059a81e>] btrfs_lookup_inode+0x3e/0xc0 [btrfs]
[  360.085283]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  360.085298]  [<ffffffffa0603289>]
__btrfs_update_delayed_inode+0x69/0x210 [btrfs]
[  360.085310]  [<ffffffffa0603fe6>] ?
btrfs_async_run_delayed_root+0x5b6/0x620 [btrfs]
[  360.085314]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  360.085325]  [<ffffffffa0604007>]
btrfs_async_run_delayed_root+0x5d7/0x620 [btrfs]
[  360.085329]  [<ffffffff81026d68>] ? native_sched_clock+0x28/0x90
[  360.085331]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.085334]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.085347]  [<ffffffffa05da9e0>]
btrfs_scrubparity_helper+0x190/0x870 [btrfs]
[  360.085359]  [<ffffffffa05db12e>] btrfs_delayed_meta_helper+0xe/0x10 [btrfs]
[  360.085362]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.085364]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.085366]  [<ffffffff810ccd40>] ? worker_thread+0x2f0/0x450
[  360.085369]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.085371]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.085374]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.085378]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085381]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.085384]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085386] 4 locks held by kworker/u16:4/143:
[  360.085388]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085393]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085398]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.085412]  #3:  (&delayed_node->mutex){+.+...}, at:
[<ffffffffa0603fe6>] btrfs_async_run_delayed_root+0x5b6/0x620 [btrfs]
[  360.085430] INFO: task kworker/u16:5:144 blocked for more than 120 seconds.
[  360.085433]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.085434] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.085436] kworker/u16:5   D ffff8807fe9d76d8 11640   144      2 0x00000000
[  360.085454] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.085457]  ffff8807f4ddf848 0000000000000096 ffff8807f4ddf818
0000000000000000
[  360.085462]  ffff8807fa345480 ffff8807f5292a40 ffff8807f4ddf868
ffff8807f4de0000
[  360.085466]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4ddf890
ffff8807e46f0b48
[  360.085471] Call Trace:
[  360.085475]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.085489]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.085492]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.085503]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.085513]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.085516]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.085528]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.085542]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.085546]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.085554]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.085567]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.085580]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.085594]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.085598]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.085611]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.085625]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.085639]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.085642]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.085645]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.085648]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.085651]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.085654]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.085658]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.085661]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.085666]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085670]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.085673]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085676] 3 locks held by kworker/u16:5/144:
[  360.085678]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085685]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085691]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.085708] INFO: task kworker/u16:6:145 blocked for more than 120 seconds.
[  360.085711]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.085712] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.085714] kworker/u16:6   D ffff8807fe5d76d8 10744   145      2 0x00000000
[  360.085732] Workqueue: btrfs-delayed-meta btrfs_delayed_meta_helper [btrfs]
[  360.085734]  ffff8807f4deb988 0000000000000096 ffff8807f4deb958
0000000000000000
[  360.085739]  ffff8807fa340000 ffff8807f5282a40 ffff8807f4deb9a8
ffff8807f4dec000
[  360.085744]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4deb9d0
ffff8807e46f0b48
[  360.085749] Call Trace:
[  360.085753]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.085767]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.085770]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.085780]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.085790]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.085795]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.085808]  [<ffffffffa059a81e>] btrfs_lookup_inode+0x3e/0xc0 [btrfs]
[  360.085812]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  360.085828]  [<ffffffffa0603289>]
__btrfs_update_delayed_inode+0x69/0x210 [btrfs]
[  360.085842]  [<ffffffffa0603fe6>] ?
btrfs_async_run_delayed_root+0x5b6/0x620 [btrfs]
[  360.085846]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
[  360.085860]  [<ffffffffa0604007>]
btrfs_async_run_delayed_root+0x5d7/0x620 [btrfs]
[  360.085864]  [<ffffffff81026d68>] ? native_sched_clock+0x28/0x90
[  360.085867]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.085871]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.085885]  [<ffffffffa05da9e0>]
btrfs_scrubparity_helper+0x190/0x870 [btrfs]
[  360.085899]  [<ffffffffa05db12e>] btrfs_delayed_meta_helper+0xe/0x10 [btrfs]
[  360.085903]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.085906]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.085908]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.085911]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.085915]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.085918]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.085921]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.085926]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085930]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.085933]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.085937] 4 locks held by kworker/u16:6/145:
[  360.085938]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085945]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.085952]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.085969]  #3:  (&delayed_node->mutex){+.+...}, at:
[<ffffffffa0603fe6>] btrfs_async_run_delayed_root+0x5b6/0x620 [btrfs]
[  360.085990] INFO: task kworker/u16:7:155 blocked for more than 120 seconds.
[  360.085993]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.085996] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.085998] kworker/u16:7   D ffff8807fe5d76d8 11304   155      2 0x00000000
[  360.086016] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.086019]  ffff8807f4e7b848 0000000000000096 ffff8807f4e7b818
0000000000000000
[  360.086024]  ffff8807fa340000 ffff8807f4e6d480 ffff8807f4e7b868
ffff8807f4e7c000
[  360.086028]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4e7b890
ffff8807e46f0b48
[  360.086033] Call Trace:
[  360.086037]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.086051]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.086055]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.086065]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.086075]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.086079]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.086102]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.086117]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.086122]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.086130]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.086145]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.086158]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.086172]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.086176]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.086189]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.086204]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.086218]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.086221]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.086224]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.086228]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.086231]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.086235]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.086238]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.086241]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.086246]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086250]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.086253]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086256] 3 locks held by kworker/u16:7/155:
[  360.086258]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.086265]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.086271]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.086290] INFO: task kworker/u16:8:192 blocked for more than 120 seconds.
[  360.086293]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.086294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.086297] kworker/u16:8   D ffff8807fe1d76d8 11304   192      2 0x00000000
[  360.086316] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[  360.086318]  ffff8807f4f3f848 0000000000000096 ffff8807f4f3f818
0000000000000000
[  360.086323]  ffff8807fa32aa40 ffff8807f4e6aa40 ffff8807f4f3f868
ffff8807f4f40000
[  360.086328]  ffff8807e46f0b90 ffff8807e46f0be8 ffff8807f4f3f890
ffff8807e46f0b48
[  360.086333] Call Trace:
[  360.086337]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.086353]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.086357]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.086367]  [<ffffffffa0578884>] btrfs_lock_root_node+0x34/0x50 [btrfs]
[  360.086377]  [<ffffffffa057dd75>] btrfs_search_slot+0x905/0xa10 [btrfs]
[  360.086381]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
[  360.086394]  [<ffffffffa05988d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[  360.086409]  [<ffffffffa05bb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[  360.086413]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
[  360.086422]  [<ffffffffa05783da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[  360.086436]  [<ffffffffa05a99f5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[  360.086449]  [<ffffffffa05a4cbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[  360.086463]  [<ffffffffa05afcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[  360.086468]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.086480]  [<ffffffffa05b02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
[  360.086495]  [<ffffffffa05da945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[  360.086510]  [<ffffffffa05db14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[  360.086513]  [<ffffffff810cc442>] process_one_work+0x232/0x840
[  360.086517]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
[  360.086520]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[  360.086522]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
[  360.086527]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
[  360.086530]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
[  360.086534]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.086538]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086542]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.086546]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086549] 3 locks held by kworker/u16:8/192:
[  360.086551]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.086558]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc3ab>] process_one_work+0x19b/0x840
[  360.086564]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa05a6fcc>]
start_transaction+0x41c/0x6c0 [btrfs]
[  360.086594] INFO: task btrfs-transacti:785 blocked for more than 120 seconds.
[  360.086597]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
[  360.086599] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  360.086601] btrfs-transacti D ffff8807fe1d76d8 10632   785      2 0x00000080
[  360.086607]  ffff88003ec63ac8 0000000000000092 ffff88003ec63a98
0000000000000000
[  360.086612]  ffff8807fa32aa40 ffff8807ecadaa40 ffff88003ec63ae8
ffff88003ec64000
[  360.086617]  ffff88079eb78970 ffff88079eb789c8 ffff88003ec63b10
ffff88079eb78928
[  360.086622] Call Trace:
[  360.086626]  [<ffffffff8186c82e>] schedule+0x3e/0x90
[  360.086642]  [<ffffffffa05e589d>] btrfs_tree_lock+0x7d/0x270 [btrfs]
[  360.086646]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
[  360.086657]  [<ffffffffa057db68>] btrfs_search_slot+0x6f8/0xa10 [btrfs]
[  360.086661]  [<ffffffff8186f689>] ? mutex_lock_nested+0x279/0x3e0
[  360.086676]  [<ffffffffa060352c>] ?
__btrfs_run_delayed_items+0xfc/0x600 [btrfs]
[  360.086687]  [<ffffffffa057f7c1>] btrfs_insert_empty_items+0x71/0xc0 [btrfs]
[  360.086690]  [<ffffffff8187009e>] ? mutex_unlock+0xe/0x10
[  360.086705]  [<ffffffffa0603565>]
__btrfs_run_delayed_items+0x135/0x600 [btrfs]
[  360.086709]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
[  360.086724]  [<ffffffffa0604083>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[  360.086738]  [<ffffffffa05a6220>]
btrfs_commit_transaction+0x2f0/0xc80 [btrfs]
[  360.086751]  [<ffffffffa05a11a8>] transaction_kthread+0x208/0x270 [btrfs]
[  360.086764]  [<ffffffffa05a0fa0>] ?
btrfs_cleanup_transaction+0x6e0/0x6e0 [btrfs]
[  360.086767]  [<ffffffff810d36e4>] kthread+0x104/0x120
[  360.086772]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086776]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
[  360.086780]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
[  360.086783] 2 locks held by btrfs-transacti/785:
[  360.086785]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
at: [<ffffffffa05a1012>] transaction_kthread+0x72/0x270 [btrfs]
[  360.086800]  #1:  (&delayed_node->mutex){+.+...}, at:
[<ffffffffa060352c>] __btrfs_run_delayed_items+0xfc/0x600 [btrfs]






--
Best Regards,
Mike Gavrilov.


2015-11-03 17:48 GMT+05:00 Михаил Гаврилов <mikhail.v.gavrilov@gmail.com>:
> Hi!
> please, help me.
>
>
> [  479.827555] INFO: task kworker/u16:2:140 blocked for more than 120 seconds.
> [  479.827558]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.827559] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.827560] kworker/u16:2   D ffff8807fe3d76d8 11800   140      2 0x00000000
> [  479.827578] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [  479.827579]  ffff88009c56b848 0000000000000096 ffff88009c56b818
> 0000000000000000
> [  479.827581]  ffff8807fa32d480 ffff8807f531d480 ffff88009c56b868
> ffff88009c56c000
> [  479.827583]  ffff8806c347d1f0 ffff8807f531d480 ffff8807f531d480
> ffff88009c56b890
> [  479.827585] Call Trace:
> [  479.827588]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.827597]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.827600]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.827604]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.827608]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.827610]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
> [  479.827616]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.827622]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
> [  479.827625]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
> [  479.827628]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  479.827634]  [<ffffffffa07b99f5>]
> insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
> [  479.827639]  [<ffffffffa07b4cbe>] ?
> join_transaction.isra.12+0x10e/0x420 [btrfs]
> [  479.827645]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
> [  479.827647]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.827652]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [  479.827659]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
> [  479.827665]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
> [  479.827667]  [<ffffffff810cc442>] process_one_work+0x232/0x840
> [  479.827668]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
> [  479.827669]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.827670]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
> [  479.827672]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
> [  479.827673]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
> [  479.827674]  [<ffffffff810d36e4>] kthread+0x104/0x120
> [  479.827676]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827678]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
> [  479.827679]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827680] 3 locks held by kworker/u16:2/140:
> [  479.827681]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827684]  #1:  ((&work->normal_work)){+.+...}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827687]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
> start_transaction+0x41c/0x6c0 [btrfs]
> [  479.827694] INFO: task kworker/u16:3:141 blocked for more than 120 seconds.
> [  479.827695]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.827695] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.827696] kworker/u16:3   D ffff8807fe1d76d8 11240   141      2 0x00000000
> [  479.827705] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [  479.827706]  ffff88009c56f848 0000000000000096 ffff88009c56f818
> 0000000000000000
> [  479.827708]  ffff8807fa32aa40 ffff8807f5318000 ffff88009c56f868
> ffff88009c570000
> [  479.827709]  ffff8806c347d1f0 ffff8807f5318000 ffff8807f5318000
> ffff88009c56f890
> [  479.827711] Call Trace:
> [  479.827712]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.827719]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.827720]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.827724]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.827728]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.827729]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
> [  479.827735]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.827741]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
> [  479.827742]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
> [  479.827746]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  479.827751]  [<ffffffffa07b99f5>]
> insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
> [  479.827756]  [<ffffffffa07b4cbe>] ?
> join_transaction.isra.12+0x10e/0x420 [btrfs]
> [  479.827761]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
> [  479.827763]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.827768]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [  479.827774]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
> [  479.827779]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
> [  479.827780]  [<ffffffff810cc442>] process_one_work+0x232/0x840
> [  479.827781]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
> [  479.827782]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.827783]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
> [  479.827785]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
> [  479.827786]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
> [  479.827787]  [<ffffffff810d36e4>] kthread+0x104/0x120
> [  479.827789]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827790]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
> [  479.827792]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827793] 3 locks held by kworker/u16:3/141:
> [  479.827793]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827796]  #1:  ((&work->normal_work)){+.+...}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827798]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
> start_transaction+0x41c/0x6c0 [btrfs]
> [  479.827806] INFO: task kworker/u16:7:155 blocked for more than 120 seconds.
> [  479.827806]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.827807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.827808] kworker/u16:7   D ffff8807fdfd76d8 11800   155      2 0x00000000
> [  479.827816] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [  479.827816]  ffff8807f4ee7848 0000000000000096 ffff8807f4ee7818
> 0000000000000000
> [  479.827818]  ffff8807fa328000 ffff8807f4edaa40 ffff8807f4ee7868
> ffff8807f4ee8000
> [  479.827820]  ffff8806c347d1f0 ffff8807f4edaa40 ffff8807f4edaa40
> ffff8807f4ee7890
> [  479.827821] Call Trace:
> [  479.827823]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.827829]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.827830]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.827834]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.827838]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.827839]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
> [  479.827844]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.827850]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
> [  479.827851]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
> [  479.827855]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  479.827860]  [<ffffffffa07b99f5>]
> insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
> [  479.827865]  [<ffffffffa07b4cbe>] ?
> join_transaction.isra.12+0x10e/0x420 [btrfs]
> [  479.827870]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
> [  479.827872]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.827876]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [  479.827882]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
> [  479.827888]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
> [  479.827889]  [<ffffffff810cc442>] process_one_work+0x232/0x840
> [  479.827890]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
> [  479.827891]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.827892]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
> [  479.827893]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
> [  479.827894]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
> [  479.827895]  [<ffffffff810d36e4>] kthread+0x104/0x120
> [  479.827897]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827898]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
> [  479.827900]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.827901] 3 locks held by kworker/u16:7/155:
> [  479.827901]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827904]  #1:  ((&work->normal_work)){+.+...}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.827906]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
> start_transaction+0x41c/0x6c0 [btrfs]
> [  479.827913] INFO: task kworker/u16:8:193 blocked for more than 120 seconds.
> [  479.827913]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.827914] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.827915] kworker/u16:8   D ffff8807fddd76d8 12760   193      2 0x00000000
> [  479.827923] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
> [  479.827924]  ffff88009c6af848 0000000000000096 ffff88009c6af818
> 0000000000000000
> [  479.827925]  ffff8807f4fb0000 ffff8807f4f92a40 ffff88009c6af868
> ffff88009c6b0000
> [  479.827927]  ffff8806c347d1f0 ffff8807f4f92a40 ffff8807f4f92a40
> ffff88009c6af890
> [  479.827928] Call Trace:
> [  479.827930]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.827935]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.827937]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.827940]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.827944]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.827946]  [<ffffffff81109149>] ? __lock_acquire+0xcb9/0x1d00
> [  479.827951]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.827956]  [<ffffffffa07cb037>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
> [  479.827958]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
> [  479.827961]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  479.827966]  [<ffffffffa07b99f5>]
> insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
> [  479.827971]  [<ffffffffa07b4cbe>] ?
> join_transaction.isra.12+0x10e/0x420 [btrfs]
> [  479.827976]  [<ffffffffa07bfcbf>] btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
> [  479.827978]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.827982]  [<ffffffffa07c02a5>] finish_ordered_fn+0x15/0x20 [btrfs]
> [  479.827988]  [<ffffffffa07ea945>] btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
> [  479.827994]  [<ffffffffa07eb14e>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
> [  479.827995]  [<ffffffff810cc442>] process_one_work+0x232/0x840
> [  479.827996]  [<ffffffff810cc3ab>] ? process_one_work+0x19b/0x840
> [  479.827997]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.827998]  [<ffffffff810ccb25>] ? worker_thread+0xd5/0x450
> [  479.827999]  [<ffffffff810cca9e>] worker_thread+0x4e/0x450
> [  479.828000]  [<ffffffff810cca50>] ? process_one_work+0x840/0x840
> [  479.828002]  [<ffffffff810d36e4>] kthread+0x104/0x120
> [  479.828004]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.828005]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
> [  479.828006]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.828007] 3 locks held by kworker/u16:8/193:
> [  479.828008]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.828010]  #1:  ((&work->normal_work)){+.+...}, at:
> [<ffffffff810cc3ab>] process_one_work+0x19b/0x840
> [  479.828013]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
> start_transaction+0x41c/0x6c0 [btrfs]
> [  479.828026] INFO: task btrfs-transacti:808 blocked for more than 120 seconds.
> [  479.828027]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828027] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828028] btrfs-transacti D ffff8807fe1d76d8 10632   808      2 0x00000080
> [  479.828031]  ffff8807e3687a48 0000000000000096 ffff8807e3687a18
> 0000000000000000
> [  479.828032]  ffff8807fa32aa40 ffff8807f74e2a40 ffff8807e3687a68
> ffff8807e3688000
> [  479.828034]  ffff8806c347d1f0 ffff8807f74e2a40 ffff8807f74e2a40
> ffff8807e3687a90
> [  479.828036] Call Trace:
> [  479.828037]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828043]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828044]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828048]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828052]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828058]  [<ffffffffa0812c72>] ?
> btrfs_delete_delayed_items+0x92/0x330 [btrfs]
> [  479.828064]  [<ffffffffa0812cb8>]
> btrfs_delete_delayed_items+0xd8/0x330 [btrfs]
> [  479.828066]  [<ffffffff81108099>] ? trace_hardirqs_on_caller+0x129/0x1b0
> [  479.828067]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
> [  479.828072]  [<ffffffffa0813934>]
> __btrfs_run_delayed_items+0x504/0x600 [btrfs]
> [  479.828074]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.828080]  [<ffffffffa0814083>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
> [  479.828085]  [<ffffffffa07b6220>]
> btrfs_commit_transaction+0x2f0/0xc80 [btrfs]
> [  479.828090]  [<ffffffffa07b11a8>] transaction_kthread+0x208/0x270 [btrfs]
> [  479.828095]  [<ffffffffa07b0fa0>] ?
> btrfs_cleanup_transaction+0x6e0/0x6e0 [btrfs]
> [  479.828096]  [<ffffffff810d36e4>] kthread+0x104/0x120
> [  479.828098]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.828099]  [<ffffffff8187375f>] ret_from_fork+0x3f/0x70
> [  479.828101]  [<ffffffff810d35e0>] ? kthread_create_on_node+0x250/0x250
> [  479.828102] 2 locks held by btrfs-transacti/808:
> [  479.828102]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
> at: [<ffffffffa07b1012>] transaction_kthread+0x72/0x270 [btrfs]
> [  479.828108]  #1:  (&delayed_node->mutex){+.+...}, at:
> [<ffffffffa0812c72>] btrfs_delete_delayed_items+0x92/0x330 [btrfs]
> [  479.828140] INFO: task gnome-shell:2200 blocked for more than 120 seconds.
> [  479.828141]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828141] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828142] gnome-shell     D ffff8807fddd76d8 11688  2200   1986 0x00000000
> [  479.828145]  ffff880098157c48 0000000000000096 ffff880098157c18
> 0000000000000000
> [  479.828146]  ffffffff81e12500 ffff8807b5e42a40 ffff880098157c68
> ffff880098158000
> [  479.828148]  ffff8806c347d1f0 ffff8807b5e42a40 ffff8807b5e42a40
> ffff880098157c90
> [  479.828150] Call Trace:
> [  479.828151]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828157]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828158]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828162]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828166]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828167]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
> [  479.828173]  [<ffffffffa07ba999>] btrfs_real_readdir+0xe9/0x590 [btrfs]
> [  479.828175]  [<ffffffff81285ee7>] iterate_dir+0x97/0x130
> [  479.828176]  [<ffffffff812921fa>] ? __fget_light+0x2a/0x90
> [  479.828178]  [<ffffffff81286421>] SyS_getdents+0x91/0x120
> [  479.828179]  [<ffffffff81286080>] ? fillonedir+0x100/0x100
> [  479.828180]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
> [  479.828182] 1 lock held by gnome-shell/2200:
> [  479.828182]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffff81285eb1>] iterate_dir+0x61/0x130
> [  479.828192] INFO: task tracker-store:2392 blocked for more than 120 seconds.
> [  479.828192]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828193] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828193] tracker-store   D ffff8807febd76d8 10760  2392      1 0x00000000
> [  479.828196]  ffff8807ac59f678 0000000000000096 ffff8807ac59f648
> 0000000000000000
> [  479.828198]  ffff8807fa358000 ffff8807ada62a40 ffff8807ac59f698
> ffff8807ac5a0000
> [  479.828200]  ffff8806c347d1f0 ffff8807ada62a40 ffff8807ada62a40
> ffff8807ac59f6c0
> [  479.828201] Call Trace:
> [  479.828202]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828208]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828209]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828213]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828217]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828222]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.828227]  [<ffffffffa07bb2ab>] btrfs_get_extent+0x16b/0xc40 [btrfs]
> [  479.828228]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.828230]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
> [  479.828236]  [<ffffffffa07d9cb2>] __do_readpage+0x1c2/0x940 [btrfs]
> [  479.828237]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.828239]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
> [  479.828240]  [<ffffffff818728c0>] ? _raw_spin_unlock_irq+0x30/0x50
> [  479.828246]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828247]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
> [  479.828253]  [<ffffffffa07da7f4>]
> __extent_readpages.constprop.40+0x2c4/0x2e0 [btrfs]
> [  479.828255]  [<ffffffff811e3118>] ? __add_to_page_cache_locked+0x408/0x470
> [  479.828260]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828266]  [<ffffffffa07daebe>] extent_readpages+0x1de/0x1f0 [btrfs]
> [  479.828271]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828272]  [<ffffffff811e1eb5>] ? __page_cache_alloc+0x135/0x150
> [  479.828274]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.828275]  [<ffffffff811e1eb5>] ? __page_cache_alloc+0x135/0x150
> [  479.828280]  [<ffffffffa07b8a6f>] btrfs_readpages+0x1f/0x30 [btrfs]
> [  479.828281]  [<ffffffff811f427f>] __do_page_cache_readahead+0x2af/0x330
> [  479.828282]  [<ffffffff811f414d>] ? __do_page_cache_readahead+0x17d/0x330
> [  479.828284]  [<ffffffff81026d68>] ? native_sched_clock+0x28/0x90
> [  479.828285]  [<ffffffff811f456b>] ondemand_readahead+0x26b/0x460
> [  479.828286]  [<ffffffff811f4447>] ? ondemand_readahead+0x147/0x460
> [  479.828288]  [<ffffffff811f4881>] page_cache_sync_readahead+0x31/0x50
> [  479.828289]  [<ffffffff811e450e>] generic_file_read_iter+0x4fe/0x610
> [  479.828291]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
> [  479.828292]  [<ffffffff8126fd5c>] __vfs_read+0xcc/0x100
> [  479.828294]  [<ffffffff8127067a>] vfs_read+0x8a/0x140
> [  479.828295]  [<ffffffff81271428>] SyS_read+0x58/0xd0
> [  479.828296]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
> [  479.828298] 1 lock held by tracker-store/2392:
> [  479.828298]  #0:  (&f->f_pos_lock){+.+.+.}, at:
> [<ffffffff81293089>] __fdget_pos+0x49/0x50
> [  479.828308] INFO: task firefox:2910 blocked for more than 120 seconds.
> [  479.828309]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828310] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828310] firefox         D ffff8807fddd76d8 11200  2910   2736 0x00000004
> [  479.828313]  ffff8807808179f8 0000000000000092 ffff8807808179c8
> 0000000000000000
> [  479.828315]  ffffffff81e12500 ffff8800983c5480 ffff880780817a18
> ffff880780818000
> [  479.828316]  ffff8806c347d1f0 ffff8800983c5480 ffff8800983c5480
> ffff880780817a40
> [  479.828318] Call Trace:
> [  479.828319]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828325]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828327]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828330]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828334]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828337]  [<ffffffff813c7020>] ? crypto_shash_update+0x30/0xe0
> [  479.828342]  [<ffffffffa07a7ad8>] btrfs_lookup_dir_item+0x78/0xc0 [btrfs]
> [  479.828347]  [<ffffffffa07c4022>] btrfs_lookup_dentry+0xb2/0x510 [btrfs]
> [  479.828349]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
> [  479.828354]  [<ffffffffa07c4496>] btrfs_lookup+0x16/0x40 [btrfs]
> [  479.828355]  [<ffffffff8127f3f0>] ? walk_component+0x1d0/0x2a0
> [  479.828356]  [<ffffffff8127ae3d>] lookup_real+0x1d/0x60
> [  479.828357]  [<ffffffff8127be22>] __lookup_hash+0x42/0x60
> [  479.828359]  [<ffffffff8127f3ff>] walk_component+0x1df/0x2a0
> [  479.828360]  [<ffffffff8127ec72>] ? path_init+0x552/0x7f0
> [  479.828361]  [<ffffffff8127ec2a>] ? path_init+0x50a/0x7f0
> [  479.828363]  [<ffffffff8144091d>] ? debug_check_no_obj_freed+0xbd/0x250
> [  479.828364]  [<ffffffff8127fb2d>] path_lookupat+0x5d/0x110
> [  479.828365]  [<ffffffff812816e9>] filename_lookup+0xa9/0x180
> [  479.828367]  [<ffffffff8124d09e>] ? kmem_cache_alloc+0x33e/0x360
> [  479.828368]  [<ffffffff812812f6>] ? getname_flags+0x56/0x1f0
> [  479.828369]  [<ffffffff8128189a>] user_path_at_empty+0x3a/0x50
> [  479.828371]  [<ffffffff8126e959>] SyS_access+0xb9/0x250
> [  479.828373]  [<ffffffff81003044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [  479.828374]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
> [  479.828375] 1 lock held by firefox/2910:
> [  479.828376]  #0:  (&type->i_mutex_dir_key#4){+.+.+.}, at:
> [<ffffffff8127f3f0>] walk_component+0x1d0/0x2a0
> [  479.828381] INFO: task Cache2 I/O:2943 blocked for more than 120 seconds.
> [  479.828382]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828382] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828383] Cache2 I/O      D ffff8807fe9d76d8 11384  2943   2736 0x00000000
> [  479.828386]  ffff880092ad3678 0000000000000096 ffff880092ad3648
> 0000000000000000
> [  479.828387]  ffff8807fa345480 ffff88009618d480 ffff880092ad3698
> ffff880092ad4000
> [  479.828389]  ffff8806c347d1f0 ffff88009618d480 ffff88009618d480
> ffff880092ad36c0
> [  479.828390] Call Trace:
> [  479.828392]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828397]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828399]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828402]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828406]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828411]  [<ffffffffa07a88d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
> [  479.828416]  [<ffffffffa07bb2ab>] btrfs_get_extent+0x16b/0xc40 [btrfs]
> [  479.828417]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.828419]  [<ffffffff8187283b>] ? _raw_spin_unlock+0x2b/0x40
> [  479.828425]  [<ffffffffa07d9cb2>] __do_readpage+0x1c2/0x940 [btrfs]
> [  479.828426]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.828428]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
> [  479.828429]  [<ffffffff818728c0>] ? _raw_spin_unlock_irq+0x30/0x50
> [  479.828434]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828436]  [<ffffffff8110812d>] ? trace_hardirqs_on+0xd/0x10
> [  479.828442]  [<ffffffffa07da7f4>]
> __extent_readpages.constprop.40+0x2c4/0x2e0 [btrfs]
> [  479.828443]  [<ffffffff811e3118>] ? __add_to_page_cache_locked+0x408/0x470
> [  479.828448]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828454]  [<ffffffffa07daebe>] extent_readpages+0x1de/0x1f0 [btrfs]
> [  479.828459]  [<ffffffffa07bb140>] ?
> btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
> [  479.828460]  [<ffffffff81026dd9>] ? sched_clock+0x9/0x10
> [  479.828461]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
> [  479.828462]  [<ffffffff8112858d>] ? debug_lockdep_rcu_enabled+0x1d/0x20
> [  479.828465]  [<ffffffff81426220>] ? __radix_tree_lookup+0xc0/0x110
> [  479.828469]  [<ffffffffa07b8a6f>] btrfs_readpages+0x1f/0x30 [btrfs]
> [  479.828471]  [<ffffffff811f427f>] __do_page_cache_readahead+0x2af/0x330
> [  479.828472]  [<ffffffff811f414d>] ? __do_page_cache_readahead+0x17d/0x330
> [  479.828473]  [<ffffffff810e7e3c>] ? local_clock+0x1c/0x20
> [  479.828474]  [<ffffffff811f43e3>] ondemand_readahead+0xe3/0x460
> [  479.828476]  [<ffffffff811e325d>] ? pagecache_get_page+0x2d/0x200
> [  479.828477]  [<ffffffff811f4881>] page_cache_sync_readahead+0x31/0x50
> [  479.828478]  [<ffffffff811e450e>] generic_file_read_iter+0x4fe/0x610
> [  479.828480]  [<ffffffff81107f3d>] ? mark_held_locks+0x7d/0xb0
> [  479.828481]  [<ffffffff8126fd5c>] __vfs_read+0xcc/0x100
> [  479.828482]  [<ffffffff8127067a>] vfs_read+0x8a/0x140
> [  479.828483]  [<ffffffff81271428>] SyS_read+0x58/0xd0
> [  479.828485]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
> [  479.828486] 1 lock held by Cache2 I/O/2943:
> [  479.828486]  #0:  (&f->f_pos_lock){+.+.+.}, at:
> [<ffffffff81293089>] __fdget_pos+0x49/0x50
> [  479.828491] INFO: task mozStorage #2:3046 blocked for more than 120 seconds.
> [  479.828492]       Not tainted 4.2.5-300.fc23.x86_64+debug #1
> [  479.828493] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  479.828493] mozStorage #2   D ffff8807fe7d76d8 12904  3046   2736 0x00000000
> [  479.828497]  ffff880779b0fb68 0000000000000092 ffff880779b0fb38
> 0000000000000000
> [  479.828498]  ffff8807fa342a40 ffff880779898000 ffff880779b0fb88
> ffff880779b10000
> [  479.828500]  ffff8806c347d1f0 ffff880779898000 ffff880779898000
> ffff880779b0fbb0
> [  479.828502] Call Trace:
> [  479.828503]  [<ffffffff8186c82e>] schedule+0x3e/0x90
> [  479.828509]  [<ffffffffa07f54f2>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
> [  479.828510]  [<ffffffff810fbf60>] ? wake_atomic_t_function+0x70/0x70
> [  479.828514]  [<ffffffffa0788834>] btrfs_read_lock_root_node+0x34/0x50 [btrfs]
> [  479.828518]  [<ffffffffa078dbbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
> [  479.828522]  [<ffffffffa078f7c1>] btrfs_insert_empty_items+0x71/0xc0 [btrfs]
> [  479.828525]  [<ffffffffa07883da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
> [  479.828531]  [<ffffffffa07f5be7>] btrfs_insert_orphan_item+0x67/0xa0 [btrfs]
> [  479.828560]  [<ffffffffa07bc668>] btrfs_orphan_add+0xc8/0x1e0 [btrfs]
> [  479.828566]  [<ffffffffa07c29ca>] btrfs_setattr+0x1aa/0x360 [btrfs]
> [  479.828567]  [<ffffffff81291425>] notify_change+0x245/0x360
> [  479.828569]  [<ffffffff8126e1a7>] do_truncate+0x77/0xc0
> [  479.828571]  [<ffffffff8126e4fd>] ? do_sys_ftruncate.constprop.13+0xdd/0x160
> [  479.828572]  [<ffffffff8126e532>] do_sys_ftruncate.constprop.13+0x112/0x160
> [  479.828574]  [<ffffffff81003044>] ? lockdep_sys_exit_thunk+0x12/0x14
> [  479.828576]  [<ffffffff8126e5be>] SyS_ftruncate+0xe/0x10
> [  479.828577]  [<ffffffff8187332e>] entry_SYSCALL_64_fastpath+0x12/0x76
> [  479.828579] 3 locks held by mozStorage #2/3046:
> [  479.828579]  #0:  (sb_writers#16){.+.+.+}, at: [<ffffffff8126e4fd>]
> do_sys_ftruncate.constprop.13+0xdd/0x160
> [  479.828582]  #1:  (&sb->s_type->i_mutex_key#19){+.+.+.}, at:
> [<ffffffff8126e199>] do_truncate+0x69/0xc0
> [  479.828586]  #2:  (sb_internal){.+.+..}, at: [<ffffffffa07b6fcc>]
> start_transaction+0x41c/0x6c0 [btrfs]
> [  502.886801] [drm:drm_mode_addfb2] [FB:72]
> [  502.886815] [drm:drm_mode_setcrtc] [CRTC:21]
>
>
> --
> Best Regards,
> Mike Gavrilov.
