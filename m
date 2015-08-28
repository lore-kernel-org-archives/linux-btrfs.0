Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:35770 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbbH1L21 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Aug 2015 07:28:27 -0400
Received: by labqb2 with SMTP id qb2so6056378lab.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Aug 2015 04:28:25 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Fri, 28 Aug 2015 16:28:10 +0500
Message-ID: <CABXGCsNNoveRpnukzu3Eq0UnR46X0Ck3vx_wQVnLYhF95Pn5VA@mail.gmail.com>
Subject: INFO: task btrfs-transacti:753 blocked for more than 120 seconds.
 (occurred not first time)
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After this system hangs.
dmesg log I am get through ssh and root user.
For /home partition used btrfs file system.


[174914.234404] INFO: task btrfs-transacti:753 blocked for more than
120 seconds.
[174914.234408]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.234408] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.234409] btrfs-transacti D ffff8807fe1d76d8  9640   753      2 0x00000080
[174914.234414]  ffff8807e2c23a38 0000000000000092 ffff8807e2c23a08
0000000000000000
[174914.234416]  ffff8807fa342a40 ffff8807f4f72a40 ffff8807e2c23a58
ffff8807e2c24000
[174914.234418]  ffff8801837aab70 ffff8807f4f72a40 ffff8807f4f72a40
ffff8807e2c23a80
[174914.234420] Call Trace:
[174914.234424]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.234440]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.234442]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.234447]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.234451]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.234452]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.234458]  [<ffffffffa076181e>] btrfs_lookup_inode+0x3e/0xc0 [btrfs]
[174914.234460]  [<ffffffff811080cd>] ? trace_hardirqs_on+0xd/0x10
[174914.234468]  [<ffffffffa07ca0d9>]
__btrfs_update_delayed_inode+0x69/0x210 [btrfs]
[174914.234475]  [<ffffffffa07ca7a8>] ?
__btrfs_run_delayed_items+0x528/0x600 [btrfs]
[174914.234477]  [<ffffffff811080cd>] ? trace_hardirqs_on+0xd/0x10
[174914.234483]  [<ffffffffa07ca7cd>]
__btrfs_run_delayed_items+0x54d/0x600 [btrfs]
[174914.234485]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.234491]  [<ffffffffa07caed3>] btrfs_run_delayed_items+0x13/0x20 [btrfs]
[174914.234498]  [<ffffffffa076d213>]
btrfs_commit_transaction+0x2e3/0xc70 [btrfs]
[174914.234504]  [<ffffffffa07681a8>] transaction_kthread+0x208/0x270 [btrfs]
[174914.234509]  [<ffffffffa0767fa0>] ?
btrfs_cleanup_transaction+0x6e0/0x6e0 [btrfs]
[174914.234511]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.234513]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234515]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.234516]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234517] 2 locks held by btrfs-transacti/753:
[174914.234518]  #0:  (&fs_info->transaction_kthread_mutex){+.+...},
at: [<ffffffffa0768012>] transaction_kthread+0x72/0x270 [btrfs]
[174914.234525]  #1:  (&delayed_node->mutex){+.+.-.}, at:
[<ffffffffa07ca7a8>] __btrfs_run_delayed_items+0x528/0x600 [btrfs]
[174914.234554] INFO: task kworker/u16:9:22966 blocked for more than
120 seconds.
[174914.234555]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.234556] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.234556] kworker/u16:9   D ffff8807fe5d76d8  9112 22966      2 0x00000000
[174914.234566] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.234567]  ffff88005e6c7848 0000000000000096 ffff88005e6c7818
0000000000000000
[174914.234569]  ffff8807fa360000 ffff8800185caa40 ffff88005e6c7868
ffff88005e6c8000
[174914.234570]  ffff8801837aab70 ffff8800185caa40 ffff8800185caa40
ffff88005e6c7890
[174914.234572] Call Trace:
[174914.234574]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.234580]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.234582]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.234586]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.234590]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.234591]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00
[174914.234597]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.234604]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.234606]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.234609]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.234615]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.234621]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.234627]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.234629]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.234634]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.234641]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.234647]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.234649]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.234651]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.234653]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.234655]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.234656]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.234658]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.234659]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.234661]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234662]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.234664]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234665] 3 locks held by kworker/u16:9/22966:
[174914.234665]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234668]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234671]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.234679] INFO: task kworker/u16:10:22967 blocked for more than
120 seconds.
[174914.234680]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.234680] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.234681] kworker/u16:10  D ffff8807fe1d76d8  9992 22967      2 0x00000000
[174914.234690] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.234691]  ffff8800741b7848 0000000000000096 ffff8800741b7818
0000000000000000
[174914.234692]  ffff880017978000 ffff88001797aa40 ffff8800741b7868
ffff8800741b8000
[174914.234694]  ffff8801837aab70 ffff88001797aa40 ffff88001797aa40
ffff8800741b7890
[174914.234696] Call Trace:
[174914.234697]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.234703]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.234705]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.234708]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.234712]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.234714]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.234719]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.234725]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.234727]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.234730]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.234736]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.234742]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.234747]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.234749]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.234754]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.234761]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.234767]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.234769]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.234770]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.234772]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.234773]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.234775]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.234776]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.234778]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.234779]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.234781]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234782]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.234784]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234785] 3 locks held by kworker/u16:10/22967:
[174914.234785]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234788]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234790]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.234798] INFO: task kworker/u16:5:26931 blocked for more than
120 seconds.
[174914.234799]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.234800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.234801] kworker/u16:5   D ffff8807fdfd76d8  9928 26931      2 0x00000000
[174914.234808] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.234809]  ffff88002bdc7848 0000000000000096 ffff88002bdc7818
0000000000000000
[174914.234811]  ffff880762858000 ffff88007fdbd480 ffff88002bdc7868
ffff88002bdc8000
[174914.234812]  ffff8801837aab70 ffff88007fdbd480 ffff88007fdbd480
ffff88002bdc7890
[174914.234814] Call Trace:
[174914.234815]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.234821]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.234823]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.234827]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.234830]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.234832]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00
[174914.234838]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.234844]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.234845]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.234849]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.234854]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.234860]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.234866]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.234867]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.234873]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.234879]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.234885]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.234887]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.234888]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.234890]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.234892]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.234893]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.234895]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.234896]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.234898]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234899]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.234900]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.234901] 3 locks held by kworker/u16:5/26931:
[174914.234902]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234905]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.234907]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.234915] INFO: task kworker/u16:8:27357 blocked for more than
120 seconds.
[174914.234916]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.234917] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.234917] kworker/u16:8   D ffff8807fe7d76d8 10216 27357      2 0x00000000
[174914.234925] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.234926]  ffff8800674db848 0000000000000096 ffff8800674db818
0000000000000000
[174914.234927]  ffff8807c115d480 ffff88007fffd480 ffff8800674db868
ffff8800674dc000
[174914.234929]  ffff8801837aab70 ffff88007fffd480 ffff88007fffd480
ffff8800674db890
[174914.234930] Call Trace:
[174914.234932]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.234938]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.234939]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.234943]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.234947]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.234948]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.234954]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.234960]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.234961]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.234965]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.234970]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.234976]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.234982]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.234983]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.234989]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.234995]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.235001]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.235003]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.235004]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.235006]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.235007]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.235009]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.235011]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.235012]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.235013]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.235015]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235016]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.235018]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235019] 3 locks held by kworker/u16:8/27357:
[174914.235019]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235022]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235025]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.235032] INFO: task kworker/u16:1:29696 blocked for more than
120 seconds.
[174914.235033]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.235034] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.235034] kworker/u16:1   D ffff8807fe9d76d8  8408 29696      2 0x00000000
[174914.235042] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.235043]  ffff88001a8e7848 0000000000000096 ffff88001a8e7818
0000000000000000
[174914.235045]  ffff8807b95b0000 ffff88047f6d2a40 ffff88001a8e7868
ffff88001a8e8000
[174914.235046]  ffff8801837aab70 ffff88047f6d2a40 ffff88047f6d2a40
ffff88001a8e7890
[174914.235048] Call Trace:
[174914.235049]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.235055]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.235056]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.235060]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.235064]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.235066]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.235071]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.235077]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.235078]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.235082]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.235088]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.235093]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.235099]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.235100]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.235106]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.235112]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.235118]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.235120]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.235121]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.235123]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.235124]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.235126]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.235127]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.235129]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.235130]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.235132]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235133]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.235134]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235135] 3 locks held by kworker/u16:1/29696:
[174914.235136]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235139]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235141]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.235149] INFO: task kworker/u16:4:30149 blocked for more than
120 seconds.
[174914.235149]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.235150] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.235151] kworker/u16:4   D ffff8807fe1d76d8 10584 30149      2 0x00000000
[174914.235159] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[174914.235159]  ffff8800674cb848 0000000000000096 ffff8800674cb818
0000000000000000
[174914.235161]  ffff8807fa342a40 ffff8800747f2a40 ffff8800674cb868
ffff8800674cc000
[174914.235163]  ffff8801837aab70 ffff8800747f2a40 ffff8800747f2a40
ffff8800674cb890
[174914.235164] Call Trace:
[174914.235165]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.235172]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.235173]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.235177]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.235181]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.235182]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00
[174914.235188]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.235194]  [<ffffffffa0781ff7>] __btrfs_drop_extents+0x187/0xde0 [btrfs]
[174914.235195]  [<ffffffff8124ce1e>] ? kmem_cache_alloc+0x33e/0x360
[174914.235199]  [<ffffffffa073f3da>] ? btrfs_alloc_path+0x1a/0x20 [btrfs]
[174914.235205]  [<ffffffffa07709e5>]
insert_reserved_file_extent.constprop.62+0xb5/0x310 [btrfs]
[174914.235210]  [<ffffffffa076bcbe>] ?
join_transaction.isra.12+0x10e/0x420 [btrfs]
[174914.235216]  [<ffffffffa0776caf>]
btrfs_finish_ordered_io+0x2ff/0x650 [btrfs]
[174914.235217]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.235223]  [<ffffffffa0777295>] finish_ordered_fn+0x15/0x20 [btrfs]
[174914.235229]  [<ffffffffa07a17b5>]
btrfs_scrubparity_helper+0xf5/0x870 [btrfs]
[174914.235235]  [<ffffffffa07a1fbe>] btrfs_endio_write_helper+0xe/0x10 [btrfs]
[174914.235237]  [<ffffffff810cc3f2>] process_one_work+0x232/0x840
[174914.235238]  [<ffffffff810cc35b>] ? process_one_work+0x19b/0x840
[174914.235240]  [<ffffffff811284cd>] ? debug_lockdep_rcu_enabled+0x1d/0x20
[174914.235241]  [<ffffffff810ccad5>] ? worker_thread+0xd5/0x450
[174914.235243]  [<ffffffff810cca4e>] worker_thread+0x4e/0x450
[174914.235244]  [<ffffffff810cca00>] ? process_one_work+0x840/0x840
[174914.235246]  [<ffffffff810d3694>] kthread+0x104/0x120
[174914.235247]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235249]  [<ffffffff81871cdf>] ret_from_fork+0x3f/0x70
[174914.235250]  [<ffffffff810d3590>] ? kthread_create_on_node+0x250/0x250
[174914.235251] 3 locks held by kworker/u16:4/30149:
[174914.235252]  #0:  ("%s-%s""btrfs", name){.+.+..}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235254]  #1:  ((&work->normal_work)){+.+...}, at:
[<ffffffff810cc35b>] process_one_work+0x19b/0x840
[174914.235257]  #2:  (sb_internal#2){.+.+..}, at:
[<ffffffffa076dfbc>] start_transaction+0x41c/0x6c0 [btrfs]
[174914.235278] INFO: task tracker-store:32128 blocked for more than
120 seconds.
[174914.235279]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.235280] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.235280] tracker-store   D ffff8807fe9d76d8 11224 32128      1 0x00000000
[174914.235284]  ffff88064afdf6b8 0000000000000096 ffff88064afdf688
0000000000000000
[174914.235285]  ffff880018f88000 ffff8807f51a8000 ffff88064afdf6d8
ffff88064afe0000
[174914.235287]  ffff8801837aab70 ffff8807f51a8000 ffff8807f51a8000
ffff88064afdf700
[174914.235288] Call Trace:
[174914.235290]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.235296]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.235297]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.235301]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.235305]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.235311]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.235316]  [<ffffffffa077229b>] btrfs_get_extent+0x16b/0xc40 [btrfs]
[174914.235318]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00
[174914.235319]  [<ffffffff81870dab>] ? _raw_spin_unlock+0x2b/0x40
[174914.235326]  [<ffffffffa078c918>] ? __set_extent_bit+0x3e8/0x530 [btrfs]
[174914.235333]  [<ffffffffa0790bfd>] __do_readpage+0x19d/0x890 [btrfs]
[174914.235339]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235366]  [<ffffffffa0791696>]
__extent_readpages.constprop.41+0x2b6/0x2d0 [btrfs]
[174914.235375]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235383]  [<ffffffffa0791d2b>] extent_readpages+0x1bb/0x1d0 [btrfs]
[174914.235391]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235394]  [<ffffffff811e1c45>] ? __page_cache_alloc+0x135/0x150
[174914.235395]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.235397]  [<ffffffff811e1c45>] ? __page_cache_alloc+0x135/0x150
[174914.235405]  [<ffffffffa076fa5f>] btrfs_readpages+0x1f/0x30 [btrfs]
[174914.235407]  [<ffffffff811f400f>] __do_page_cache_readahead+0x2af/0x330
[174914.235409]  [<ffffffff811f3edd>] ? __do_page_cache_readahead+0x17d/0x330
[174914.235411]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[174914.235413]  [<ffffffff811f42fb>] ondemand_readahead+0x26b/0x460
[174914.235414]  [<ffffffff811f41d7>] ? ondemand_readahead+0x147/0x460
[174914.235416]  [<ffffffff811f4611>] page_cache_sync_readahead+0x31/0x50
[174914.235418]  [<ffffffff811e429e>] generic_file_read_iter+0x4fe/0x610
[174914.235420]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.235424]  [<ffffffff8126faac>] __vfs_read+0xcc/0x100
[174914.235426]  [<ffffffff812703ca>] vfs_read+0x8a/0x140
[174914.235427]  [<ffffffff81271178>] SyS_read+0x58/0xd0
[174914.235429]  [<ffffffff818718ae>] entry_SYSCALL_64_fastpath+0x12/0x76
[174914.235431]  [<ffffffff8187188b>] ? entry_SYSCALL_64_after_swapgs+0x38/0x49
[174914.235433] 1 lock held by tracker-store/32128:
[174914.235433]  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<ffffffff81292d09>] __fdget_pos+0x49/0x50
[174914.235453] INFO: task htop:32453 blocked for more than 120 seconds.
[174914.235454]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.235455] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.235456] htop            D ffff8807fe7d76d8 12216 32453  32417 0x00000000
[174914.235460]  ffff8805fe88fc80 0000000000000082 ffffffff81870e30
ffffffff00000000
[174914.235462]  ffff8807fa362a40 ffff88010ee0d480 ffff8805fe88fc70
ffff8805fe890000
[174914.235465]  ffff8807f5306930 ffffffffffffffff ffff8807f5306948
ffff8807f5306880
[174914.235467] Call Trace:
[174914.235469]  [<ffffffff81870e30>] ? _raw_spin_unlock_irq+0x30/0x50
[174914.235470]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.235472]  [<ffffffff8186f267>] rwsem_down_read_failed+0xc7/0x130
[174914.235474]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[174914.235477]  [<ffffffff8142e5f4>] call_rwsem_down_read_failed+0x14/0x30
[174914.235478]  [<ffffffff8186eab3>] ? down_read+0x83/0xa0
[174914.235481]  [<ffffffff812ecdc1>] ? proc_pid_cmdline_read+0xb1/0x570
[174914.235483]  [<ffffffff812ecdc1>] proc_pid_cmdline_read+0xb1/0x570
[174914.235485]  [<ffffffff81108039>] ? trace_hardirqs_on_caller+0x129/0x1b0
[174914.235487]  [<ffffffff811080cd>] ? trace_hardirqs_on+0xd/0x10
[174914.235489]  [<ffffffff8126fa17>] __vfs_read+0x37/0x100
[174914.235492]  [<ffffffff813980e3>] ? security_file_permission+0xa3/0xc0
[174914.235494]  [<ffffffff812703ca>] vfs_read+0x8a/0x140
[174914.235495]  [<ffffffff81271178>] SyS_read+0x58/0xd0
[174914.235497]  [<ffffffff818718ae>] entry_SYSCALL_64_fastpath+0x12/0x76
[174914.235499] 1 lock held by htop/32453:
[174914.235500]  #0:  (&mm->mmap_sem){++++++}, at:
[<ffffffff812ecdc1>] proc_pid_cmdline_read+0xb1/0x570
[174914.235508] INFO: task Cache2 I/O:32596 blocked for more than 120 seconds.
[174914.235509]       Not tainted 4.2.0-0.rc8.git0.1.fc23.x86_64+debug #1
[174914.235510] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[174914.235510] Cache2 I/O      D ffff8807fe9d76d8 11416 32596  32516 0x00000000
[174914.235514]  ffff8807107636b8 0000000000000096 ffff880710763688
0000000000000000
[174914.235516]  ffff8807b95b0000 ffff8807482f0000 ffff8807107636d8
ffff880710764000
[174914.235519]  ffff8801837aab70 ffff8807482f0000 ffff8807482f0000
ffff880710763700
[174914.235521] Call Trace:
[174914.235523]  [<ffffffff8186ad9e>] schedule+0x3e/0x90
[174914.235532]  [<ffffffffa07ac342>] btrfs_tree_read_lock+0x102/0x160 [btrfs]
[174914.235534]  [<ffffffff810fbf00>] ? wake_atomic_t_function+0x70/0x70
[174914.235539]  [<ffffffffa073f834>]
btrfs_read_lock_root_node+0x34/0x50 [btrfs]
[174914.235545]  [<ffffffffa0744bbe>] btrfs_search_slot+0x74e/0xa10 [btrfs]
[174914.235553]  [<ffffffffa075f8d9>] btrfs_lookup_file_extent+0x49/0x60 [btrfs]
[174914.235571]  [<ffffffffa077229b>] btrfs_get_extent+0x16b/0xc40 [btrfs]
[174914.235573]  [<ffffffff811090e9>] ? __lock_acquire+0xcb9/0x1d00
[174914.235575]  [<ffffffff81870dab>] ? _raw_spin_unlock+0x2b/0x40
[174914.235584]  [<ffffffffa078c8dc>] ? __set_extent_bit+0x3ac/0x530 [btrfs]
[174914.235603]  [<ffffffffa0790bfd>] __do_readpage+0x19d/0x890 [btrfs]
[174914.235610]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235618]  [<ffffffffa0791696>]
__extent_readpages.constprop.41+0x2b6/0x2d0 [btrfs]
[174914.235625]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235633]  [<ffffffffa0791d2b>] extent_readpages+0x1bb/0x1d0 [btrfs]
[174914.235640]  [<ffffffffa0772130>] ?
btrfs_writepage_end_io_hook+0x300/0x300 [btrfs]
[174914.235642]  [<ffffffff81026d49>] ? sched_clock+0x9/0x10
[174914.235644]  [<ffffffff811e1c45>] ? __page_cache_alloc+0x135/0x150
[174914.235661]  [<ffffffffa076fa5f>] btrfs_readpages+0x1f/0x30 [btrfs]
[174914.235663]  [<ffffffff811f400f>] __do_page_cache_readahead+0x2af/0x330
[174914.235664]  [<ffffffff811f3edd>] ? __do_page_cache_readahead+0x17d/0x330
[174914.235666]  [<ffffffff81026cd8>] ? native_sched_clock+0x28/0x90
[174914.235669]  [<ffffffff811f42fb>] ondemand_readahead+0x26b/0x460
[174914.235670]  [<ffffffff811f41d7>] ? ondemand_readahead+0x147/0x460
[174914.235672]  [<ffffffff811f4611>] page_cache_sync_readahead+0x31/0x50
[174914.235674]  [<ffffffff811e429e>] generic_file_read_iter+0x4fe/0x610
[174914.235676]  [<ffffffff81107edd>] ? mark_held_locks+0x7d/0xb0
[174914.235678]  [<ffffffff8126faac>] __vfs_read+0xcc/0x100
[174914.235680]  [<ffffffff812703ca>] vfs_read+0x8a/0x140
[174914.235681]  [<ffffffff81271178>] SyS_read+0x58/0xd0
[174914.235683]  [<ffffffff818718ae>] entry_SYSCALL_64_fastpath+0x12/0x76
[174914.235685] 1 lock held by Cache2 I/O/32596:
[174914.235686]  #0:  (&f->f_pos_lock){+.+.+.}, at:
[<ffffffff81292d09>] __fdget_pos+0x49/0x50


$ btrfs --version
btrfs-progs v4.1.2


--
Best Regards,
Mike Gavrilov.
