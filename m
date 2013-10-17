Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cobra.newdream.net ([66.33.216.30]:42199 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762318Ab3JQT4P (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Oct 2013 15:56:15 -0400
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id C330980451
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2013 12:56:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 9D97880451
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Oct 2013 12:56:14 -0700 (PDT)
Date: Thu, 17 Oct 2013 12:56:14 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
To: linux-btrfs@vger.kernel.org
Subject: transaction commit deadlock on current rc
Message-ID: <alpine.DEB.2.00.1310171059080.5573@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I'm seeing the deadlock below under a ceph-osd workload.  There may be a 
subtle problem with the async transaction sequence (since nobody but ceph 
uses that that I know of), but not obvious to me why 
create_pending_snapshots would get stuck on btrfs_tree_lock...

[  602.217383] INFO: task kworker/3:2:771 blocked for more than 120 seconds.
[  602.224234]       Not tainted 3.12.0-rc2-ceph-00009-g53d0281 #1
[  602.230216] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  602.238121] kworker/3:2     D ffff88003677df10     0   771      2 0x00000000
[  602.245349] Workqueue: events do_async_commit [btrfs]
[  602.250513]  ffff8800c95c78d8 0000000000000046 0000000000000286 ffff8800638fca08
[  602.258192]  ffff88003677df10 ffff8800c95c7fd8 ffff8800c95c7fd8 ffff8800c95c7fd8
[  602.265867]  ffff880225d2df10 ffff88003677df10 ffff8800c95c78e8 ffff8800638fc8e0
[  602.273545] Call Trace:
[  602.276049]  [<ffffffff81665849>] schedule+0x29/0x70
[  602.281087]  [<ffffffffa0176975>] btrfs_tree_lock+0x75/0x270 [btrfs]
[  602.287509]  [<ffffffff81070310>] ? __init_waitqueue_head+0x60/0x60
[  602.293840]  [<ffffffffa01185bb>] btrfs_lock_root_node+0x3b/0x50 [btrfs]
[  602.300612]  [<ffffffffa011da67>] btrfs_search_slot+0x867/0x930 [btrfs]
[  602.307293]  [<ffffffffa012ac62>] ? run_clustered_refs+0x232/0xf30 [btrfs]
[  602.314236]  [<ffffffffa011f238>] btrfs_insert_empty_items+0x78/0xd0 [btrfs]
[  602.321393]  [<ffffffffa01330cc>] insert_with_overflow+0x3c/0x110 [btrfs]
[  602.328287]  [<ffffffffa013325f>] btrfs_insert_dir_item+0xbf/0x200 [btrfs]
[  602.335229]  [<ffffffffa013f19c>] create_pending_snapshot+0x81c/0xa00 [btrfs]
[  602.342469]  [<ffffffffa013f423>] create_pending_snapshots+0xa3/0xb0 [btrfs]
[  602.349624]  [<ffffffffa01408fe>] btrfs_commit_transaction+0x46e/0xa40 [btrfs]
[  602.356919]  [<ffffffff81070310>] ? __init_waitqueue_head+0x60/0x60
[  602.363291]  [<ffffffffa0140f58>] do_async_commit+0x88/0xa0 [btrfs]
[  602.369665]  [<ffffffffa0140ef9>] ? do_async_commit+0x29/0xa0 [btrfs]
[  602.376166]  [<ffffffff810672fa>] process_one_work+0x1da/0x540
[  602.382099]  [<ffffffff8106728f>] ? process_one_work+0x16f/0x540
[  602.388205]  [<ffffffff810684dc>] worker_thread+0x11c/0x370
[  602.393834]  [<ffffffff810683c0>] ? manage_workers.isra.20+0x2e0/0x2e0
[  602.400462]  [<ffffffff8106fada>] kthread+0xea/0xf0
[  602.405396]  [<ffffffff8106f9f0>] ? flush_kthread_worker+0x150/0x150
[  602.411836]  [<ffffffff8166fdec>] ret_from_fork+0x7c/0xb0
[  602.417300]  [<ffffffff8106f9f0>] ? flush_kthread_worker+0x150/0x150
[  602.423787] INFO: lockdep is turned off.

[  602.427852] INFO: task btrfs-transacti:6069 blocked for more than 120 seconds.
[  602.435155]       Not tainted 3.12.0-rc2-ceph-00009-g53d0281 #1
[  602.441229] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  602.449212] btrfs-transacti D ffff8800c96461e8     0  6069      2 0x00000000
[  602.457660]  ffff88022408fd08 0000000000000046 0000000000000286 ffff8800b68a4578
[  602.465350]  ffff88022448df10 ffff88022408ffd8 ffff88022408ffd8 ffff88022408ffd8
[  602.473081]  ffff880225d29fb0 ffff88022448df10 ffff88022408fd18 ffff880082fd48a8
[  602.480835] Call Trace:
[  602.483342]  [<ffffffff81665849>] schedule+0x29/0x70
[  602.488450]  [<ffffffffa013f74f>] wait_current_trans.isra.33+0xbf/0x120 [btrfs]
[  602.495836]  [<ffffffff81070310>] ? __init_waitqueue_head+0x60/0x60
[  602.502241]  [<ffffffffa01416a8>] start_transaction+0x348/0x540 [btrfs]
[  602.509010]  [<ffffffffa0141907>] btrfs_attach_transaction+0x17/0x20 [btrfs]
[  602.516124]  [<ffffffffa0139c12>] transaction_kthread+0x182/0x250 [btrfs]
[  602.523065]  [<ffffffffa0139a90>] ? btrfs_destroy_delayed_refs+0x370/0x370 [btrfs]
[  602.530791]  [<ffffffff8106fada>] kthread+0xea/0xf0
[  602.535725]  [<ffffffff8106f9f0>] ? flush_kthread_worker+0x150/0x150
[  602.542178]  [<ffffffff8166fdec>] ret_from_fork+0x7c/0xb0
[  602.547658]  [<ffffffff8106f9f0>] ? flush_kthread_worker+0x150/0x150
[  602.554068] INFO: lockdep is turned off.

