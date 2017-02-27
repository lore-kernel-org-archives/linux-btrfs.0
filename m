Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:34950 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdB0ASw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 26 Feb 2017 19:18:52 -0500
Date: Sun, 26 Feb 2017 19:18:42 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: assertion failed: last_size == new_size, file: fs/btrfs/inode.c
Message-ID: <20170227001842.dhrmaw3t3k4hkuii@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hitting this fairly frequently.. I'm not sure if this is the same bug I've
been hitting occasionally since 4.9. The assertion looks new to me at least.

	Dave

assertion failed: last_size == new_size, file: fs/btrfs/inode.c, line: 4619
------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:3422!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 3 PID: 15655 Comm: trinity-c25 Not tainted 4.10.0-think+ #9 
task: ffff8804fb128040 task.stack: ffffc90008534000
RIP: 0010:assfail.constprop.74+0x1c/0x1e [btrfs]
RSP: 0018:ffffc90008537c58 EFLAGS: 00010282
RAX: 000000000000004b RBX: 0000000000001000 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff81cb4173 RDI: 00000000ffffffff
RBP: ffffc90008537c58 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8804fe821348
R13: ffff88047eb5bb88 R14: ffff8804fe821348 R15: 0000000000000005
FS:  00007f99b77a6b40(0000) GS:ffff880507e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f99b77a9010 CR3: 000000048c4bf000 CR4: 00000000001406e0
Call Trace:
 btrfs_truncate_inode_items+0xbee/0x11e0 [btrfs]
 ? debug_smp_processor_id+0x17/0x20
 btrfs_truncate+0x102/0x2a0 [btrfs]
 btrfs_setattr+0x246/0x3b0 [btrfs]
 notify_change+0x256/0x440
 do_truncate+0x73/0xc0
 do_sys_ftruncate.constprop.19+0x111/0x170
 ? __this_cpu_preempt_check+0x13/0x20
 SyS_ftruncate+0xe/0x10
 do_syscall_64+0x66/0x1d0
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f99b70d00f9
RSP: 002b:00007ffd992b7768 EFLAGS: 00000246
 ORIG_RAX: 000000000000004d
RAX: ffffffffffffffda RBX: 000000000000004d RCX: 00007f99b70d00f9
RDX: 0003680201d80849 RSI: 0000000000000d95 RDI: 0000000000000187
RBP: 00007f99b76f0000 R08: 0000000000000001 R09: 0000000000000fd7
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f99b76f0048 R14: 00007f99b77a6ad8 R15: 00007f99b76f0000
Code: 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 89 f1 48 c7 c2 b1 f7 11 a0 48 89 fe 48 89 e5 48 c7 c7 f0 52 12 a0 e8 03 b7 0b e1 <0f> 0b 55 89 f1 48 c7 c2 a8 fa 11 a0 48 89 fe 48 89 e5 48 c7 c7 
RIP: assfail.constprop.74+0x1c/0x1e [btrfs] RSP: ffffc90008537c58
