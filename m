Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:35689 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491AbbDVVrS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 17:47:18 -0400
Received: by igbyr2 with SMTP id yr2so8993983igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Apr 2015 14:47:17 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 22 Apr 2015 17:47:17 -0400
Message-ID: <CAKRyD=u8jbP7-QMuNPEF9v89hECKt0GGBpTY0TYLf-CA1v2M2w@mail.gmail.com>
Subject: Help with btrfs filesystem problems
From: Diego Remolina <dijuremo@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

In 2012, I setup a Centos 6.x machine with a btrfs file system on top
of DRBD, we did some testing prior to going production and it seemed
fine, and has worked fine for a long time. However, now we are
encountering problems and was wondering if I could get any help.

[root@ysmha01 tmp]# btrfs fi show
Label: none  uuid: 7a38f3ab-f3b0-4b3d-81c0-28b347b26da1
        Total devices 1 FS bytes used 5.79TB
        devid    1 size 18.19TB used 8.94TB path /dev/drbd0

Btrfs Btrfs v0.20-rc1

While still running the official Centos
kernel-2.6.32-504.12.2.el6.x86_64 the machine started crashing with a
kernel oops. Since that happened, I tried a few different 2.6.32
kernels with the same result. Yesterday I switched to the elrepo
kernel-lt 3.10.75-1.el6.elrepo.x86_64 version and was able to get the
machine up and running and found some error messages which lead me to
believe things were not too bad after all:

Apr 21 17:28:01 ysmha01 kernel: BTRFS warning (device drbd0): block
group 578776203264 has wrong amount of free space
Apr 21 17:28:01 ysmha01 kernel: BTRFS warning (device drbd0): failed
to load free space cache for block group 578776203264, rebuild it now
Apr 21 17:28:02 ysmha01 kernel: BTRFS warning (device drbd0): block
group 622799618048 has wrong amount of free space
Apr 21 17:28:02 ysmha01 kernel: BTRFS warning (device drbd0): failed
to load free space cache for block group 622799618048, rebuild it now
Apr 21 17:30:32 ysmha01 kernel: perf samples too long (2573 > 2500),
lowering kernel.perf_event_max_sample_rate to 50000
Apr 21 17:54:56 ysmha01 kernel: BTRFS warning (device drbd0): block
group 7255336419328 has wrong amount of free space
Apr 21 17:54:56 ysmha01 kernel: BTRFS warning (device drbd0): failed
to load free space cache for block group 7255336419328, rebuild it now
Apr 21 17:54:56 ysmha01 kernel: BTRFS warning (device drbd0): block
group 7256410161152 has wrong amount of free space

Since then, the machine was left up and serving samba shares until it
had another kernel oops this morning.

