Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:60248 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaIIO3O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Sep 2014 10:29:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-btrfs@vger.kernel.org
Cc: Chris Mason <clm@fb.com>
Subject: ENOSPC on mostly empty file system
Date: Tue, 09 Sep 2014 16:29:05 +0200
Message-ID: <3150960.nnNb4J6vhp@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

As I mentioned at the kernel summit, I have a file system that I use mostly
for storing my one kernel git tree and occasionally some build trees
(those are normally on a tmpfs), and I have again run into the problem
where the file system is only partially full (I think 18% in this case)
but I am unable to create new files.

As you recommended, I have created an image using btrfs-image and
uploaded it to google drive for inspection.

I also played around with it some more. After removing a few small
files, I could create new files with up to 20-60MB again before hitting
ENOSPC. I then did a 'make clean' in all the object directories I had
and after that could fill the file system up to 100% by creating a
62GB file using the same command (dd if=/dev/zero of=x).

While probably unrelated, I also saw a few older 'hung task' messages
with btrfs call chains in dmesg and I'm adding them here in this mail
as well. The kernel messages are ten days old, but I did not reboot
in the meantime and I never saw them again before or after that.
The kernel is the stock Ubuntu 3.16.0 image from Ubuntu, I upgrade
to that after running an old 3.11 kernel that I never rebooted.

The 82 MB image file is at
https://drive.google.com/file/d/0B_XQwQ5KlfJAWDJfS1E0TG1CLTA/edit?usp=sharing

	Arnd