[  602.558154] INFO: task ceph-osd:12248 blocked for more than 120 seconds.
[  602.558155]       Not tainted 3.12.0-rc2-ceph-00009-g53d0281 #1
[  602.558156] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  602.558158] ceph-osd        D ffff880082fd48a8     0 12248  12215 0x00000000
[  602.558161]  ffff880184441b58 0000000000000046 0000000000000282 ffff8800b68a4578
[  602.558162]  ffff880077fcbf60 ffff880184441fd8 ffff880184441fd8 ffff880184441fd8
[  602.558164]  ffff88003677df10 ffff880077fcbf60 ffff880184441b68 ffff880184441ba0
[  602.558164] Call Trace:
[  602.558166]  [<ffffffff81665849>] schedule+0x29/0x70
[  602.558178]  [<ffffffffa0141af7>] btrfs_commit_transaction_async+0x187/0x2c0 [btrfs]
[  602.558188]  [<ffffffffa01413f6>] ? start_transaction+0x96/0x540 [btrfs]
[  602.558190]  [<ffffffff81070310>] ? __init_waitqueue_head+0x60/0x60
[  602.558201]  [<ffffffffa0171565>] btrfs_mksubvol.isra.59+0x2a5/0x410 [btrfs]
[  602.558204]  [<ffffffff811a3d9c>] ? fget_light+0x3c/0x130
[  602.558216]  [<ffffffffa01717ce>] btrfs_ioctl_snap_create_transid+0xfe/0x190 [btrfs]
[  602.558218]  [<ffffffff81152fb9>] ? might_fault+0x89/0x90
[  602.558230]  [<ffffffffa01719de>] btrfs_ioctl_snap_create_v2+0xfe/0x140 [btrfs]
[  602.558242]  [<ffffffffa0175110>] btrfs_ioctl+0xbe0/0x1e00 [btrfs]
[  602.558253]  [<ffffffffa01536c5>] ? btrfs_file_aio_write+0x275/0x5d0 [btrfs]
[  602.558256]  [<ffffffff811c83aa>] ? fsnotify+0x8a/0x2f0
[  602.558257]  [<ffffffff811c83aa>] ? fsnotify+0x8a/0x2f0
[  602.558259]  [<ffffffff811a3d9c>] ? fget_light+0x3c/0x130
[  602.558263]  [<ffffffff81198ed6>] do_vfs_ioctl+0x96/0x560
[  602.558264]  [<ffffffff811a3dfe>] ? fget_light+0x9e/0x130
[  602.558266]  [<ffffffff811a3d9c>] ? fget_light+0x3c/0x130
[  602.558268]  [<ffffffff81199431>] SyS_ioctl+0x91/0xb0
[  602.558270]  [<ffffffff8134303e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  602.558272]  [<ffffffff8166fe92>] system_call_fastpath+0x16/0x1b
