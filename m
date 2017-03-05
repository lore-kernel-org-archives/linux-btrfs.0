Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from scorn.kernelslacker.org ([45.56.101.199]:54368 "EHLO
        scorn.kernelslacker.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751909AbdCEQ7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Mar 2017 11:59:22 -0500
Date: Sun, 5 Mar 2017 11:59:17 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: assertion failed: page_ops & PAGE_LOCK
Message-ID: <20170305165917.2epbvdtulalrfxc3@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

After commenting out the assertion that Liu bo pointed out was bogus,
my trinity runs last a little longer.. This is a new one I think..

assertion failed: page_ops & PAGE_LOCK, file: fs/btrfs/extent_io.c, line: 1716
------------[ cut here ]------------
kernel BUG at fs/btrfs/ctree.h:3423!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 1 PID: 32625 Comm: trinity-c40 Not tainted 4.10.0-think+ #3 
task: ffff8804c6b95440 task.stack: ffffc90000ba8000
RIP: 0010:assfail.constprop.68+0x1c/0x1e
RSP: 0018:ffffc90000bab6c0 EFLAGS: 00010282
RAX: 000000000000004e RBX: 00000000000000a3 RCX: 0000000000000001
RDX: 0000000000000000 RSI: ffffffff81ee593a RDI: 00000000ffffffff
RBP: ffffc90000bab6c0 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000000 R12: ffffc90000bab790
R13: 0000000000000000 R14: 00000000000001f8 R15: ffffea000b2026c0
FS:  00007f102a0e4b40(0000) GS:ffff880507a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1029f21000 CR3: 00000004c6bde000 CR4: 00000000001406e0
DR0: 00007f695d948000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Call Trace:
 __process_pages_contig+0x4b4/0x4d0
 __unlock_for_delalloc.isra.43+0x32/0x50
 find_lock_delalloc_range+0x15e/0x210
 writepage_delalloc.isra.51+0x91/0x1a0
 __extent_writepage+0x10d/0x470
 extent_write_cache_pages.constprop.57+0x2d3/0x430
 extent_writepages+0x5d/0x90
 ? btrfs_releasepage+0x20/0x20
 btrfs_writepages+0x28/0x30
 do_writepages+0x21/0x30
 __filemap_fdatawrite_range+0xc6/0x100
 filemap_fdatawrite_range+0x13/0x20
 btrfs_fdatawrite_range+0x20/0x50
 start_ordered_ops+0x19/0x30
 btrfs_sync_file+0x99/0x540
 ? debug_smp_processor_id+0x17/0x20
 ? get_lock_stats+0x19/0x50
 ? debug_smp_processor_id+0x17/0x20
 ? get_lock_stats+0x19/0x50
 vfs_fsync_range+0x4b/0xb0
 btrfs_file_write_iter+0x412/0x570
 ? rcu_sync_lockdep_assert+0x2f/0x60
 __do_readv_writev+0x2ea/0x380
 do_readv_writev+0x7c/0xc0
 ? debug_smp_processor_id+0x17/0x20
 ? get_lock_stats+0x19/0x50
 ? __context_tracking_exit.part.5+0x82/0x1e0
 vfs_writev+0x3f/0x50
 do_pwritev+0xb5/0xd0
 SyS_pwritev2+0x17/0x30
 do_syscall_64+0x66/0x1d0
 entry_SYSCALL64_slow_path+0x25/0x25
RIP: 0033:0x7f1029a0e0f9
RSP: 002b:00007ffe59e72c48 EFLAGS: 00000246
[CONT START]  ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 0000000000000148 RCX: 00007f1029a0e0f9
RDX: 00000000000000f2 RSI: 0000562b5ef7de50 RDI: 0000000000000185
RBP: 00007f1029fc5000 R08: 000008002180528a R09: 0000000000000007
R10: 000000000000baba R11: 0000000000000246 R12: 0000000000000002
R13: 00007f1029fc5048 R14: 00007f102a0e4ad8 R15: 00007f1029fc5000

