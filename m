Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:33397 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIANdv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Sep 2014 09:33:51 -0400
Received: by mail-la0-f52.google.com with SMTP id ty20so6027680lab.25
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Sep 2014 06:33:49 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 1 Sep 2014 15:33:49 +0200
Message-ID: <CANg_oxzqyr3Jcx-8ntPPntjVmRjWqheUqaWOWpkhh5Rrw3Ayrw@mail.gmail.com>
Subject: kernel 3.17-rc3: task rsync:2524 blocked for more than 120 seconds
From: john terragon <jterragon@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi.

I'm not sure if this is related to the hung task problem that I've
been seeing in this ml for a while. But  I've been having this
seemingly related problem with 3.15, 3.16 and now 3.17-rc3 (which, if
I'm not mistaken, should have a fix for the hung task problem). So
here it is: I have a usb flash drive with btrfs (on top of dmcrypt)
usually mounted with these options

rw,noatime,compress-force=zlib,ssd,space_cache,autodefrag

When I try to rsync the usb flash drive I get a truck-load of "INFO:
task rsync:2524 blocked for more than 120 seconds" as you can see
below.
The rsync process crawls into an almost complete stop and I can't even
kill it. I know the usb key is OK because I've tried the same thing
with ext4 and xfs and everything went fine.

Any ideas?

Thanks
John


[ 2763.077502] INFO: task rsync:2524 blocked for more than 120 seconds.
[ 2763.077513]       Not tainted 3.17.0-rc3-cu3 #1
[ 2763.077516] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2763.077521] rsync           D ffff880347b63840     0  2524   2523 0x00000000
[ 2763.077531]  ffff880347b633f0 0000000000000082 0000000000013200
ffff880347b2bfd8
[ 2763.077540]  0000000000013200 ffff880347b633f0 ffff8803f73af660
ffff880347b2baa0
[ 2763.077546]  ffff8803f73af664 ffff880347b633f0 00000000ffffffff
ffff8803f73af668
[ 2763.077554] Call Trace:
[ 2763.077573]  [<ffffffff8149d290>] ? schedule_preempt_disabled+0x20/0x60
[ 2763.077582]  [<ffffffff8149ed1b>] ? __mutex_lock_slowpath+0x14b/0x1d0
[ 2763.077593]  [<ffffffff810a7f6a>] ? del_timer_sync+0x4a/0x60
[ 2763.077601]  [<ffffffff8149edb6>] ? mutex_lock+0x16/0x25
[ 2763.077656]  [<ffffffffa03c789e>] ?
btrfs_wait_ordered_roots+0x3e/0x1f0 [btrfs]
[ 2763.077682]  [<ffffffffa039819a>] ? flush_space+0x1ea/0x4b0 [btrfs]
[ 2763.077706]  [<ffffffffa0391a65>] ? get_alloc_profile+0x85/0x1c0 [btrfs]
[ 2763.077730]  [<ffffffffa0397f51>] ? can_overcommit+0x81/0xe0 [btrfs]
[ 2763.077755]  [<ffffffffa0398800>] ?
reserve_metadata_bytes+0x1c0/0x3d0 [btrfs]
[ 2763.077780]  [<ffffffffa0398e58>] ? btrfs_block_rsv_add+0x28/0x50 [btrfs]
[ 2763.077811]  [<ffffffffa03afd72>] ? start_transaction+0x442/0x500 [btrfs]
[ 2763.077839]  [<ffffffffa03a2694>] ?
btrfs_check_dir_item_collision+0x74/0x100 [btrfs]
[ 2763.077871]  [<ffffffffa03bbe1f>] ? btrfs_rename2+0x15f/0x6d0 [btrfs]
[ 2763.077880]  [<ffffffff8105fbeb>] ? capable_wrt_inode_uidgid+0x4b/0x60
[ 2763.077887]  [<ffffffff8105fb00>] ? cap_validate_magic+0x100/0x100
[ 2763.077897]  [<ffffffff811685a1>] ? vfs_rename+0x5a1/0x790
[ 2763.077905]  [<ffffffff81164700>] ? follow_managed+0x2a0/0x2b0
[ 2763.077913]  [<ffffffff81168c13>] ? SYSC_renameat2+0x483/0x530
[ 2763.077922]  [<ffffffff81175bad>] ? notify_change+0x2cd/0x380
[ 2763.077927]  [<ffffffff8115d918>] ? __sb_end_write+0x28/0x60
[ 2763.077937]  [<ffffffff8125a528>] ? lockref_put_or_lock+0x48/0x80
[ 2763.077943]  [<ffffffff811709ed>] ? dput+0xad/0x170
[ 2763.077951]  [<ffffffff81163ffd>] ? path_put+0xd/0x20
[ 2763.077958]  [<ffffffff8115a321>] ? SyS_chmod+0x41/0x90
[ 2763.077966]  [<ffffffff814a0a29>] ? system_call_fastpath+0x16/0x1b
[ 2883.203005] INFO: task kworker/u16:11:1617 blocked for more than 120 seconds.
[ 2883.203017]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.203020] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.203024] kworker/u16:11  D ffff8804185d1740     0  1617      2 0x00000000
[ 2883.203085] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 2883.203091]  ffff8804185d12f0 0000000000000046 0000000000013200
ffff880435f3bfd8
[ 2883.203099]  0000000000013200 ffff8804185d12f0 ffff8803b86bef00
ffff8803e9a761f0
[ 2883.203106]  ffff8803e9a761f0 0000000000000001 0000000000000000
ffff8803aece6520
[ 2883.203113] Call Trace:
[ 2883.203149]  [<ffffffffa03ae717>] ?
wait_current_trans.isra.22+0x97/0xf0 [btrfs]
[ 2883.203161]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.203190]  [<ffffffffa03afbd8>] ? start_transaction+0x2a8/0x500 [btrfs]
[ 2883.203221]  [<ffffffffa03b7970>] ?
btrfs_finish_ordered_io+0x250/0x5c0 [btrfs]
[ 2883.203230]  [<ffffffff8100b579>] ? __switch_to+0x119/0x580
[ 2883.203261]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.203272]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.203280]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.203288]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.203294]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.203301]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203309]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.203315]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203332] INFO: task btrfs-transacti:2126 blocked for more than
120 seconds.
[ 2883.203336]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.203338] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.203341] btrfs-transacti D ffff8803e98a2860     0  2126      2 0x00000000
[ 2883.203348]  ffff8803e98a2410 0000000000000046 0000000000013200
ffff8803e9af3fd8
[ 2883.203355]  0000000000013200 ffff8803e98a2410 ffff88045fa13af0
ffff8803e9af3b48
[ 2883.203361]  ffff88045fdb2928 0000000000000002 ffffffff8149d750
ffff8803e9af3c08
[ 2883.203368] Call Trace:
[ 2883.203378]  [<ffffffff8149d750>] ? bit_wait+0x40/0x40
[ 2883.203386]  [<ffffffff8149d144>] ? io_schedule+0x94/0x120
[ 2883.203394]  [<ffffffff8149d773>] ? bit_wait_io+0x23/0x40
[ 2883.203402]  [<ffffffff8149d495>] ? __wait_on_bit+0x55/0x80
[ 2883.203410]  [<ffffffff810f7c0e>] ? wait_on_page_bit+0x6e/0x80
[ 2883.203418]  [<ffffffff8108c490>] ? autoremove_wake_function+0x30/0x30
[ 2883.203425]  [<ffffffff810f7cf0>] ? filemap_fdatawait_range+0xd0/0x160
[ 2883.203459]  [<ffffffffa03c81d2>] ?
btrfs_wait_ordered_range+0x62/0x120 [btrfs]
[ 2883.203490]  [<ffffffffa03ef4f7>] ?
__btrfs_write_out_cache+0x327/0x3e0 [btrfs]
[ 2883.203520]  [<ffffffffa03ba36c>] ? btrfs_iget+0x20c/0x6b0 [btrfs]
[ 2883.203551]  [<ffffffffa03ef899>] ? btrfs_write_out_cache+0xa9/0xe0 [btrfs]
[ 2883.203578]  [<ffffffffa039f80a>] ?
btrfs_write_dirty_block_groups+0x59a/0x680 [btrfs]
[ 2883.203606]  [<ffffffffa03ad495>] ? commit_cowonly_roots+0x185/0x240 [btrfs]
[ 2883.203634]  [<ffffffffa03af3a4>] ?
btrfs_commit_transaction+0x424/0x9b0 [btrfs]
[ 2883.203660]  [<ffffffffa03af9bb>] ? start_transaction+0x8b/0x500 [btrfs]
[ 2883.203686]  [<ffffffffa03ab07d>] ? transaction_kthread+0x1ad/0x240 [btrfs]
[ 2883.203712]  [<ffffffffa03aaed0>] ?
btrfs_cleanup_transaction+0x4d0/0x4d0 [btrfs]
[ 2883.203719]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.203725]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203732]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.203738]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203745] INFO: task kworker/u16:0:2287 blocked for more than 120 seconds.
[ 2883.203748]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.203751] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.203754] kworker/u16:0   D ffff88044b336d50     0  2287      2 0x00000000
[ 2883.203784] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 2883.203788]  ffff88044b336900 0000000000000046 0000000000013200
ffff880362893fd8
[ 2883.203795]  0000000000013200 ffff88044b336900 ffff8803b86bef00
ffff8803e9a761f0
[ 2883.203802]  ffff8803e9a761f0 0000000000000001 0000000000000000
ffff8803b45650c0
[ 2883.203808] Call Trace:
[ 2883.203835]  [<ffffffffa03ae717>] ?
wait_current_trans.isra.22+0x97/0xf0 [btrfs]
[ 2883.203843]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.203869]  [<ffffffffa03afbd8>] ? start_transaction+0x2a8/0x500 [btrfs]
[ 2883.203898]  [<ffffffffa03b7970>] ?
btrfs_finish_ordered_io+0x250/0x5c0 [btrfs]
[ 2883.203905]  [<ffffffff8100b579>] ? __switch_to+0x119/0x580
[ 2883.203934]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.203943]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.203951]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.203958]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.203964]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.203970]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203977]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.203983]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.203988] INFO: task kworker/u16:1:2395 blocked for more than 120 seconds.
[ 2883.203991]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.203994] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.203997] kworker/u16:1   D ffff880362469780     0  2395      2 0x00000000
[ 2883.204022] Workqueue: btrfs-flush_delalloc
btrfs_flush_delalloc_helper [btrfs]
[ 2883.204025]  ffff880362469330 0000000000000046 0000000000013200
ffff88036328ffd8
[ 2883.204032]  0000000000013200 ffff880362469330 ffff8803bea0d9a0
ffff8803bea0da18
[ 2883.204038]  ffff8803e990d840 ffff88044dc33100 0000000000000000
0000000000000000
[ 2883.204045] Call Trace:
[ 2883.204074]  [<ffffffffa03c7a9d>] ?
btrfs_start_ordered_extent+0x4d/0x90 [btrfs]
[ 2883.204081]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.204108]  [<ffffffffa03c7afc>] ?
btrfs_run_ordered_extent_work+0x1c/0x30 [btrfs]
[ 2883.204133]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.204141]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.204148]  [<ffffffff8106a993>] ? pwq_activate_delayed_work+0x23/0x30
[ 2883.204156]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.204163]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.204169]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.204175]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204181]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.204187]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204192] INFO: task kworker/u16:3:2461 blocked for more than 120 seconds.
[ 2883.204195]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.204198] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.204200] kworker/u16:3   D ffff88042b771740     0  2461      2 0x00000000
[ 2883.204225] Workqueue: btrfs-flush_delalloc
btrfs_flush_delalloc_helper [btrfs]
[ 2883.204228]  ffff88042b7712f0 0000000000000046 0000000000013200
ffff880349157fd8
[ 2883.204234]  0000000000013200 ffff88042b7712f0 ffff8803a5362808
ffff8803a5362880
[ 2883.204241]  ffff8803e990d840 ffff88044dc33100 0000000000000000
0000000000000000
[ 2883.204248] Call Trace:
[ 2883.204274]  [<ffffffffa03c7a9d>] ?
btrfs_start_ordered_extent+0x4d/0x90 [btrfs]
[ 2883.204281]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.204306]  [<ffffffffa03c7afc>] ?
btrfs_run_ordered_extent_work+0x1c/0x30 [btrfs]
[ 2883.204330]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.204337]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.204344]  [<ffffffff8106a993>] ? pwq_activate_delayed_work+0x23/0x30
[ 2883.204352]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.204359]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.204365]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.204371]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204377]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.204383]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204388] INFO: task kworker/u16:4:2462 blocked for more than 120 seconds.
[ 2883.204391]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.204394] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.204396] kworker/u16:4   D ffff880348f257c0     0  2462      2 0x00000000
[ 2883.204421] Workqueue: btrfs-endio-write btrfs_endio_write_helper [btrfs]
[ 2883.204424]  ffff880348f25370 0000000000000046 0000000000013200
ffff880348f2bfd8
[ 2883.204431]  0000000000013200 ffff880348f25370 ffff8803b86bef00
ffff8803e9a761f0
[ 2883.204437]  ffff8803e9a761f0 0000000000000001 0000000000000000
ffff8803b4565200
[ 2883.204444] Call Trace:
[ 2883.204468]  [<ffffffffa03ae717>] ?
wait_current_trans.isra.22+0x97/0xf0 [btrfs]
[ 2883.204475]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.204499]  [<ffffffffa03afbd8>] ? start_transaction+0x2a8/0x500 [btrfs]
[ 2883.204525]  [<ffffffffa03b7970>] ?
btrfs_finish_ordered_io+0x250/0x5c0 [btrfs]
[ 2883.204531]  [<ffffffff8100b579>] ? __switch_to+0x119/0x580
[ 2883.204556]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.204564]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.204571]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.204579]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.204584]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.204591]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204597]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.204603]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204607] INFO: task kworker/u16:5:2473 blocked for more than 120 seconds.
[ 2883.204610]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.204613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.204616] kworker/u16:5   D ffff880426eb39c0     0  2473      2 0x00000000
[ 2883.204639] Workqueue: btrfs-flush_delalloc
btrfs_flush_delalloc_helper [btrfs]
[ 2883.204642]  ffff880426eb3570 0000000000000046 0000000000013200
ffff8800681b7fd8
[ 2883.204648]  0000000000013200 ffff880426eb3570 ffff8803a8f4c808
ffff8803a8f4c880
[ 2883.204655]  ffff8803e990d840 ffff88044dc33100 0000000000000000
0000000000000000
[ 2883.204662] Call Trace:
[ 2883.204688]  [<ffffffffa03c7a9d>] ?
btrfs_start_ordered_extent+0x4d/0x90 [btrfs]
[ 2883.204695]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.204720]  [<ffffffffa03c7afc>] ?
btrfs_run_ordered_extent_work+0x1c/0x30 [btrfs]
[ 2883.204743]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.204750]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.204758]  [<ffffffff8106a993>] ? pwq_activate_delayed_work+0x23/0x30
[ 2883.204765]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.204772]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.204778]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.204784]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204790]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.204796]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204801] INFO: task kworker/u16:6:2480 blocked for more than 120 seconds.
[ 2883.204805]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.204807] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.204810] kworker/u16:6   D ffff88044d610e50     0  2480      2 0x00000000
[ 2883.204832] Workqueue: btrfs-flush_delalloc
btrfs_flush_delalloc_helper [btrfs]
[ 2883.204835]  ffff88044d610a00 0000000000000046 0000000000013200
ffff880347a0ffd8
[ 2883.204842]  0000000000013200 ffff88044d610a00 ffff8803a80adcd0
ffff8803a80add48
[ 2883.204849]  ffff8803e990d840 ffff88044dc33100 0000000000000000
0000000000000000
[ 2883.204855] Call Trace:
[ 2883.204880]  [<ffffffffa03c7a9d>] ?
btrfs_start_ordered_extent+0x4d/0x90 [btrfs]
[ 2883.204887]  [<ffffffff8108c460>] ? prepare_to_wait_event+0xf0/0xf0
[ 2883.204911]  [<ffffffffa03c7afc>] ?
btrfs_run_ordered_extent_work+0x1c/0x30 [btrfs]
[ 2883.204933]  [<ffffffffa03dbb8f>] ? normal_work_helper+0xaf/0x190 [btrfs]
[ 2883.204941]  [<ffffffff8106cd47>] ? process_one_work+0x167/0x380
[ 2883.204948]  [<ffffffff8106a993>] ? pwq_activate_delayed_work+0x23/0x30
[ 2883.204955]  [<ffffffff8106d9b4>] ? worker_thread+0x114/0x480
[ 2883.204962]  [<ffffffff8106d8a0>] ? rescuer_thread+0x2b0/0x2b0
[ 2883.204968]  [<ffffffff81072248>] ? kthread+0xb8/0xd0
[ 2883.204974]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204980]  [<ffffffff814a097c>] ? ret_from_fork+0x7c/0xb0
[ 2883.204986]  [<ffffffff81072190>] ? kthread_create_on_node+0x170/0x170
[ 2883.204992] INFO: task rsync:2524 blocked for more than 120 seconds.
[ 2883.204995]       Not tainted 3.17.0-rc3-cu3 #1
[ 2883.204997] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 2883.205000] rsync           D ffff880347b63840     0  2524   2523 0x00000000
[ 2883.205006]  ffff880347b633f0 0000000000000082 0000000000013200
ffff880347b2bfd8
[ 2883.205013]  0000000000013200 ffff880347b633f0 ffff8803f73af660
ffff880347b2baa0
[ 2883.205019]  ffff8803f73af664 ffff880347b633f0 00000000ffffffff
ffff8803f73af668
[ 2883.205026] Call Trace:
[ 2883.205035]  [<ffffffff8149d290>] ? schedule_preempt_disabled+0x20/0x60
[ 2883.205043]  [<ffffffff8149ed1b>] ? __mutex_lock_slowpath+0x14b/0x1d0
[ 2883.205053]  [<ffffffff810a7f6a>] ? del_timer_sync+0x4a/0x60
[ 2883.205061]  [<ffffffff8149edb6>] ? mutex_lock+0x16/0x25
[ 2883.205085]  [<ffffffffa03c789e>] ?
btrfs_wait_ordered_roots+0x3e/0x1f0 [btrfs]
[ 2883.205109]  [<ffffffffa039819a>] ? flush_space+0x1ea/0x4b0 [btrfs]
[ 2883.205131]  [<ffffffffa0391a65>] ? get_alloc_profile+0x85/0x1c0 [btrfs]
[ 2883.205153]  [<ffffffffa0397f51>] ? can_overcommit+0x81/0xe0 [btrfs]
[ 2883.205176]  [<ffffffffa0398800>] ?
reserve_metadata_bytes+0x1c0/0x3d0 [btrfs]
[ 2883.205200]  [<ffffffffa0398e58>] ? btrfs_block_rsv_add+0x28/0x50 [btrfs]
[ 2883.205224]  [<ffffffffa03afd72>] ? start_transaction+0x442/0x500 [btrfs]
[ 2883.205249]  [<ffffffffa03a2694>] ?
btrfs_check_dir_item_collision+0x74/0x100 [btrfs]
[ 2883.205276]  [<ffffffffa03bbe1f>] ? btrfs_rename2+0x15f/0x6d0 [btrfs]
[ 2883.205283]  [<ffffffff8105fbeb>] ? capable_wrt_inode_uidgid+0x4b/0x60
[ 2883.205290]  [<ffffffff8105fb00>] ? cap_validate_magic+0x100/0x100
[ 2883.205300]  [<ffffffff811685a1>] ? vfs_rename+0x5a1/0x790
[ 2883.205307]  [<ffffffff81164700>] ? follow_managed+0x2a0/0x2b0
[ 2883.205315]  [<ffffffff81168c13>] ? SYSC_renameat2+0x483/0x530
[ 2883.205325]  [<ffffffff81175bad>] ? notify_change+0x2cd/0x380
[ 2883.205331]  [<ffffffff8115d918>] ? __sb_end_write+0x28/0x60
[ 2883.205341]  [<ffffffff8125a528>] ? lockref_put_or_lock+0x48/0x80
[ 2883.205348]  [<ffffffff811709ed>] ? dput+0xad/0x170
[ 2883.205355]  [<ffffffff81163ffd>] ? path_put+0xd/0x20
[ 2883.205363]  [<ffffffff8115a321>] ? SyS_chmod+0x41/0x90
[ 2883.205370]  [<ffffffff814a0a29>] ? system_call_fastpath+0x16/0x1b
