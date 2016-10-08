Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:49204 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbcJHSIN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Oct 2016 14:08:13 -0400
Date: Sat, 8 Oct 2016 14:08:06 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: btrfs_direct_IO oops
Message-ID: <20161008180806.fmpwtw4vcc7lzd36@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Found this in logs this morning. First time I've seen this one.
Might be related to some direct IO related changes I made in Trinity
that is tickling some new path.

Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 2 PID: 25313 Comm: trinity-c18 Not tainted 4.8.0-think+ #7 
task: ffff88040f7b1c00 task.stack: ffffc9000076c000
 RIP: 0010:[<ffffffffc0289d5c>] 
  [<ffffffffc0289d5c>] btrfs_direct_IO+0x13c/0x480 [btrfs]
RSP: 0018:ffffc9000076fb40  EFLAGS: 00010202
RAX: 0000000000002580 RBX: 0000000000000258 RCX: 0000000000000018
RDX: 0000000000000000 RSI: ffff8804f4d16868 RDI: ffffc9000076fc40
RBP: ffffc9000076fbd8 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000006 R12: ffff880300000000
R13: ffff8803643e1a88 R14: 0000000000000001 R15: 0000000000000258
FS:  00007efc0af88b40(0000) GS:ffff880507c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8803643e4008 CR3: 00000003ad69e000 CR4: 00000000001406e0
DR0: 0000006f00200000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
  ffff88050174dda0 ffffc9000076fb60 ffff8804ffaab3f8 ffffc9000076fcd8
  0000000000000000 0000000000000001 00000001c93b8050 ffff8804f4d16868
  ffffc9000076fc40 0000000000000000 0000000000000000 0000000000000000
 
Call Trace:
 [<ffffffff89195d9d>] generic_file_read_iter+0x33d/0xce0
 [<ffffffff8920be97>] ? ___slab_alloc.constprop.86+0x277/0x5c0
 [<ffffffff89275edd>] generic_file_splice_read+0xfd/0x230
 [<ffffffff89275de0>] ? pipe_to_user+0x40/0x40
 [<ffffffff892758f8>] do_splice_to+0x98/0xd0
 [<ffffffff89275a04>] splice_direct_to_actor+0xd4/0x2c0
 [<ffffffff89275050>] ? generic_pipe_buf_nosteal+0x10/0x10
 [<ffffffff89275cb5>] do_splice_direct+0xc5/0x110
 [<ffffffff89237c52>] do_sendfile+0x242/0x470
 [<ffffffff89238d2d>] SyS_sendfile64+0x7d/0xf0
 [<ffffffff8900279f>] do_syscall_64+0x7f/0x200
 [<ffffffff899ddbcb>] entry_SYSCALL64_slow_path+0x25/0x25
 Code:  4d 8b 74 1d 00 4d 3b 74 1d 10 74 26 44 89 fb e8 3b de eb c8 83 c3 01 4c 63 fb 4d 39 e7 73 a5 e8 2b de eb c8 4c 89 f8 48 c1 e0 04 <4d> 3b 74 05 00 75 dd 31 db e8 16 de eb c8 48 89 d8 48 8b 7d d0 
 
 RIP 
  [<ffffffffc0289d5c>] btrfs_direct_IO+0x13c/0x480 [btrfs]
 RSP <ffffc9000076fb40>
CR2: ffff8803643e4008


That code: matches this dissembly:

                for (i = seg + 1; i < iter->nr_segs; i++) {
   41d40:       e8 00 00 00 00          callq  41d45 <btrfs_direct_IO+0x125>
   41d45:       83 c3 01                add    $0x1,%ebx
   41d48:       4c 63 fb                movslq %ebx,%r15
   41d4b:       4d 39 e7                cmp    %r12,%r15
   41d4e:       73 a5                   jae    41cf5 <btrfs_direct_IO+0xd5>
                        if (iter->iov[seg].iov_base == iter->iov[i].iov_base)
   41d50:       e8 00 00 00 00          callq  41d55 <btrfs_direct_IO+0x135>
   41d55:       4c 89 f8                mov    %r15,%rax
   41d58:       48 c1 e0 04             shl    $0x4,%rax
   41d5c:       4d 3b 74 05 00          cmp    0x0(%r13,%rax,1),%r14
   41d61:       75 dd                   jne    41d40 <btrfs_direct_IO+0x120>
                return 0;

 