Apr 22 11:18:38 ysmha01 kernel: gb3i libcxgbi cxgb3 mdio libiscsi_tcp
qla4xxx iscsi_boot_sysfs libiscsi scsi_transport_iscsi
Apr 22 11:18:38 ysmha01 kernel: CPU: 8 PID: 17465 Comm:
btrfs-endio-wri Not tainted 3.10.75-1.el6.elrepo.x86_64 #1
Apr 22 11:18:38 ysmha01 kernel: Hardware name: Supermicro
X9DR3-F/X9DR3-F, BIOS 1.0c 06/29/2012
Apr 22 11:18:38 ysmha01 kernel: task: ffff880467986e20 ti:
ffff8807d8036000 task.ti: ffff8807d8036000
Apr 22 11:18:38 ysmha01 kernel: RIP: 0010:[<ffffffffa05c3de2>]
[<ffffffffa05c3de2>] __btrfs_drop_extents+0xb52/0xb90 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: RSP: 0018:ffff8807d8037b38  EFLAGS: 00010297
Apr 22 11:18:38 ysmha01 kernel: RAX: 0000000000000007 RBX:
ffff88070a0b36d0 RCX: 000000003f9e1000
Apr 22 11:18:38 ysmha01 kernel: RDX: ffff8803d2bb2001 RSI:
0000000000000e50 RDI: 00000000ffffffff
Apr 22 11:18:38 ysmha01 kernel: RBP: ffff8807d8037c58 R08:
0000000000000000 R09: ffff8807d8037ae0
Apr 22 11:18:38 ysmha01 kernel: R10: 0000000000000000 R11:
0000000000000000 R12: ffff88006304ae20
Apr 22 11:18:38 ysmha01 kernel: R13: 000000003f9e2000 R14:
000000003f9e1000 R15: 0000000000000001
Apr 22 11:18:38 ysmha01 kernel: FS:  0000000000000000(0000)
GS:ffff88087fc40000(0000) knlGS:0000000000000000
Apr 22 11:18:38 ysmha01 kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Apr 22 11:18:38 ysmha01 kernel: CR2: 0000000000000030 CR3:
0000000001c0c000 CR4: 00000000000427e0
Apr 22 11:18:38 ysmha01 kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 22 11:18:38 ysmha01 kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 22 11:18:38 ysmha01 kernel: Stack:
Apr 22 11:18:38 ysmha01 kernel: 0000000000648b05 000000003e800000
ffff880600000000 ffff8805e77a5000
Apr 22 11:18:38 ysmha01 kernel: 00000000012e7000 000000058113a3bb
0000000101037bd8 ffff8800391d0780
Apr 22 11:18:38 ysmha01 kernel: 000006c960852000 00000000011e1000
ffff8805c44acef0 ffffffff00000001
Apr 22 11:18:38 ysmha01 kernel: Call Trace:
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff81182405>] ?
kmem_cache_alloc+0x275/0x280
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05c4923>]
btrfs_drop_extents+0x73/0xa0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05b5b3c>]
insert_reserved_file_extent.clone.0+0x7c/0x290 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05b111b>] ?
start_transaction+0xab/0x4d0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05cfc32>] ?
test_range_bit+0x32/0x170 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05ba5a2>]
btrfs_finish_ordered_io+0x3e2/0x4a0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff8106b200>] ? usleep_range+0x20/0x50
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05ba675>]
finish_ordered_fn+0x15/0x20 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05dd85c>]
worker_loop+0x15c/0x4b0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05dd700>] ?
check_pending_worker_creates+0xe0/0xe0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffffa05dd700>] ?
check_pending_worker_creates+0xe0/0xe0 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff810821ce>] kthread+0xce/0xe0
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff81082100>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff815f9448>] ret_from_fork+0x58/0x90
Apr 22 11:18:38 ysmha01 kernel: [<ffffffff81082100>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 22 11:18:38 ysmha01 kernel: Code: 10 21 62 a0 e8 f0 00 fc ff c7 85
38 ff ff ff 01 00 00 00 e9 dc fa ff ff 0f 0b eb fe 0f 0b eb fe 0f 0b
0f 1f 80 00 00 00 00 eb f7 <0f> 0b eb fe 0f 0b 0f 1f 84 00 00 00 00 00
eb f6 0f 0b eb fe 0f
Apr 22 11:18:38 ysmha01 kernel: RIP  [<ffffffffa05c3de2>]
__btrfs_drop_extents+0xb52/0xb90 [btrfs]
Apr 22 11:18:38 ysmha01 kernel: RSP <ffff8807d8037b38>
Apr 22 11:18:38 ysmha01 kernel: ---[ end trace e7607252d1383d86 ]---

At this point, the machine was rebooted and upon mount, I also used
the clear_cache mount option, later the machine crashed again.

Apr 22 13:41:19 ysmha01 kernel: block drbd0: role( Secondary -> Primary )
Apr 22 13:42:08 ysmha01 kernel: device fsid
7a38f3ab-f3b0-4b3d-81c0-28b347b26da1 devid 1 transid 1699374
/dev/drbd0
Apr 22 13:42:08 ysmha01 kernel: btrfs: force clearing of disk cache
Apr 22 13:42:08 ysmha01 kernel: btrfs: disk space caching is enabled
Apr 22 13:42:45 ysmha01 kernel: SELinux: initialized (dev drbd0, type
btrfs), uses xattr
Apr 22 13:47:39 ysmha01 kernel: INFO: task btrfs-transacti:3175
blocked for more than 120 seconds.
Apr 22 13:47:39 ysmha01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 22 13:47:39 ysmha01 kernel: btrfs-transacti D ffffffff81810d00
0  3175      2 0x00000080
Apr 22 13:47:39 ysmha01 kernel: ffff880303301ce8 0000000000000046
ffff880303301fd8 000000000001314
Apr 22 13:47:39 ysmha01 kernel: ffff880303300010 0000000000013140
0000000000013140 0000000000013140
Apr 22 13:47:39 ysmha01 kernel: ffff880303301fd8 0000000000013140
ffff88046988a340 ffff88046bb69360
Apr 22 13:47:39 ysmha01 kernel: Call Trace:
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff815eeed9>] schedule+0x29/0x70
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff815ed085>]
schedule_timeout+0x195/0x220
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff81082c90>] ? prepare_to_wait+0x60/0x90
Apr 22 13:47:39 ysmha01 kernel: [<ffffffffa05b0457>]
btrfs_commit_transaction+0x1f7/0xa40 [btrfs]
Apr 22 13:47:39 ysmha01 kernel: [<ffffffffa05b111b>] ?
start_transaction+0xab/0x4d0 [btrfs]
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff810829e0>] ? wake_up_bit+0x40/0x40
Apr 22 13:47:39 ysmha01 kernel: [<ffffffffa05aac96>]
transaction_kthread+0x1a6/0x220 [btrfs]
Apr 22 13:47:39 ysmha01 kernel: [<ffffffffa05aaaf0>] ?
btree_readpage_end_io_hook+0x2c0/0x2c0 [btrfs]
Apr 22 13:47:39 ysmha01 kernel: [<ffffffffa05aaaf0>] ?
btree_readpage_end_io_hook+0x2c0/0x2c0 [btrfs]
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff810821ce>] kthread+0xce/0xe0
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff81082100>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff815f9448>] ret_from_fork+0x58/0x90
Apr 22 13:47:39 ysmha01 kernel: [<ffffffff81082100>] ?
kthread_freezable_should_stop+0x70/0x70
Apr 22 13:49:39 ysmha01 kernel: INFO: task btrfs-transacti:3175
blocked for more than 120 seconds.
Apr 22 13:49:39 ysmha01 kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr 22 13:49:39 ysmha01 kernel: btrfs-transacti D ffffffff81810d00
0  3175      2 0x00000080
Apr 22 13:49:39 ysmha01 kernel: ffff880303301ce8 0000000000000046
ffff880303301fd8 0000000000013140
Apr 22 13:49:39 ysmha01 kernel: ffff880303300010 0000000000013140
0000000000013140 0000000000013140
Apr 22 13:49:39 ysmha01 kernel: ffff880303301fd8 0000000000013140
ffff88046988a340 ffff88046bb69360
........snip......

When the oops happens, then the mount point becomes unusable. What
would be the best path to recovery from here?

What other information may I provide?

Diego
