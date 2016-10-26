Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:54826 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753676AbcJZA2D (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Oct 2016 20:28:03 -0400
Date: Tue, 25 Oct 2016 20:27:52 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Chris Mason <clm@fb.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
References: <332c8e94-a969-093f-1fb4-30d89be8993e@kernel.org>
 <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2016 at 09:42:39AM -0400, Chris Mason wrote:

 > >  > Well crud, we're back to wondering if this is Btrfs or the stack
 > >  > corruption.  Since the pagevecs are on the stack and this is a new
 > >  > crash, my guess is you'll be able to trigger it on xfs/ext4 too.  But we
 > >  > should make sure.
 > >
 > > Here's an interesting one from today, pointing the finger at xattrs again.
 > >
 > >
 > > [69943.450108] Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 > > [69943.454452] CPU: 1 PID: 21558 Comm: trinity-c60 Not tainted 4.9.0-rc1-think+ #11
 > > [69943.463510] task: ffff8804f8dd3740 task.stack: ffffc9000b108000
 > > [69943.468077] RIP: 0010:[<ffffffff810c3f6b>]
 > 
 > Was this btrfs?

I already told you elsewhere, but for benefit of everyone else, yes, it was.

At Chris' behest, I gave ext4 some more air-time with this workload.
It ran for 1 day 6 hrs without incident before I got bored and tried
something else.  I threw XFS on the test partition, restarted the test,
and got the warnings below across two reboots.

DaveC: Do these look like real problems, or is this more "looks like
random memory corruption" ?  It's been a while since I did some stress
testing on XFS, so these might not be new..



XFS: Assertion failed: oldlen > newlen, file: fs/xfs/libxfs/xfs_bmap.c, line: 2938
------------[ cut here ]------------
kernel BUG at fs/xfs/xfs_message.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP
CPU: 1 PID: 6227 Comm: trinity-c9 Not tainted 4.9.0-rc1-think+ #6 
task: ffff8804f4658040 task.stack: ffff88050568c000
RIP: 0010:[<ffffffffa02d3e2b>] 
  [<ffffffffa02d3e2b>] assfail+0x1b/0x20 [xfs]
RSP: 0000:ffff88050568f9e8  EFLAGS: 00010282
RAX: 00000000ffffffea RBX: 0000000000000046 RCX: 0000000000000001
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa02fe34d
RBP: ffff88050568f9e8 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ffff88050568fb44
R13: 00000000000000f3 R14: ffff8804f292bf88 R15: 000ffffffffe0046
FS:  00007fe2ddfdfb40(0000) GS:ffff88050a000000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe2dbabd000 CR3: 00000004f461f000 CR4: 00000000001406e0
Stack:
 ffff88050568fa88  ffffffffa027ccee  fffffffffffffff9  ffff8804f16fd8b0
 0000000000003ffa  0000000000000032  ffff8804f292bf40  0000000000004976
 000ffffffffe0008  00000000000004fd  ffff880400000000  0000000000005107
Call Trace:
 [<ffffffffa027ccee>] xfs_bmap_add_extent_hole_delay+0x54e/0x620 [xfs]
 [<ffffffffa027f2d4>] xfs_bmapi_reserve_delalloc+0x2b4/0x400 [xfs]
 [<ffffffffa02cadd7>] xfs_file_iomap_begin_delay.isra.12+0x247/0x3c0 [xfs]
 [<ffffffffa02cb0d1>] xfs_file_iomap_begin+0x181/0x270 [xfs]
 [<ffffffffa02ca13e>] ? xfs_file_iomap_end+0x9e/0xe0 [xfs]
 [<ffffffff8122e573>] iomap_apply+0x53/0x100
 [<ffffffff8122df10>] ? iomap_write_end+0x70/0x70
 [<ffffffff8122e68b>] iomap_file_buffered_write+0x6b/0x90
 [<ffffffff8122df10>] ? iomap_write_end+0x70/0x70
 [<ffffffffa02c1dd8>] xfs_file_buffered_aio_write+0xe8/0x1d0 [xfs]
 [<ffffffff810c3b7f>] ? __lock_acquire.isra.32+0x1cf/0x8c0
 [<ffffffffa02c1f45>] xfs_file_write_iter+0x85/0x120 [xfs]
 [<ffffffff811c8c98>] do_iter_readv_writev+0xa8/0x100
 [<ffffffff811c9622>] do_readv_writev+0x172/0x210
 [<ffffffffa02c1ec0>] ? xfs_file_buffered_aio_write+0x1d0/0x1d0 [xfs]
 [<ffffffff811e9794>] ? __fdget_pos+0x44/0x50
 [<ffffffff8178b2f2>] ? mutex_lock_nested+0x272/0x3f0
 [<ffffffff811e9794>] ? __fdget_pos+0x44/0x50
 [<ffffffff811e9794>] ? __fdget_pos+0x44/0x50
 [<ffffffff811c98ea>] vfs_writev+0x3a/0x50
 [<ffffffff811c9950>] do_writev+0x50/0xd0
 [<ffffffff811ca9fb>] SyS_writev+0xb/0x10
 [<ffffffff8100255c>] do_syscall_64+0x5c/0x170
 [<ffffffff8178ff4b>] entry_SYSCALL64_slow_path+0x25/0x25
Code: 48 c7 c7 65 e3 2f a0 e8 74 37 da e0 5d c3 66 90 55 48 89 f1 41 89 d0 48 c7 c6 18 93 30 a0 48 89 fa 48 89 e5 31 ff e8 65 fa ff ff <0f> 0b 0f 1f 00 55 48 63 f6 49 89 f9 41 b8 01 00 00 00 48 89 e5 
RIP 
  [<ffffffffa02d3e2b>] assfail+0x1b/0x20 [xfs]
 RSP <ffff88050568f9e8>



XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309
kernel BUG at fs/xfs/xfs_message.c:113!
invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
CPU: 0 PID: 7309 Comm: kworker/u8:1 Not tainted 4.9.0-rc1-think+ #11 
Workqueue: writeback wb_workfn
  (flush-8:0)
task: ffff88025eb98040 task.stack: ffffc9000a914000
RIP: 0010:[<ffffffffa0571e2b>] 
  [<ffffffffa0571e2b>] assfail+0x1b/0x20 [xfs]
RSP: 0018:ffffc9000a917410  EFLAGS: 00010282
RAX: 00000000ffffffea RBX: ffff8804538d22b8 RCX: 0000000000000001
RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa059c34d
RBP: ffffc9000a917410 R08: 0000000000000000 R09: 0000000000000000
R10: 000000000000000a R11: f000000000000000 R12: ffffffffffffffff
R13: ffff88047c765698 R14: 0000000000000001 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff880507800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000004c56e7000 CR4: 00000000001406f0
DR0: 00007fec5e3c9000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
Stack:
 ffffc9000a917438  ffffffffa057abe1  ffffc9000a917510  ffffc9000a917510
 ffffc9000a917510  ffffc9000a917460  ffffffffa0548eff  ffffc9000a917510
 0000000000000001  ffffc9000a917510  ffffc9000a917480  ffffffffa050aa3d
Call Trace:
 [<ffffffffa057abe1>] xfs_trans_mod_sb+0x241/0x280 [xfs]
 [<ffffffffa0548eff>] xfs_ag_resv_alloc_extent+0x4f/0xc0 [xfs]
 [<ffffffffa050aa3d>] xfs_alloc_ag_vextent+0x23d/0x300 [xfs]
 [<ffffffffa050bb1b>] xfs_alloc_vextent+0x5fb/0x6d0 [xfs]
 [<ffffffffa051c1b4>] xfs_bmap_btalloc+0x304/0x8e0 [xfs]
 [<ffffffffa054648e>] ? xfs_iext_bno_to_ext+0xee/0x170 [xfs]
 [<ffffffffa051c8db>] xfs_bmap_alloc+0x2b/0x40 [xfs]
 [<ffffffffa051dc30>] xfs_bmapi_write+0x640/0x1210 [xfs]
 [<ffffffffa0569326>] xfs_iomap_write_allocate+0x166/0x350 [xfs]
 [<ffffffffa05540b0>] xfs_map_blocks+0x1b0/0x260 [xfs]
 [<ffffffffa0554beb>] xfs_do_writepage+0x23b/0x730 [xfs]
 [<ffffffff81159ef8>] ? clear_page_dirty_for_io+0x128/0x210
 [<ffffffff81159e71>] ? clear_page_dirty_for_io+0xa1/0x210
 [<ffffffff8115a1b6>] write_cache_pages+0x1d6/0x4a0
 [<ffffffffa05549b0>] ? xfs_aops_discard_page+0x140/0x140 [xfs]
 [<ffffffffa0554419>] xfs_vm_writepages+0x59/0x80 [xfs]
 [<ffffffff8115af6c>] do_writepages+0x1c/0x30
 [<ffffffff811f6d33>] __writeback_single_inode+0x33/0x180
 [<ffffffff811f7528>] writeback_sb_inodes+0x2a8/0x5b0
 [<ffffffff811f78bd>] __writeback_inodes_wb+0x8d/0xc0
 [<ffffffff811f7b73>] wb_writeback+0x1e3/0x1f0
 [<ffffffff811f80b2>] wb_workfn+0xd2/0x280
 [<ffffffff81090875>] process_one_work+0x1d5/0x490
 [<ffffffff81090815>] ? process_one_work+0x175/0x490
 [<ffffffff81090b79>] worker_thread+0x49/0x490
 [<ffffffff81090b30>] ? process_one_work+0x490/0x490
 [<ffffffff81090b30>] ? process_one_work+0x490/0x490
 [<ffffffff81095cee>] kthread+0xee/0x110
 [<ffffffff81095c00>] ? kthread_park+0x60/0x60
 [<ffffffff81790bd2>] ret_from_fork+0x22/0x30
Code: 48 c7 c7 65 c3 59 a0 e8 c4 5c b0 e0 5d c3 66 90 55 48 89 f1 41 89 d0 48 c7 c6 18 73 5a a0 48 89 fa 48 89 e5 31 ff e8 65 fa ff ff <0f> 0b 0f 1f 00 55 48 63 f6 49 89 f9 41 b8 01 00 00 00 48 89 e5 
RIP 
  [<ffffffffa0571e2b>] assfail+0x1b/0x20 [xfs]
 RSP <ffffc9000a917410>





