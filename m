From: Simon Kirby <sim@hostway.ca>
Subject: Re: warning and bug on 3.2-rc4 + for-linus from yesterday
Date: Mon, 12 Dec 2011 16:18:45 -0800
Message-ID: <20111213001845.GF11597@hostway.ca>
References: <20111209203948.GA12378@hostway.ca> <20111212003031.GA7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111212003031.GA7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

On Mon, Dec 12, 2011 at 01:30:31AM +0100, David Sterba wrote:

> On Fri, Dec 09, 2011 at 12:39:48PM -0800, Simon Kirby wrote:
> > ------------[ cut here ]------------
> > WARNING: at mm/page-writeback.c:1763 __set_page_dirty_nobuffers+0x17b/0x190()
> > Hardware name: PowerEdge 1950
> > Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
> > Pid: 14299, comm: btrfs-delalloc- Tainted: G        W    3.2.0-rc4-hw+ #71
> > Call Trace:
> >  [<ffffffff810dec2b>] ? __set_page_dirty_nobuffers+0x17b/0x190
> >  [<ffffffff8105b050>] warn_slowpath_common+0x80/0xc0
> >  [<ffffffff8105b0a5>] warn_slowpath_null+0x15/0x20
> >  [<ffffffff810dec2b>] __set_page_dirty_nobuffers+0x17b/0x190
> >  [<ffffffff81303b95>] compress_file_range+0x535/0x5e0
> >  [<ffffffff811174ee>] ? kfree+0xee/0x120
> >  [<ffffffff81303c70>] async_cow_start+0x30/0x50
> >  [<ffffffff813220a3>] worker_loop+0x173/0x530
> >  [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
> >  [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
> >  [<ffffffff8107c7f6>] kthread+0x96/0xb0
> >  [<ffffffff816e09b4>] kernel_thread_helper+0x4/0x10
> >  [<ffffffff8107c760>] ? kthread_worker_fn+0x190/0x190
> >  [<ffffffff816e09b0>] ? gs_change+0x13/0x13
> > ---[ end trace 52453f1ad38744b8 ]---
> > 
> > (several hours later)
> 
> 1761                 if (mapping2) { /* Race with truncate? */
> 1762                         BUG_ON(mapping2 != mapping);
> 1763                         WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
> ^^^^
> 1764                         account_page_dirtied(page, mapping);
> 1765                         radix_tree_tag_set(&mapping->page_tree,
> 1766                                 page_index(page), PAGECACHE_TAG_DIRTY);
> 1767                 }
> 
> The warning pops up just the first time, so I think it may happen more
> often, would be interesting to verify this.

We'll try again with s/WARN_ON_ONCE/WARN_ON/ here.

Meanwhile, other problems have come up on this kernel, like a BUG() on
snapshot delete:

------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:2893!
invalid opcode: 0000 [#1] SMP
CPU 1
Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2

Pid: 20842, comm: btrfsctl Tainted: G        W    3.2.0-rc4-hw+ #71 Dell Inc. PowerEdge 1950/0NK937
RIP: 0010:[<ffffffff81304d88>]  [<ffffffff81304d88>] btrfs_unlink_subvol+0x268/0x270
RSP: 0018:ffff88008eca7d28  EFLAGS: 00010286
RAX: 00000000ffffffe4 RBX: 0000000000000c46 RCX: ffff8800922a2928
RDX: 00000000ffffffe4 RSI: 0000000000000000 RDI: ffff8800922a2948
RBP: ffff88008eca7da8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 9000000000000001 R12: ffff880075b20548
R13: ffff88042876aab0 R14: ffff88026d2f3400 R15: 0000000000000100
FS:  00007ffc81a2c740(0000) GS:ffff88043fc40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007ffc813e8480 CR3: 00000002e7a92000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process btrfsctl (pid: 20842, threadinfo ffff88008eca6000, task ffff8803d8239630)
Stack:
 ffff8802080323f8 ffff880300000010 000000108eca7d58 ffff8802080323f8
 00000000000008a0 ffff8803fda1f708 00000000000008a0 ffffffffffffff84
 00000000000000ff 0000000000000268 ffff880088788008 0000000000000000
Call Trace:
 [<ffffffff81323975>] btrfs_ioctl_snap_destroy+0x3b5/0x480
 [<ffffffff81326ef2>] btrfs_ioctl+0x3a2/0x10d0
 [<ffffffff816da594>] ? do_page_fault+0x254/0x4b0
 [<ffffffff8112cdc0>] do_vfs_ioctl+0xa0/0x520
 [<ffffffff8112d28a>] sys_ioctl+0x4a/0x80
 [<ffffffff816de8d2>] system_call_fastpath+0x16/0x1b
Code: 48 8d 54 92 65 e8 89 f2 00 00 48 8b 5d b9 4c 89 ef e8 4d 2c fd ff 48 89 5d c8 e9 ca fe ff ff 0f 0b eb fe 0f 0b eb fe 0f 1f 40 00 <0f> 0b eb fe 0f 0b eb fe 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c
RIP  [<ffffffff81304d88>] btrfs_unlink_subvol+0x268/0x270
 RSP <ffff88008eca7d28>
---[ end trace 485334ee1ecd2cc8 ]---

After this, we hit a number of other BUG() and WARN() cases during
mounting on the next boot:

kernel BUG at fs/btrfs/extent-tree.c:6343!
WARNING: at fs/btrfs/extent-tree.c:4754 __btrfs_free_extent+0x627/0x720()
WARNING: at fs/btrfs/extent-tree.c:4801 __btrfs_free_extent+0x6cc/0x720()
kernel BUG at fs/btrfs/extent-tree.c:2287!

I posted them here if they are of any use:

	http://0x.ca/sim/ref/3.2-rc4/

We'll probably go back to 2.6.38 again for now, the latest mostly-working
kernel on this box.

Simon-
