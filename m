Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:38010 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750720AbcKFQzw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Nov 2016 11:55:52 -0500
Date: Sun, 6 Nov 2016 11:55:39 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs btree_ctree_super fault
Message-ID: <20161106165539.ybwm6rqvzh2k6uja@codemonkey.org.uk>
References: <CA+55aFyyP6VHOv6KbhVdMMtNfJLftbju_Ui2GNxXt0GgkKm0Jg@mail.gmail.com>
 <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161031194454.GA49877@clm-mbp.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

<subject changed, hopefully we're done with bio corruption for now>

On Mon, Oct 31, 2016 at 01:44:55PM -0600, Chris Mason wrote:
 > On Mon, Oct 31, 2016 at 12:35:16PM -0700, Linus Torvalds wrote:
 > >On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > >>
 > >> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
 > >> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
 > >> flags: 0x400000000000000c(referenced|uptodate)
 > >> page dumped because: non-NULL mapping
 > >
 > >Hmm. So this seems to be btrfs-specific, right?
 > >
 > >I searched for all your "non-NULL mapping" cases, and they all seem to
 > >have basically the same call trace, with some work thread doing
 > >writeback and going through btrfs_writepages().
 > >
 > >Sounds like it's a race with either fallocate hole-punching or
 > >truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
 > >clearly ran other filesystems too but I am not seeing this backtrace
 > >for anything else.
 > 
 > Agreed, I think this is a separate bug, almost certainly btrfs specific.  
 > I'll work with Dave on a better reproducer.

Still refining my 'capture ftrace when trinity detects taint' feature,
but in the meantime, here's a variant I don't think we've seen before:

general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 3 PID: 1913 Comm: trinity-c51 Not tainted 4.9.0-rc3-think+ #3 
task: ffff880503350040 task.stack: ffffc90000240000
RIP: 0010:[<ffffffffa007c2f6>] 
  [<ffffffffa007c2f6>] write_ctree_super+0x96/0xb30 [btrfs]
RSP: 0018:ffffc90000243c90  EFLAGS: 00010286
RAX: dae05adadadad000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffff8804fdfcc000 RSI: ffff8804edcee313 RDI: ffff8804edcee1c3
RBP: ffffc90000243d00 R08: 0000000000000003 R09: ffff880000000000
R10: 0000000000000001 R11: 0000000000000100 R12: ffff88045151c548
R13: 0000000000000000 R14: ffff8804ee5122a8 R15: ffff8804572267e8
FS:  00007f25c3e0eb40(0000) GS:ffff880507e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f25c1560d44 CR3: 0000000454e20000 CR4: 00000000001406e0
DR0: 00007fee93506000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 0000000000000001
 ffff88050227b3f8
 ffff8804fff01b28
 00000001810b7f35
 ffffffffa007c265
 0000000000000001
 ffffc90000243cb8
 000000002c9a8645
 ffff8804fff01b28
 ffff8804fff01b28
 ffff88045151c548
 0000000000000000
Call Trace:
 [<ffffffffa007c265>] ? write_ctree_super+0x5/0xb30 [btrfs]
 [<ffffffffa00d2956>] btrfs_sync_log+0x886/0xa60 [btrfs]
 [<ffffffffa009f4f9>] btrfs_sync_file+0x479/0x4d0 [btrfs]
 [<ffffffff812789ab>] vfs_fsync_range+0x4b/0xb0
 [<ffffffff81260755>] ? __fget_light+0x5/0x60
 [<ffffffff81278a6d>] do_fsync+0x3d/0x70
 [<ffffffff81278a35>] ? do_fsync+0x5/0x70
 [<ffffffff81278d20>] SyS_fsync+0x10/0x20
 [<ffffffff81002d81>] do_syscall_64+0x61/0x170
 [<ffffffff81894a8b>] entry_SYSCALL64_slow_path+0x25/0x25
Code: c7 48 8b 42 30 4c 8b 08 48 b8 00 00 00 00 00 16 00 00 49 03 81 a0 01 00 00 49 b9 00 00 00 00 00 88 ff ff 48 c1 f8 06 48 c1 e0 0c <4a> 8b 44 08 50 48 39 46 08 0f 84 8d 08 00 00 49 63 c0 48 8d 0c 
RIP 
  [<ffffffffa007c2f6>] write_ctree_super+0x96/0xb30 [btrfs]
 RSP <ffffc90000243c90>

All code
========
   0:	c7                   	(bad)  
   1:	48 8b 42 30          	mov    0x30(%rdx),%rax
   5:	4c 8b 08             	mov    (%rax),%r9
   8:	48 b8 00 00 00 00 00 	movabs $0x160000000000,%rax
   f:	16 00 00 
  12:	49 03 81 a0 01 00 00 	add    0x1a0(%r9),%rax
  19:	49 b9 00 00 00 00 00 	movabs $0xffff880000000000,%r9
  20:	88 ff ff 
  23:	48 c1 f8 06          	sar    $0x6,%rax
  27:	48 c1 e0 0c          	shl    $0xc,%rax
  2b:*	4a 8b 44 08 50       	mov    0x50(%rax,%r9,1),%rax		<-- trapping instruction
  30:	48 39 46 08          	cmp    %rax,0x8(%rsi)
  34:	0f 84 8d 08 00 00    	je     0x8c7
  3a:	49 63 c0             	movslq %r8d,%rax
  3d:	48                   	rex.W
  3e:	8d                   	.byte 0x8d
  3f:	0c                   	.byte 0xc

Code starting with the faulting instruction
===========================================
   0:	4a 8b 44 08 50       	mov    0x50(%rax,%r9,1),%rax
   5:	48 39 46 08          	cmp    %rax,0x8(%rsi)
   9:	0f 84 8d 08 00 00    	je     0x89c
   f:	49 63 c0             	movslq %r8d,%rax
  12:	48                   	rex.W
  13:	8d                   	.byte 0x8d
  14:	0c                   	.byte 0xc


According to objdump -S, it looks like this is an inlined copy of backup_super_roots

        root_backup = info->super_for_commit->super_roots + last_backup;
    2706:       48 8d b8 2b 0b 00 00    lea    0xb2b(%rax),%rdi
    270d:       48 63 c1                movslq %ecx,%rax
    2710:       48 8d 34 80             lea    (%rax,%rax,4),%rsi
    2714:       48 8d 04 b0             lea    (%rax,%rsi,4),%rax
    2718:       48 8d 34 c7             lea    (%rdi,%rax,8),%rsi
            btrfs_header_generation(info->tree_root->node))
    271c:       48 8b 42 30             mov    0x30(%rdx),%rax
    2720:       4c 8b 08                mov    (%rax),%r9
    2723:       48 b8 00 00 00 00 00    movabs $0x160000000000,%rax
    272a:       16 00 00 
    272d:       49 03 81 a0 01 00 00    add    0x1a0(%r9),%rax
        if (btrfs_backup_tree_root_gen(root_backup) ==
    2734:       49 b9 00 00 00 00 00    movabs $0xffff880000000000,%r9
    273b:       88 ff ff 
    273e:       48 c1 f8 06             sar    $0x6,%rax
    2742:       48 c1 e0 0c             shl    $0xc,%rax
    2746:       4a 8b 44 08 50          mov    0x50(%rax,%r9,1),%rax      <-- trapping instruction
    274b:       48 39 46 08             cmp    %rax,0x8(%rsi)
    274f:       0f 84 8d 08 00 00       je     2fe2 <write_ctree_super+0x932>

