Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:46034 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325AbcDTWJT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Apr 2016 18:09:19 -0400
Date: Wed, 20 Apr 2016 18:09:11 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: BTRFS: assertion failed: num_extents, file: fs/btrfs/extent-tree.c,
 line: 5584
Message-ID: <20160420220911.GA10235@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't think I've reported this one before. It's on the same box I've been
seeing the btrfs_destroy_inode WARN_ON's on though.

	Dave

BTRFS: assertion failed: num_extents, file: fs/btrfs/extent-tree.c, line: 5584
------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:4320!
invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN
CPU: 1 PID: 9320 Comm: trinity-c21 Not tainted 4.6.0-rc4-think+ #5
task: ffff880453bdb7c0 ti: ffff880458930000 task.ti: ffff880458930000
RIP: 0010:[<ffffffffc0429078>]  [<ffffffffc0429078>] assfail.constprop.88+0x1c/0x1e [btrfs]
RSP: 0000:ffff880458937860  EFLAGS: 00010282
RAX: 000000000000004e RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffffed008b126f02
RBP: ffff880458937860 R08: 0000000000000001 R09: 0000000000000001
R10: 0000000000000003 R11: 0000000000000001 R12: ffff88045ef14548
R13: ffff88045066e048 R14: ffff88045066dc58 R15: 000000000000008f
FS:  00007f6465c7b700(0000) GS:ffff880468800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f6465c81000 CR3: 0000000454e05000 CR4: 00000000001406e0
Stack:
 ffff8804589378a0 ffffffffc02407f3 000000000000008f 0000000000000000
 ffff88045ef14548 ffff88045066e048 ffff88045066dc58 000000000000008f
 ffff8804589378f0 ffffffffc0253a3c ffff880453bdc048 ffff880453bdb7c0
Call Trace:
 [<ffffffffc02407f3>] drop_outstanding_extent+0x153/0x1a0 [btrfs]
 [<ffffffffc0253a3c>] btrfs_delalloc_release_metadata+0x9c/0x5d0 [btrfs]
 [<ffffffffc0253f8f>] btrfs_delalloc_release_space+0x1f/0x50 [btrfs]
 [<ffffffffc02de9f5>] __btrfs_buffered_write+0xb05/0xea0 [btrfs]
 [<ffffffffc02ddef0>] ? btrfs_dirty_pages+0x2d0/0x2d0 [btrfs]
 [<ffffffff931bfdbc>] ? local_clock+0x1c/0x20
 [<ffffffff931bfdbc>] ? local_clock+0x1c/0x20
 [<ffffffff9325eb17>] ? debug_lockdep_rcu_enabled+0x77/0x90
 [<ffffffffc02e8297>] ? btrfs_file_write_iter+0xa07/0x1570 [btrfs]
 [<ffffffffc02e7ec1>] btrfs_file_write_iter+0x631/0x1570 [btrfs]
 [<ffffffff934c3826>] ? __might_fault+0x166/0x1b0
 [<ffffffff934c378b>] ? __might_fault+0xcb/0x1b0
 [<ffffffff935641c4>] do_iter_readv_writev+0x134/0x230
 [<ffffffff93564090>] ? vfs_iter_read+0x260/0x260
 [<ffffffff93268418>] ? rcu_sync_lockdep_assert+0x78/0xb0
 [<ffffffff9321841c>] ? percpu_down_read+0x5c/0xa0
 [<ffffffff9356e9a4>] ? __sb_start_write+0xb4/0xf0
 [<ffffffff93566d1c>] do_readv_writev+0x39c/0x6a0
 [<ffffffffc02e7890>] ? btrfs_sync_file+0xd00/0xd00 [btrfs]
 [<ffffffff93566980>] ? vfs_write+0x4a0/0x4a0
 [<ffffffff931bfdbc>] ? local_clock+0x1c/0x20
 [<ffffffff93437e12>] ? __context_tracking_exit.part.6+0x52/0x220
 [<ffffffff930052c0>] ? enter_from_user_mode+0x50/0x50
 [<ffffffff935675d5>] vfs_writev+0x75/0xb0
 [<ffffffff93567a5a>] do_pwritev+0x12a/0x170
 [<ffffffff9356aea0>] ? SyS_pwritev+0x20/0x20
 [<ffffffff9356aeb7>] SyS_pwritev2+0x17/0x30
 [<ffffffff9300627b>] do_syscall_64+0x19b/0x4a0
 [<ffffffff9300301b>] ? trace_hardirqs_on_thunk+0x1b/0x1d
 [<ffffffff9496039a>] entry_SYSCALL64_slow_path+0x25/0x25
Code: d3 0f 0b 55 48 89 e5 0f 0b 55 48 89 e5 0f 0b 55 89 f1 48 c7 c2 e0 c0 43 c0 48 89 fe 48 89 e5 48 c7 c7 20 c4 43 c0 e8 92 06 01 d3 <0f> 0b 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 18 48 89 

