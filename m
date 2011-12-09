From: Simon Kirby <sim@hostway.ca>
Subject: warning and bug on 3.2-rc4 + for-linus from yesterday
Date: Fri, 9 Dec 2011 12:39:48 -0800
Message-ID: <20111209203948.GA12378@hostway.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

We recently upgraded our backup server kernel (rsync with snapshots and
compression) to Linus git master from yesterday (3.2-rc4+ 09d9673d53005)
that contains the btrfs for-linus as of yesterday. We've been seeing a
few warnings and bugs:

------------[ cut here ]------------
WARNING: at mm/page-writeback.c:1763 __set_page_dirty_nobuffers+0x17b/0x190()
Hardware name: PowerEdge 1950
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
Pid: 14299, comm: btrfs-delalloc- Tainted: G        W    3.2.0-rc4-hw+ #71
Call Trace:
 [<ffffffff810dec2b>] ? __set_page_dirty_nobuffers+0x17b/0x190
 [<ffffffff8105b050>] warn_slowpath_common+0x80/0xc0
 [<ffffffff8105b0a5>] warn_slowpath_null+0x15/0x20
 [<ffffffff810dec2b>] __set_page_dirty_nobuffers+0x17b/0x190
 [<ffffffff81303b95>] compress_file_range+0x535/0x5e0
 [<ffffffff811174ee>] ? kfree+0xee/0x120
 [<ffffffff81303c70>] async_cow_start+0x30/0x50
 [<ffffffff813220a3>] worker_loop+0x173/0x530
 [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
 [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
 [<ffffffff8107c7f6>] kthread+0x96/0xb0
 [<ffffffff816e09b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107c760>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff816e09b0>] ? gs_change+0x13/0x13
---[ end trace 52453f1ad38744b8 ]---

(several hours later)

------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:1587!
invalid opcode: 0000 [#1] SMP
CPU 2
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2

Pid: 4477, comm: btrfs-fixup-0 Tainted: G        W    3.2.0-rc4-hw+ #71 Dell Inc. PowerEdge 1950/0NK937
RIP: 0010:[<ffffffff812fbe10>]  [<ffffffff812fbe10>] btrfs_writepage_fixup_worker+0x160/0x170
RSP: 0018:ffff88040ff1dde0  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 00000000013d6000 RCX: 0000000000000000
RDX: 0000000000000065 RSI: 00000000013d6000 RDI: ffff8800996fe8e0
RBP: ffff88040ff1de30 R08: ffff88040ff1dd34 R09: ffff88040ff1dda0
R10: dead000000200200 R11: 0000000000000000 R12: ffffea000ea54840
R13: 00000000013d6fff R14: ffff8800996fe9b0 R15: ffff8800996fe850
FS:  0000000000000000(0000) GS:ffff88043fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000002051c80 CR3: 0000000427492000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfs-fixup-0 (pid: 4477, threadinfo ffff88040ff1c000, task ffff8804135b9630)
Stack:
 ffffffff8106b2c0 ffff880261a9bae0 0000000000000000 0000000000000286
 ffff8801b10103f0 ffff880261a9bae8 ffff880261a9bb10 ffff880412f606c0
 ffff880412f60710 ffff880412f606d8 ffff88040ff1dee0 ffffffff813220a3
Call Trace:
 [<ffffffff8106b2c0>] ? del_timer+0xd0/0xd0
 [<ffffffff813220a3>] worker_loop+0x173/0x530
 [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
 [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
 [<ffffffff8107c7f6>] kthread+0x96/0xb0
 [<ffffffff816e09b4>] kernel_thread_helper+0x4/0x10
 [<ffffffff8107c760>] ? kthread_worker_fn+0x190/0x190
 [<ffffffff816e09b0>] ? gs_change+0x13/0x13
Code: 5d 41 5e 41 5f c9 c3 0f 1f 40 00 48 8d 4d d0 41 b8 50 00 00 00 4c 89 ea 48 89 de 4c 89 ff e8 f8 c1 01 00 eb ba 66 0f 1f 44 00 00 <0f> 0b eb fe 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41
RIP  [<ffffffff812fbe10>] btrfs_writepage_fixup_worker+0x160/0x170
 RSP <ffff88040ff1dde0>
---[ end trace 52453f1ad38744b9 ]---

Simon-
