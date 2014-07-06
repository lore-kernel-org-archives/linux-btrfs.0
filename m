Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:55459 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaGFKJu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jul 2014 06:09:50 -0400
Received: from xev.localnet (localhost [127.0.0.1])
	by smtp.sws.net.au (Postfix) with ESMTP id 6C29120ECC
	for <linux-btrfs@vger.kernel.org>; Sun,  6 Jul 2014 20:09:46 +1000 (EST)
From: Russell Coker <russell@coker.com.au>
To: linux-btrfs@vger.kernel.org
Reply-To: russell@coker.com.au
Subject: btrfs loopback problems
Date: Sun, 06 Jul 2014 20:09:45 +1000
Message-ID: <11089039.dk0RppNMoi@xev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

root@yoyo:/# btrfs fi df /
Data, RAID1: total=9.00GiB, used=6.95GiB
System, RAID1: total=32.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=82.95MiB
root@yoyo:/# df -h /
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda2       273G   15G  257G   6% /

I have a Xen server that has a RAID-1 array of 2*140G SAS disks, above is the 
df output.

The Xen server is for training and testing (including training people to use 
BTRFS), hence the name.  I have a subvol /xenstore which has image files for 
BTRFS RAID-1 filesystems (RAID-1 within RAID-1 is going to suck for 
performance but be good for training, and apparently testing).

root@yoyo:/# mount -o loop,degraded /xenstore/btrfsa /mnt/tmp

I mounted one of them loopback with the above command and then tried doing an 
"apt-get update" in a chroot.  The result was that apt-get entered D state and 
the following was in the kernel message log.  The system is running Debian 
kernel 3.14.9.

