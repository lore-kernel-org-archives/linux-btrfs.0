From: David Sterba <dave@jikos.cz>
Subject: BUG at fs/btrfs/inode.c:1795
Date: Mon, 7 Nov 2011 13:50:01 +0100
Message-ID: <20111107125001.GO12759@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I saw this BUG in current linus' (with last pull included) to quickly
trigger in xfstests/013, with freshly created fs and default raid flags.

[  528.458613] ------------[ cut here ]------------
[  528.461489] kernel BUG at fs/btrfs/inode.c:1795!
[  528.461489] invalid opcode: 0000 [#1] SMP
[  528.461489] CPU 1
[  528.461489] Modules linked in: loop btrfs aoe
[  528.461489]
[  528.461489] Pid: 8862, comm: btrfs-endio-wri Not tainted 3.1.0-default+ #67 Intel Corporation Santa Rosa platform/Matanzas
[  528.461489] RIP: 0010:[<ffffffffa0040f97>]  [<ffffffffa0040f97>] btrfs_finish_ordered_io+0x287/0x320 [btrfs]
[  528.461489] RSP: 0018:ffff880079809c80  EFLAGS: 00010286
[  528.461489] RAX: 00000000ffffffe4 RBX: ffff88007a15d000 RCX: 0000000000000000
[  528.461489] RDX: ffff880079540440 RSI: 0000000000000001 RDI: 0000000000000246
[  528.461489] RBP: ffff880079809cf0 R08: 0000000000000001 R09: 0000000000000001
[  528.461489] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88006db1c3f0
[  528.461489] R13: ffff88007620ecd8 R14: 0000000000000000 R15: ffff88006db1c000
[  528.461489] FS:  0000000000000000(0000) GS:ffff88007de00000(0000) knlGS:0000000000000000
[  528.461489] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  528.461489] CR2: 00007f5724ca4000 CR3: 000000007a127000 CR4: 00000000000006e0
[  528.461489] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  528.461489] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  528.461489] Process btrfs-endio-wri (pid: 8862, threadinfo ffff880079808000, task ffff880079540440)
[  528.461489] Stack:
[  528.461489]  0000000000000286 ffff88006db1c610 ffff880079809ca0 ffffffff810a07dd
[  528.461489]  ffff880079809cc0 ffff88006db1c0b8 0000000000000000 ffff880078b4f9c0
[  528.461489]  ffff880079809d10 ffff88007941cff0 ffff88007d491ef0 0000000000101fff
[  528.461489] Call Trace:
[  528.461489]  [<ffffffff810a07dd>] ? trace_hardirqs_on+0xd/0x10
[  528.461489]  [<ffffffffa004107c>] btrfs_writepage_end_io_hook+0x4c/0xa0 [btrfs]
[  528.461489]  [<ffffffffa0056be8>] end_bio_extent_writepage+0x138/0x190 [btrfs]
[  528.461489]  [<ffffffff811856ad>] bio_endio+0x1d/0x40
[  528.461489]  [<ffffffffa0032bc4>] end_workqueue_fn+0xf4/0x130 [btrfs]
[  528.461489]  [<ffffffffa0065874>] worker_loop+0xb4/0x520 [btrfs]
[  528.461489]  [<ffffffffa00657c0>] ? btrfs_queue_worker+0x330/0x330 [btrfs]
[  528.461489]  [<ffffffff81085d56>] kthread+0xa6/0xb0
[  528.461489]  [<ffffffff818d8784>] kernel_thread_helper+0x4/0x10
[  528.461489]  [<ffffffff818cef74>] ? retint_restore_args+0x13/0x13
[  528.461489]  [<ffffffff81085cb0>] ? __init_kthread_worker+0x70/0x70
[  528.461489]  [<ffffffff818d8780>] ? gs_change+0x13/0x13
[  528.461489] Code: 00 85 c0 74 10 48 8b 45 c8 48 8b 40 28 a8 10 0f 85 8f fe ff ff 4c 89 e2 48 89 de 4c 89 ef e8 71 f7 ff ff 85 c0 0f 84 79 fe ff ff <0f> 0b 0f 1f 80 00 00 00 00 48 89 df e8 18 a3 ff ff 49 89 c5 e9
[  528.461489] RIP  [<ffffffffa0040f97>] btrfs_finish_ordered_io+0x287/0x320 [btrfs]
[  528.461489]  RSP <ffff880079809c80>
[  528.775180] ---[ end trace 0b60ffea4d2cd332 ]---


1789         add_pending_csums(trans, inode, ordered_extent->file_offset,
1790                           &ordered_extent->list);
1791
1792         ret = btrfs_ordered_update_i_size(inode, 0, ordered_extent);
1793         if (!ret || !test_bit(BTRFS_ORDERED_PREALLOC, &ordered_extent->flags)) {
1794                 ret = btrfs_update_inode(trans, root, inode);
1795                 BUG_ON(ret);
1796         }


ret is -28 ENOSPC .

mount flags: compress=lzo,discard,space_cache,autodefrag,inode_cache


david
