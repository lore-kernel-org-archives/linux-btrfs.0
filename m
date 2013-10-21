Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:48947 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab3JUIhM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Oct 2013 04:37:12 -0400
Received: by mail-pd0-f176.google.com with SMTP id g10so6401128pdj.35
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Oct 2013 01:37:11 -0700 (PDT)
MIME-Version: 1.0
From: david pu <pulq.ustc@gmail.com>
Date: Mon, 21 Oct 2013 16:36:41 +0800
Message-ID: <CA+yNr1dyhC1=Rv=wuzV-YzSdEOmEEB=OLo=SJwmSMvsvhmmZ-g@mail.gmail.com>
Subject: task btrfs-transacti:1076 blocked for more than 120 seconds
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,
I'm running into btrfs-transaction hang issue with below call trace
from dmesg[1].
when this issue happens, all filesystem r/w access will be blocked and
no response in terminal. I'm using Ubuntu raring(linux 3.2 kernel)
64bit kernel as below:
Linux dpu-e6410 3.2.0-36-generic #57-Ubuntu SMP Tue Jan 8 21:44:52 UTC
2013 x86_64 x86_64 x86_64 GNU/Linux

is it a known issue? How to recover from such task hung status?

Thanks!
David

[1]
----
[ 1080.532172] INFO: task tar:3368 blocked for more than 120 seconds.
[ 1080.532178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1080.532181] tar             D ffff88043fc53ec0     0  3368   3269 0x00000000
[ 1080.532188]  ffff8803fe42ddc8 0000000000000082 ffff88040d9745c0
ffff8803fe42dfd8
[ 1080.532194]  ffff8803fe42dfd8 ffff8803fe42dfd8 ffff880429542e80
ffff88040d9745c0
[ 1080.532200]  ffff880415321d00 ffff8804289241e8 ffff8804289241e8
0000000000000000
[ 1080.532206] Call Trace:
[ 1080.532219]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1080.532257]  [<ffffffffa00bf23d>]
wait_current_trans.isra.28+0x9d/0x100 [btrfs]
[ 1080.532264]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1080.532285]  [<ffffffffa00c09a8>] start_transaction+0x158/0x460 [btrfs]
[ 1080.532290]  [<ffffffff811a3040>] ? kern_path_create+0x90/0x170
[ 1080.532310]  [<ffffffffa00c0fe8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[ 1080.532330]  [<ffffffffa00cd91e>] btrfs_mkdir+0x4e/0x1d0 [btrfs]
[ 1080.532338]  [<ffffffff812cefec>] ? security_inode_permission+0x1c/0x30
[ 1080.532343]  [<ffffffff8119f3e6>] vfs_mkdir+0xa6/0x130
[ 1080.532348]  [<ffffffff811a44ba>] sys_mkdirat+0xaa/0xf0
[ 1080.532353]  [<ffffffff816d59dd>] system_call_fastpath+0x1a/0x1f
[ 1200.532111] INFO: task btrfs-transacti:1076 blocked for more than
120 seconds.
[ 1200.532117] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.532120] btrfs-transacti D ffff88043fc13ec0     0  1076      2 0x00000000
[ 1200.532127]  ffff88041bb73d38 0000000000000046 ffff88042576ae80
ffff88041bb73fd8
[ 1200.532134]  ffff88041bb73fd8 ffff88041bb73fd8 ffffffff81c15440
ffff88042576ae80
[ 1200.532139]  ffff8804289a4800 ffff880409819130 ffff880415321d00
0000000000000000
[ 1200.532145] Call Trace:
[ 1200.532159]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1200.532165]  [<ffffffff816ca68c>] schedule_timeout+0x1ec/0x2b0
[ 1200.532205]  [<ffffffffa00d6929>] ?
btrfs_run_ordered_operations+0x2b9/0x2f0 [btrfs]
[ 1200.532213]  [<ffffffff81044b49>] ? default_spin_lock_flags+0x9/0x10
[ 1200.532235]  [<ffffffffa00bfc8a>]
btrfs_commit_transaction+0x38a/0xac0 [btrfs]
[ 1200.532241]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1200.532261]  [<ffffffffa00b8ecd>] transaction_kthread+0x1bd/0x240 [btrfs]
[ 1200.532279]  [<ffffffffa00b8d10>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
[ 1200.532284]  [<ffffffff8107d580>] kthread+0xc0/0xd0
[ 1200.532289]  [<ffffffff8107d4c0>] ? kthread_create_on_node+0x120/0x120
[ 1200.532294]  [<ffffffff816d592c>] ret_from_fork+0x7c/0xb0
[ 1200.532298]  [<ffffffff8107d4c0>] ? kthread_create_on_node+0x120/0x120
[ 1200.532325] INFO: task tar:3368 blocked for more than 120 seconds.
[ 1200.532327] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.532329] tar             D ffff88043fc53ec0     0  3368   3269 0x00000000
[ 1200.532333]  ffff8803fe42ddc8 0000000000000082 ffff88040d9745c0
ffff8803fe42dfd8
[ 1200.532339]  ffff8803fe42dfd8 ffff8803fe42dfd8 ffff880429542e80
ffff88040d9745c0
[ 1200.532344]  ffff880415321d00 ffff8804289241e8 ffff8804289241e8
0000000000000000
[ 1200.532350] Call Trace:
[ 1200.532356]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1200.532376]  [<ffffffffa00bf23d>]
wait_current_trans.isra.28+0x9d/0x100 [btrfs]
[ 1200.532380]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1200.532399]  [<ffffffffa00c09a8>] start_transaction+0x158/0x460 [btrfs]
[ 1200.532406]  [<ffffffff811a3040>] ? kern_path_create+0x90/0x170
[ 1200.532424]  [<ffffffffa00c0fe8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[ 1200.532444]  [<ffffffffa00cd91e>] btrfs_mkdir+0x4e/0x1d0 [btrfs]
[ 1200.532452]  [<ffffffff812cefec>] ? security_inode_permission+0x1c/0x30
[ 1200.532457]  [<ffffffff8119f3e6>] vfs_mkdir+0xa6/0x130
[ 1200.532462]  [<ffffffff811a44ba>] sys_mkdirat+0xaa/0xf0
[ 1200.532467]  [<ffffffff816d59dd>] system_call_fastpath+0x1a/0x1f
[ 1200.532471] INFO: task aptitude:3586 blocked for more than 120 seconds.
[ 1200.532474] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1200.532476] aptitude        D ffff88043fc53ec0     0  3586   3585 0x00000000
[ 1200.532480]  ffff8803f7d71b80 0000000000000082 ffff88041ba32e80
ffff8803f7d71fd8
[ 1200.532485]  ffff8803f7d71fd8 ffff8803f7d71fd8 ffff880429542e80
ffff88041ba32e80
[ 1200.532491]  ffff880415321d00 ffff8804289241e8 ffff8804289241e8
0000000000000000
[ 1200.532496] Call Trace:
[ 1200.532502]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1200.532521]  [<ffffffffa00bf23d>]
wait_current_trans.isra.28+0x9d/0x100 [btrfs]
[ 1200.532525]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1200.532542]  [<ffffffffa00c09a8>] start_transaction+0x158/0x460 [btrfs]
[ 1200.532548]  [<ffffffff81065639>] ? ns_capable+0x29/0x50
[ 1200.532565]  [<ffffffffa00c0fe8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[ 1200.532584]  [<ffffffffa00cdc96>] btrfs_create+0x46/0x220 [btrfs]
[ 1200.532590]  [<ffffffff812cefec>] ? security_inode_permission+0x1c/0x30
[ 1200.532595]  [<ffffffff8119f032>] ? __inode_permission+0x62/0xe0
[ 1200.532599]  [<ffffffff811a0975>] vfs_create+0xb5/0x120
[ 1200.532604]  [<ffffffff811a2254>] do_last+0xd74/0xea0
[ 1200.532609]  [<ffffffff811a3293>] path_openat+0xb3/0x4b0
[ 1200.532616]  [<ffffffff81159239>] ? handle_mm_fault+0x299/0x670
[ 1200.532623]  [<ffffffff8117d00f>] ? kmem_cache_free+0x2f/0x130
[ 1200.532628]  [<ffffffff811a4091>] do_filp_open+0x41/0xa0
[ 1200.532634]  [<ffffffff811b1819>] ? __alloc_fd+0xd9/0x130
[ 1200.532640]  [<ffffffff81193e73>] do_sys_open+0xf3/0x230
[ 1200.532644]  [<ffffffff81193fd1>] sys_open+0x21/0x30
[ 1200.532648]  [<ffffffff816d59dd>] system_call_fastpath+0x1a/0x1f
[ 1320.532214] INFO: task btrfs-transacti:1076 blocked for more than
120 seconds.
[ 1320.532220] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.532223] btrfs-transacti D ffff88043fc13ec0     0  1076      2 0x00000000
[ 1320.532230]  ffff88041bb73d38 0000000000000046 ffff88042576ae80
ffff88041bb73fd8
[ 1320.532236]  ffff88041bb73fd8 ffff88041bb73fd8 ffffffff81c15440
ffff88042576ae80
[ 1320.532242]  ffff8804289a4800 ffff880409819130 ffff880415321d00
0000000000000000
[ 1320.532248] Call Trace:
[ 1320.532261]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1320.532268]  [<ffffffff816ca68c>] schedule_timeout+0x1ec/0x2b0
[ 1320.532307]  [<ffffffffa00d6929>] ?
btrfs_run_ordered_operations+0x2b9/0x2f0 [btrfs]
[ 1320.532315]  [<ffffffff81044b49>] ? default_spin_lock_flags+0x9/0x10
[ 1320.532337]  [<ffffffffa00bfc8a>]
btrfs_commit_transaction+0x38a/0xac0 [btrfs]
[ 1320.532343]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1320.532363]  [<ffffffffa00b8ecd>] transaction_kthread+0x1bd/0x240 [btrfs]
[ 1320.532381]  [<ffffffffa00b8d10>] ?
write_dev_flush.part.107+0xc0/0xc0 [btrfs]
[ 1320.532385]  [<ffffffff8107d580>] kthread+0xc0/0xd0
[ 1320.532390]  [<ffffffff8107d4c0>] ? kthread_create_on_node+0x120/0x120
[ 1320.532395]  [<ffffffff816d592c>] ret_from_fork+0x7c/0xb0
[ 1320.532400]  [<ffffffff8107d4c0>] ? kthread_create_on_node+0x120/0x120
[ 1320.532425] INFO: task tar:3368 blocked for more than 120 seconds.
[ 1320.532427] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.532429] tar             D ffff88043fc53ec0     0  3368   3269 0x00000000
[ 1320.532433]  ffff8803fe42ddc8 0000000000000082 ffff88040d9745c0
ffff8803fe42dfd8
[ 1320.532439]  ffff8803fe42dfd8 ffff8803fe42dfd8 ffff880429542e80
ffff88040d9745c0
[ 1320.532444]  ffff880415321d00 ffff8804289241e8 ffff8804289241e8
0000000000000000
[ 1320.532450] Call Trace:
[ 1320.532456]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1320.532476]  [<ffffffffa00bf23d>]
wait_current_trans.isra.28+0x9d/0x100 [btrfs]
[ 1320.532480]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1320.532499]  [<ffffffffa00c09a8>] start_transaction+0x158/0x460 [btrfs]
[ 1320.532505]  [<ffffffff811a3040>] ? kern_path_create+0x90/0x170
[ 1320.532523]  [<ffffffffa00c0fe8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[ 1320.532543]  [<ffffffffa00cd91e>] btrfs_mkdir+0x4e/0x1d0 [btrfs]
[ 1320.532551]  [<ffffffff812cefec>] ? security_inode_permission+0x1c/0x30
[ 1320.532555]  [<ffffffff8119f3e6>] vfs_mkdir+0xa6/0x130
[ 1320.532560]  [<ffffffff811a44ba>] sys_mkdirat+0xaa/0xf0
[ 1320.532565]  [<ffffffff816d59dd>] system_call_fastpath+0x1a/0x1f
[ 1320.532570] INFO: task aptitude:3586 blocked for more than 120 seconds.
[ 1320.532572] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1320.532574] aptitude        D ffff88043fc53ec0     0  3586   3585 0x00000000
[ 1320.532578]  ffff8803f7d71b80 0000000000000082 ffff88041ba32e80
ffff8803f7d71fd8
[ 1320.532583]  ffff8803f7d71fd8 ffff8803f7d71fd8 ffff880429542e80
ffff88041ba32e80
[ 1320.532589]  ffff880415321d00 ffff8804289241e8 ffff8804289241e8
0000000000000000
[ 1320.532594] Call Trace:
[ 1320.532601]  [<ffffffff816cc219>] schedule+0x29/0x70
[ 1320.532619]  [<ffffffffa00bf23d>]
wait_current_trans.isra.28+0x9d/0x100 [btrfs]
[ 1320.532623]  [<ffffffff8107de90>] ? finish_wait+0x80/0x80
[ 1320.532640]  [<ffffffffa00c09a8>] start_transaction+0x158/0x460 [btrfs]
[ 1320.532646]  [<ffffffff81065639>] ? ns_capable+0x29/0x50
[ 1320.532663]  [<ffffffffa00c0fe8>] btrfs_start_transaction+0x18/0x20 [btrfs]
[ 1320.532682]  [<ffffffffa00cdc96>] btrfs_create+0x46/0x220 [btrfs]
[ 1320.532689]  [<ffffffff812cefec>] ? security_inode_permission+0x1c/0x30
[ 1320.532693]  [<ffffffff8119f032>] ? __inode_permission+0x62/0xe0
[ 1320.532698]  [<ffffffff811a0975>] vfs_create+0xb5/0x120
[ 1320.532703]  [<ffffffff811a2254>] do_last+0xd74/0xea0
[ 1320.532708]  [<ffffffff811a3293>] path_openat+0xb3/0x4b0
[ 1320.532715]  [<ffffffff81159239>] ? handle_mm_fault+0x299/0x670
[ 1320.532722]  [<ffffffff8117d00f>] ? kmem_cache_free+0x2f/0x130
[ 1320.532727]  [<ffffffff811a4091>] do_filp_open+0x41/0xa0
[ 1320.532732]  [<ffffffff811b1819>] ? __alloc_fd+0xd9/0x130
[ 1320.532737]  [<ffffffff81193e73>] do_sys_open+0xf3/0x230
[ 1320.532742]  [<ffffffff81193fd1>] sys_open+0x21/0x30
[ 1320.532746]  [<ffffffff816d59dd>] system_call_fastpath+0x1a/0x1f
----

-- 
 ()   ASCII Ribbon Campaign
 /\   Keep it simple!
