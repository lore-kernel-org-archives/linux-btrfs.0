Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:43848 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751296AbcKHO7W (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 09:59:22 -0500
Date: Tue, 8 Nov 2016 09:59:13 -0500
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: btrfs btree_ctree_super fault
Message-ID: <20161108145912.fcjvwxcpqgd7kjei@codemonkey.org.uk>
References: <CA+55aFyiJGk-A_cJH41Ec8Xj0Zz9M3EU-igJ9bgusj=nm28tFQ@mail.gmail.com>
 <2bdc068d-afd5-7a78-f334-26970c91aaca@fb.com>
 <CA+55aFxqRCEVxocpZVDMqinP=EsmgzcnvWpOT6x8NMmcBpWb2Q@mail.gmail.com>
 <203e0319-bc9b-245c-e162-709267540d22@fb.com>
 <20161026233808.GC15247@clm-mbp.thefacebook.com>
 <20161026234751.e66xyzjiwifvbuha@codemonkey.org.uk>
 <20161031185514.b22zvbxvga4xcinz@codemonkey.org.uk>
 <CA+55aFwUBYzPcbecpHw9=f8h_JuX18x5bE=Kd_k9QkCcgoiBsA@mail.gmail.com>
 <20161031194454.GA49877@clm-mbp.thefacebook.com>
 <20161106165539.ybwm6rqvzh2k6uja@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161106165539.ybwm6rqvzh2k6uja@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 06, 2016 at 11:55:39AM -0500, Dave Jones wrote:
 > <subject changed, hopefully we're done with bio corruption for now>
 > 
 > On Mon, Oct 31, 2016 at 01:44:55PM -0600, Chris Mason wrote:
 >  > On Mon, Oct 31, 2016 at 12:35:16PM -0700, Linus Torvalds wrote:
 >  > >On Mon, Oct 31, 2016 at 11:55 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
 >  > >>
 >  > >> BUG: Bad page state in process kworker/u8:12  pfn:4e0e39
 >  > >> page:ffffea0013838e40 count:0 mapcount:0 mapping:ffff8804a20310e0 index:0x100c
 >  > >> flags: 0x400000000000000c(referenced|uptodate)
 >  > >> page dumped because: non-NULL mapping
 >  > >
 >  > >Hmm. So this seems to be btrfs-specific, right?
 >  > >
 >  > >I searched for all your "non-NULL mapping" cases, and they all seem to
 >  > >have basically the same call trace, with some work thread doing
 >  > >writeback and going through btrfs_writepages().
 >  > >
 >  > >Sounds like it's a race with either fallocate hole-punching or
 >  > >truncate. I'm not seeing it, but I suspect it's btrfs, since DaveJ
 >  > >clearly ran other filesystems too but I am not seeing this backtrace
 >  > >for anything else.
 >  > 
 >  > Agreed, I think this is a separate bug, almost certainly btrfs specific.  
 >  > I'll work with Dave on a better reproducer.
 > 
 > Still refining my 'capture ftrace when trinity detects taint' feature,
 > but in the meantime, here's a variant I don't think we've seen before:

And another new one:

kernel BUG at fs/btrfs/ctree.c:3172!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 0 PID: 22702 Comm: trinity-c40 Not tainted 4.9.0-rc4-think+ #1 
task: ffff8804ffde37c0 task.stack: ffffc90002188000
RIP: 0010:[<ffffffffa00576b9>] 
  [<ffffffffa00576b9>] btrfs_set_item_key_safe+0x179/0x190 [btrfs]
RSP: 0000:ffffc9000218b8a8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8804fddcf348 RCX: 0000000000001000
RDX: 0000000000000000 RSI: ffffc9000218b9ce RDI: ffffc9000218b8c7
RBP: ffffc9000218b908 R08: 0000000000004000 R09: ffffc9000218b8c8
R10: 0000000000000000 R11: 0000000000000001 R12: ffffc9000218b8b6
R13: ffffc9000218b9ce R14: 0000000000000001 R15: ffff880480684a88
FS:  00007f7c7f998b40(0000) GS:ffff880507800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000044f15f000 CR4: 00000000001406f0
DR0: 00007f4ce439d000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 ffff880501430000 d305ffffa00a2245 006c000000000002 0500000000000010
 6c000000000002d3 0000000000001000 000000006427eebb ffff880480684a88
 0000000000000000 ffff8804fddcf348 0000000000002000 0000000000000000
Call Trace:
 [<ffffffffa009cff0>] __btrfs_drop_extents+0xb00/0xe30 [btrfs]
 [<ffffffff8116c80c>] ? function_trace_call+0x13c/0x190
 [<ffffffffa009c4f5>] ? __btrfs_drop_extents+0x5/0xe30 [btrfs]
 [<ffffffff810e2b00>] ? do_raw_write_lock+0xb0/0xc0
 [<ffffffffa00cd43d>] btrfs_log_changed_extents+0x35d/0x630 [btrfs]
 [<ffffffffa00a6a74>] ? release_extent_buffer+0xa4/0x110 [btrfs]
 [<ffffffffa00cd0e5>] ? btrfs_log_changed_extents+0x5/0x630 [btrfs]
 [<ffffffffa00d1085>] btrfs_log_inode+0xb05/0x11d0 [btrfs]
 [<ffffffff8116536c>] ? trace_function+0x6c/0x80
 [<ffffffffa00d0580>] ? log_directory_changes+0xc0/0xc0 [btrfs]
 [<ffffffffa00d1a20>] ? btrfs_log_inode_parent+0x240/0x940 [btrfs]
 [<ffffffff8116c80c>] ? function_trace_call+0x13c/0x190
 [<ffffffffa00d1a20>] btrfs_log_inode_parent+0x240/0x940 [btrfs]
 [<ffffffffa00d17e5>] ? btrfs_log_inode_parent+0x5/0x940 [btrfs]
 [<ffffffff81259131>] ? dget_parent+0x71/0x150
 [<ffffffffa00d3102>] btrfs_log_dentry_safe+0x62/0x80 [btrfs]
 [<ffffffffa009f404>] btrfs_sync_file+0x344/0x4d0 [btrfs]
 [<ffffffff81278a1b>] vfs_fsync_range+0x4b/0xb0
 [<ffffffff812607c5>] ? __fget_light+0x5/0x60
 [<ffffffff81278add>] do_fsync+0x3d/0x70
 [<ffffffff81278aa5>] ? do_fsync+0x5/0x70
 [<ffffffff81278db3>] SyS_fdatasync+0x13/0x20
 [<ffffffff81002d81>] do_syscall_64+0x61/0x170
 [<ffffffff81894ccb>] entry_SYSCALL64_slow_path+0x25/0x25
Code: 48 8b 45 b7 48 8d 7d bf 4c 89 ee 48 89 45 c8 0f b6 45 b6 88 45 c7 48 8b 45 ae 48 89 45 bf e8 af f2 ff ff 85 c0 0f 8f 43 ff ff ff <0f> 0b 0f 0b e8 ee f3 02 e1 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 



Unfortunatly, because this was a BUG_ON, it locked up the box so it
didn't save any additional debug info. Tempted to see if making BUG_ON
a no-op will at least let it live long enough to save the ftrace buffer.

Given this seems to be mutating every time I see something go wrong,
I'm wondering if this is fallout from memory corruption again.

	Dave