[407459.475639] INFO: task BrowserBlocking:3282 blocked for more than 120 seconds.
[407459.475649]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407459.475652] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407459.475656] BrowserBlocking D ffff88042fc94800     0  3282   2580 0x00000000
[407459.475664]  ffff88040d9f7db0 0000000000000086 ffff88041215b2a0 0000000000014800
[407459.475671]  ffff88040d9f7fd8 0000000000014800 ffff88041215b2a0 ffff8800bbb12af8
[407459.475677]  ffff8800bbb12afc ffff88041215b2a0 00000000ffffffff ffff8800bbb12b00
[407459.475683] Call Trace:
[407459.475699]  [<ffffffff8177b609>] schedule_preempt_disabled+0x29/0x70
[407459.475707]  [<ffffffff8177dba5>] __mutex_lock_slowpath+0xd5/0x1f0
[407459.475714]  [<ffffffff8177dcdf>] mutex_lock+0x1f/0x30
[407459.475771]  [<ffffffffc0546535>] btrfs_log_inode_parent+0xd5/0x550 [btrfs]
[407459.475804]  [<ffffffffc0547822>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
[407459.475834]  [<ffffffffc0517d64>] btrfs_sync_file+0x184/0x300 [btrfs]
[407459.475844]  [<ffffffff81210461>] do_fsync+0x51/0x80
[407459.475849]  [<ffffffff812106f0>] SyS_fsync+0x10/0x20
[407459.475856]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f
[407459.475861] INFO: task BrowserBlocking:3283 blocked for more than 120 seconds.
[407459.475864]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407459.475866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407459.475869] BrowserBlocking D ffff88042fd54800     0  3283   2580 0x00000000
[407459.475875]  ffff88040bb13db0 0000000000000086 ffff88041215ef60 0000000000014800
[407459.475881]  ffff88040bb13fd8 0000000000014800 ffff88041215ef60 ffff880429b43590
[407459.475886]  ffff880429b43594 ffff88041215ef60 00000000ffffffff ffff880429b43598
[407459.475892] Call Trace:
[407459.475899]  [<ffffffff8177b609>] schedule_preempt_disabled+0x29/0x70
[407459.475906]  [<ffffffff8177dba5>] __mutex_lock_slowpath+0xd5/0x1f0
[407459.475912]  [<ffffffff8177dcdf>] mutex_lock+0x1f/0x30
[407459.475943]  [<ffffffffc0546895>] btrfs_log_inode_parent+0x435/0x550 [btrfs]
[407459.475976]  [<ffffffffc0547822>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
[407459.476005]  [<ffffffffc0517d64>] btrfs_sync_file+0x184/0x300 [btrfs]
[407459.476012]  [<ffffffff81210461>] do_fsync+0x51/0x80
[407459.476018]  [<ffffffff81210713>] SyS_fdatasync+0x13/0x20
[407459.476023]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f
[407459.476099] INFO: task kworker/u65:6:2090685 blocked for more than 120 seconds.
[407459.476102]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407459.476104] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407459.476107] kworker/u65:6   D ffff88042fd14800     0 2090685      2 0x00000000
[407459.476131] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[407459.476134]  ffff8806189ffba0 0000000000000046 ffff880428135100 0000000000014800
[407459.476140]  ffff8806189fffd8 0000000000014800 ffff880428135100 ffff8806189ffcc8
[407459.476145]  ffff8806189ffcc0 7fffffffffffffff ffff880428135100 0000000000000001
[407459.476151] Call Trace:
[407459.476158]  [<ffffffff8177b089>] schedule+0x29/0x70
[407459.476164]  [<ffffffff8177a349>] schedule_timeout+0x229/0x2a0
[407459.476171]  [<ffffffff8108b026>] ? __queue_work+0x136/0x340
[407459.476177]  [<ffffffff8108b2fa>] ? __queue_delayed_work+0xaa/0x1c0
[407459.476184]  [<ffffffff8177c214>] wait_for_completion+0xb4/0x1e0
[407459.476191]  [<ffffffff810a5400>] ? wake_up_state+0x20/0x20
[407459.476198]  [<ffffffff812096c1>] writeback_inodes_sb_nr+0x81/0xb0
[407459.476221]  [<ffffffffc04efb08>] flush_space+0x458/0x4f0 [btrfs]
[407459.476243]  [<ffffffffc04ef617>] ? can_overcommit+0x67/0x100 [btrfs]
[407459.476266]  [<ffffffffc04efd0c>] btrfs_async_reclaim_metadata_space+0x16c/0x1e0 [btrfs]
[407459.476273]  [<ffffffff8108d812>] process_one_work+0x182/0x4e0
[407459.476278]  [<ffffffff8108dbdb>] worker_thread+0x6b/0x6a0
[407459.476284]  [<ffffffff8108db70>] ? process_one_work+0x4e0/0x4e0
[407459.476290]  [<ffffffff81094a1b>] kthread+0xdb/0x100
[407459.476297]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407459.476302]  [<ffffffff8177fe7c>] ret_from_fork+0x7c/0xb0
[407459.476308]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407579.528238] INFO: task kworker/u65:6:2090685 blocked for more than 120 seconds.
[407579.528247]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407579.528251] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407579.528255] kworker/u65:6   D ffff88042fd14800     0 2090685      2 0x00000000
[407579.528308] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[407579.528312]  ffff8806189ffba0 0000000000000046 ffff880428135100 0000000000014800
[407579.528318]  ffff8806189fffd8 0000000000014800 ffff880428135100 ffff8806189ffcc8
[407579.528324]  ffff8806189ffcc0 7fffffffffffffff ffff880428135100 0000000000000001
[407579.528330] Call Trace:
[407579.528345]  [<ffffffff8177b089>] schedule+0x29/0x70
[407579.528352]  [<ffffffff8177a349>] schedule_timeout+0x229/0x2a0
[407579.528360]  [<ffffffff8108b026>] ? __queue_work+0x136/0x340
[407579.528366]  [<ffffffff8108b2fa>] ? __queue_delayed_work+0xaa/0x1c0
[407579.528373]  [<ffffffff8177c214>] wait_for_completion+0xb4/0x1e0
[407579.528380]  [<ffffffff810a5400>] ? wake_up_state+0x20/0x20
[407579.528388]  [<ffffffff812096c1>] writeback_inodes_sb_nr+0x81/0xb0
[407579.528411]  [<ffffffffc04efb08>] flush_space+0x458/0x4f0 [btrfs]
[407579.528434]  [<ffffffffc04ef617>] ? can_overcommit+0x67/0x100 [btrfs]
[407579.528458]  [<ffffffffc04efd0c>] btrfs_async_reclaim_metadata_space+0x16c/0x1e0 [btrfs]
[407579.528464]  [<ffffffff8108d812>] process_one_work+0x182/0x4e0
[407579.528470]  [<ffffffff8108dbdb>] worker_thread+0x6b/0x6a0
[407579.528475]  [<ffffffff8108db70>] ? process_one_work+0x4e0/0x4e0
[407579.528481]  [<ffffffff81094a1b>] kthread+0xdb/0x100
[407579.528488]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407579.528494]  [<ffffffff8177fe7c>] ret_from_fork+0x7c/0xb0
[407579.528501]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407699.580802] INFO: task kworker/u65:6:2090685 blocked for more than 120 seconds.
[407699.580811]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407699.580815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407699.580818] kworker/u65:6   D ffff88042fd14800     0 2090685      2 0x00000000
[407699.580872] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[407699.580877]  ffff8806189ffba0 0000000000000046 ffff880428135100 0000000000014800
[407699.580883]  ffff8806189fffd8 0000000000014800 ffff880428135100 ffff8806189ffcc8
[407699.580889]  ffff8806189ffcc0 7fffffffffffffff ffff880428135100 0000000000000001
[407699.580895] Call Trace:
[407699.580910]  [<ffffffff8177b089>] schedule+0x29/0x70
[407699.580917]  [<ffffffff8177a349>] schedule_timeout+0x229/0x2a0
[407699.580925]  [<ffffffff8108b026>] ? __queue_work+0x136/0x340
[407699.580930]  [<ffffffff8108b2fa>] ? __queue_delayed_work+0xaa/0x1c0
[407699.580938]  [<ffffffff8177c214>] wait_for_completion+0xb4/0x1e0
[407699.580945]  [<ffffffff810a5400>] ? wake_up_state+0x20/0x20
[407699.580952]  [<ffffffff812096c1>] writeback_inodes_sb_nr+0x81/0xb0
[407699.580976]  [<ffffffffc04efb08>] flush_space+0x458/0x4f0 [btrfs]
[407699.580999]  [<ffffffffc04ef617>] ? can_overcommit+0x67/0x100 [btrfs]
[407699.581022]  [<ffffffffc04efd0c>] btrfs_async_reclaim_metadata_space+0x16c/0x1e0 [btrfs]
[407699.581029]  [<ffffffff8108d812>] process_one_work+0x182/0x4e0
[407699.581034]  [<ffffffff8108dbdb>] worker_thread+0x6b/0x6a0
[407699.581040]  [<ffffffff8108db70>] ? process_one_work+0x4e0/0x4e0
[407699.581046]  [<ffffffff81094a1b>] kthread+0xdb/0x100
[407699.581053]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407699.581059]  [<ffffffff8177fe7c>] ret_from_fork+0x7c/0xb0
[407699.581066]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407819.633225] INFO: task BrowserBlocking:3282 blocked for more than 120 seconds.
[407819.633234]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407819.633238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407819.633242] BrowserBlocking D ffff88042fc94800     0  3282   2580 0x00000000
[407819.633250]  ffff88040d9f7db0 0000000000000086 ffff88041215b2a0 0000000000014800
[407819.633256]  ffff88040d9f7fd8 0000000000014800 ffff88041215b2a0 ffff8800bbb12af8
[407819.633262]  ffff8800bbb12afc ffff88041215b2a0 00000000ffffffff ffff8800bbb12b00
[407819.633269] Call Trace:
[407819.633285]  [<ffffffff8177b609>] schedule_preempt_disabled+0x29/0x70
[407819.633292]  [<ffffffff8177dba5>] __mutex_lock_slowpath+0xd5/0x1f0
[407819.633299]  [<ffffffff8177dcdf>] mutex_lock+0x1f/0x30
[407819.633357]  [<ffffffffc0546535>] btrfs_log_inode_parent+0xd5/0x550 [btrfs]
[407819.633390]  [<ffffffffc0547822>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
[407819.633419]  [<ffffffffc0517d64>] btrfs_sync_file+0x184/0x300 [btrfs]
[407819.633429]  [<ffffffff81210461>] do_fsync+0x51/0x80
[407819.633435]  [<ffffffff812106f0>] SyS_fsync+0x10/0x20
[407819.633440]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f
[407819.633446] INFO: task BrowserBlocking:3284 blocked for more than 120 seconds.
[407819.633449]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407819.633451] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407819.633454] BrowserBlocking D ffff88042fc14800     0  3284   2580 0x00000000
[407819.633460]  ffff880416d4fdb0 0000000000000086 ffff88041215e540 0000000000014800
[407819.633466]  ffff880416d4ffd8 0000000000014800 ffff88041215e540 ffff880429b43590
[407819.633471]  ffff880429b43594 ffff88041215e540 00000000ffffffff ffff880429b43598
[407819.633477] Call Trace:
[407819.633485]  [<ffffffff8177b609>] schedule_preempt_disabled+0x29/0x70
[407819.633491]  [<ffffffff8177dba5>] __mutex_lock_slowpath+0xd5/0x1f0
[407819.633498]  [<ffffffff8177dcdf>] mutex_lock+0x1f/0x30
[407819.633530]  [<ffffffffc0546895>] btrfs_log_inode_parent+0x435/0x550 [btrfs]
[407819.633561]  [<ffffffffc0547822>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
[407819.633590]  [<ffffffffc0517d64>] btrfs_sync_file+0x184/0x300 [btrfs]
[407819.633597]  [<ffffffff81210461>] do_fsync+0x51/0x80
[407819.633603]  [<ffffffff81210713>] SyS_fdatasync+0x13/0x20
[407819.633608]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f
[407819.633687] INFO: task kworker/u65:6:2090685 blocked for more than 120 seconds.
[407819.633690]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407819.633693] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407819.633695] kworker/u65:6   D ffff88042fd14800     0 2090685      2 0x00000000
[407819.633719] Workqueue: events_unbound btrfs_async_reclaim_metadata_space [btrfs]
[407819.633722]  ffff8806189ffba0 0000000000000046 ffff880428135100 0000000000014800
[407819.633728]  ffff8806189fffd8 0000000000014800 ffff880428135100 ffff8806189ffcc8
[407819.633734]  ffff8806189ffcc0 7fffffffffffffff ffff880428135100 0000000000000001
[407819.633739] Call Trace:
[407819.633747]  [<ffffffff8177b089>] schedule+0x29/0x70
[407819.633753]  [<ffffffff8177a349>] schedule_timeout+0x229/0x2a0
[407819.633760]  [<ffffffff8108b026>] ? __queue_work+0x136/0x340
[407819.633765]  [<ffffffff8108b2fa>] ? __queue_delayed_work+0xaa/0x1c0
[407819.633772]  [<ffffffff8177c214>] wait_for_completion+0xb4/0x1e0
[407819.633779]  [<ffffffff810a5400>] ? wake_up_state+0x20/0x20
[407819.633786]  [<ffffffff812096c1>] writeback_inodes_sb_nr+0x81/0xb0
[407819.633809]  [<ffffffffc04efb08>] flush_space+0x458/0x4f0 [btrfs]
[407819.633832]  [<ffffffffc04ef617>] ? can_overcommit+0x67/0x100 [btrfs]
[407819.633854]  [<ffffffffc04efd0c>] btrfs_async_reclaim_metadata_space+0x16c/0x1e0 [btrfs]
[407819.633861]  [<ffffffff8108d812>] process_one_work+0x182/0x4e0
[407819.633866]  [<ffffffff8108dbdb>] worker_thread+0x6b/0x6a0
[407819.633872]  [<ffffffff8108db70>] ? process_one_work+0x4e0/0x4e0
[407819.633878]  [<ffffffff81094a1b>] kthread+0xdb/0x100
[407819.633885]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407819.633890]  [<ffffffff8177fe7c>] ret_from_fork+0x7c/0xb0
[407819.633897]  [<ffffffff81094940>] ? kthread_create_on_node+0x1c0/0x1c0
[407819.633907] INFO: task find:2091978 blocked for more than 120 seconds.
[407819.633910]       Not tainted 3.16.0-10-generic #15-Ubuntu
[407819.633913] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[407819.633915] find            D ffff88042fc94800     0 2091978 2091977 0x00000000
[407819.633921]  ffff8805c8c83ab0 0000000000000086 ffff880271929e60 0000000000014800
[407819.633926]  ffff8805c8c83fd8 0000000000014800 ffff880271929e60 ffff8805c8c83bd8
[407819.633932]  ffff8805c8c83bd0 7fffffffffffffff ffff880271929e60 0000000000000001
[407819.633937] Call Trace:
[407819.633944]  [<ffffffff8177b089>] schedule+0x29/0x70
[407819.633950]  [<ffffffff8177a349>] schedule_timeout+0x229/0x2a0
[407819.633955]  [<ffffffff8108b026>] ? __queue_work+0x136/0x340
[407819.633976]  [<ffffffffc04eb215>] ? block_rsv_release_bytes+0x115/0x180 [btrfs]
[407819.633981]  [<ffffffff8108b2fa>] ? __queue_delayed_work+0xaa/0x1c0
[407819.633988]  [<ffffffff8177c214>] wait_for_completion+0xb4/0x1e0
[407819.633994]  [<ffffffff810a5400>] ? wake_up_state+0x20/0x20
[407819.633999]  [<ffffffff812096c1>] writeback_inodes_sb_nr+0x81/0xb0
[407819.634023]  [<ffffffffc04efb08>] flush_space+0x458/0x4f0 [btrfs]
[407819.634046]  [<ffffffffc04ef617>] ? can_overcommit+0x67/0x100 [btrfs]
[407819.634068]  [<ffffffffc04eff83>] reserve_metadata_bytes+0x203/0x490 [btrfs]
[407819.634075]  [<ffffffff8177dcd2>] ? mutex_lock+0x12/0x30
[407819.634099]  [<ffffffffc04f0786>] btrfs_block_rsv_add+0x26/0x50 [btrfs]
[407819.634126]  [<ffffffffc0507e03>] start_transaction+0x453/0x590 [btrfs]
[407819.634154]  [<ffffffffc0507f5b>] btrfs_start_transaction+0x1b/0x20 [btrfs]
[407819.634182]  [<ffffffffc050d4a8>] btrfs_dirty_inode+0xb8/0xf0 [btrfs]
[407819.634210]  [<ffffffffc050d55f>] btrfs_update_time+0x7f/0xc0 [btrfs]
[407819.634217]  [<ffffffff811fb285>] update_time+0x25/0xd0
[407819.634223]  [<ffffffff811fb409>] touch_atime+0xd9/0x140
[407819.634228]  [<ffffffff811f3b60>] iterate_dir+0xe0/0x130
[407819.634234]  [<ffffffff811f3fb9>] SyS_getdents+0x89/0x100
[407819.634238]  [<ffffffff811f3c80>] ? fillonedir+0xd0/0xd0
[407819.634244]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f
[408133.512919] audit: type=1400 audit(1409380699.459:52): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/lib/cups/backend/cups-pdf" pid=2092471 comm="apparmor_parser"
[408133.512930] audit: type=1400 audit(1409380699.459:53): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" pid=2092471 comm="apparmor_parser"
[408133.513460] audit: type=1400 audit(1409380699.459:54): apparmor="STATUS" operation="profile_replace" profile="unconfined" name="/usr/sbin/cupsd" pid=2092471 comm="apparmor_parser"
[408299.843229] INFO: task BrowserBlocking:3282 blocked for more than 120 seconds.
[408299.843238]       Not tainted 3.16.0-10-generic #15-Ubuntu
[408299.843241] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[408299.843245] BrowserBlocking D ffff88042fc14800     0  3282   2580 0x00000000
[408299.843253]  ffff88040d9f7db0 0000000000000086 ffff88041215b2a0 0000000000014800
[408299.843260]  ffff88040d9f7fd8 0000000000014800 ffff88041215b2a0 ffff880429b43590
[408299.843266]  ffff880429b43594 ffff88041215b2a0 00000000ffffffff ffff880429b43598
[408299.843272] Call Trace:
[408299.843288]  [<ffffffff8177b609>] schedule_preempt_disabled+0x29/0x70
[408299.843296]  [<ffffffff8177dba5>] __mutex_lock_slowpath+0xd5/0x1f0
[408299.843303]  [<ffffffff8177dcdf>] mutex_lock+0x1f/0x30
[408299.843360]  [<ffffffffc0546895>] btrfs_log_inode_parent+0x435/0x550 [btrfs]
[408299.843393]  [<ffffffffc0547822>] btrfs_log_dentry_safe+0x42/0x60 [btrfs]
[408299.843423]  [<ffffffffc0517d64>] btrfs_sync_file+0x184/0x300 [btrfs]
[408299.843432]  [<ffffffff81210461>] do_fsync+0x51/0x80
[408299.843438]  [<ffffffff812106f0>] SyS_fsync+0x10/0x20
[408299.843444]  [<ffffffff8177ff2d>] system_call_fastpath+0x1a/0x1f