[ 2280.784105] INFO: task btrfs-flush_del:1339 blocked for more than 120 
seconds.
[ 2280.784126]       Not tainted 3.14-1-amd64 #1
[ 2280.784136] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2280.784152] btrfs-flush_del D ffff8800547f0cf8     0  1339      2 
0x00000000
[ 2280.784173]  ffff8800547f08e0 0000000000000246 0000000000014380 
ffff8800547f5fd8
[ 2280.784232]  0000000000014380 ffff8800547f08e0 ffff880077454c10 
ffff88007777c028
[ 2280.784290]  0000000000000002 ffffffff8111f240 ffff8800547f5ce0 
ffff8800547f5dc8
[ 2280.784347] Call Trace:
[ 2280.784376]  [<ffffffff8111f240>] ? wait_on_page_read+0x60/0x60
[ 2280.784410]  [<ffffffff814bcd54>] ? io_schedule+0x94/0x130
[ 2280.784440]  [<ffffffff8111f245>] ? sleep_on_page+0x5/0x10
[ 2280.784470]  [<ffffffff814bd0c4>] ? __wait_on_bit+0x54/0x80
[ 2280.784501]  [<ffffffff8111f04f>] ? wait_on_page_bit+0x7f/0x90
[ 2280.784534]  [<ffffffff8109e300>] ? autoremove_wake_function+0x30/0x30
[ 2280.784566]  [<ffffffff8112c008>] ? pagevec_lookup_tag+0x18/0x20
[ 2280.784597]  [<ffffffff8111f130>] ? filemap_fdatawait_range+0xd0/0x160
[ 2280.784654]  [<ffffffffa0230da5>] ? btrfs_wait_ordered_range+0x65/0x120 
[btrfs]
[ 2280.784709]  [<ffffffffa021d7a1>] ? btrfs_run_delalloc_work+0x21/0x80 
[btrfs]
[ 2280.784750]  [<ffffffffa02449b0>] ? worker_loop+0x140/0x520 [btrfs]
[ 2280.784782]  [<ffffffff814bc5e9>] ? __schedule+0x2a9/0x700
[ 2280.784820]  [<ffffffffa0244870>] ? btrfs_queue_worker+0x300/0x300 [btrfs]
[ 2280.784854]  [<ffffffff8107f858>] ? kthread+0xb8/0xd0
[ 2280.784884]  [<ffffffff8107f7a0>] ? kthread_create_on_node+0x180/0x180
[ 2280.784917]  [<ffffffff814c7acc>] ? ret_from_fork+0x7c/0xb0
[ 2280.784948]  [<ffffffff8107f7a0>] ? kthread_create_on_node+0x180/0x180
[ 2280.784980] INFO: task btrfs-transacti:1343 blocked for more than 120 
seconds.
[ 2280.785028]       Not tainted 3.14-1-amd64 #1
[ 2280.785055] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2280.785105] btrfs-transacti D ffff8800547c4968     0  1343      2 
0x00000000
[ 2280.785142]  ffff8800547c4550 0000000000000246 0000000000014380 
ffff880054055fd8
[ 2280.785200]  0000000000014380 ffff8800547c4550 ffff88004f063f70 
ffff880054055d78
[ 2280.785257]  ffff88004f063f68 ffff8800547c4550 ffff880056047de0 
ffff880054055df0
[ 2280.785314] Call Trace:
[ 2280.785340]  [<ffffffff814bbe49>] ? schedule_timeout+0x209/0x2a0
[ 2280.785372]  [<ffffffff81095b6f>] ? enqueue_task_fair+0x2bf/0xdf0
[ 2280.785403]  [<ffffffff81091337>] ? sched_clock_cpu+0x47/0xb0
[ 2280.785434]  [<ffffffff8131dc6b>] ? notify_remote_via_irq+0x2b/0x50
[ 2280.785466]  [<ffffffff8108bee5>] ? check_preempt_curr+0x65/0x90
[ 2280.785497]  [<ffffffff8108bf1f>] ? ttwu_do_wakeup+0xf/0xc0
[ 2280.785528]  [<ffffffff814bd3f0>] ? wait_for_completion+0xa0/0x110
[ 2280.785560]  [<ffffffff8108e7a0>] ? wake_up_state+0x10/0x10
[ 2280.785599]  [<ffffffffa02273dd>] ? 
btrfs_wait_and_free_delalloc_work+0xd/0x20 [btrfs]
[ 2280.785656]  [<ffffffffa02304f6>] ? 
btrfs_run_ordered_operations+0x1e6/0x2b0 [btrfs]
[ 2280.785712]  [<ffffffffa02182b7>] ? btrfs_commit_transaction+0x217/0x990 
[btrfs]
[ 2280.785768]  [<ffffffffa0218abb>] ? start_transaction+0x8b/0x550 [btrfs]
[ 2280.785807]  [<ffffffffa021432d>] ? transaction_kthread+0x1ad/0x240 [btrfs]
[ 2280.785846]  [<ffffffffa0214180>] ? btrfs_cleanup_transaction+0x510/0x510 
[btrfs]
[ 2280.785894]  [<ffffffff8107f858>] ? kthread+0xb8/0xd0
[ 2280.785924]  [<ffffffff8107f7a0>] ? kthread_create_on_node+0x180/0x180
[ 2280.785956]  [<ffffffff814c7acc>] ? ret_from_fork+0x7c/0xb0
[ 2280.785985]  [<ffffffff8107f7a0>] ? kthread_create_on_node+0x180/0x180
[ 2280.786017] INFO: task apt-get:1358 blocked for more than 120 seconds.
[ 2280.786047]       Not tainted 3.14-1-amd64 #1
[ 2280.786074] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables 
this message.
[ 2280.786122] apt-get         D ffff88005bce2d78     0  1358   1357 
0x00000000
[ 2280.786159]  ffff88005bce2960 0000000000000286 0000000000014380 
ffff88005a681fd8
[ 2280.786218]  0000000000014380 ffff88005bce2960 ffff880077494c10 
ffff880077778248
[ 2280.786277]  0000000000000002 ffffffff8111f240 ffff88005a681da0 
ffff88005a681e48
[ 2280.786334] Call Trace:
[ 2280.786360]  [<ffffffff8111f240>] ? wait_on_page_read+0x60/0x60
[ 2280.786392]  [<ffffffff814bcd54>] ? io_schedule+0x94/0x130
[ 2280.786422]  [<ffffffff8111f245>] ? sleep_on_page+0x5/0x10
[ 2280.786453]  [<ffffffff814bd0c4>] ? __wait_on_bit+0x54/0x80
[ 2280.786484]  [<ffffffff8111f04f>] ? wait_on_page_bit+0x7f/0x90
[ 2280.786515]  [<ffffffff8109e300>] ? autoremove_wake_function+0x30/0x30
[ 2280.786548]  [<ffffffff8112c008>] ? pagevec_lookup_tag+0x18/0x20
[ 2280.786579]  [<ffffffff8111f130>] ? filemap_fdatawait_range+0xd0/0x160
[ 2280.786620]  [<ffffffffa0236d62>] ? extent_writepages+0x52/0x60 [btrfs]
[ 2280.786660]  [<ffffffffa021c850>] ? btrfs_submit_direct+0x6b0/0x6b0 [btrfs]
[ 2280.786700]  [<ffffffffa0230da5>] ? btrfs_wait_ordered_range+0x65/0x120 
[btrfs]
[ 2280.786756]  [<ffffffffa0227e3e>] ? btrfs_sync_file+0x23e/0x2c0 [btrfs]
[ 2280.786789]  [<ffffffff81152af7>] ? SyS_msync+0x147/0x210
[ 2280.786819]  [<ffffffff814c7b79>] ? system_call_fastpath+0x16/0x1b


-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

