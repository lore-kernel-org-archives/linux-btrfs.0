Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:27730 "EHLO
        ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750971AbcJ0Flj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Oct 2016 01:41:39 -0400
Date: Thu, 27 Oct 2016 16:41:33 +1100
From: Dave Chinner <david@fromorbit.com>
To: Dave Jones <davej@codemonkey.org.uk>, Chris Mason <clm@fb.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161027054133.GM14023@dastard>
References: <20161020225028.czodw54tjbiwwv3o@codemonkey.org.uk>
 <CALCETrV5hr_QQ7eiqrac7huh3hX1Mp0ArrOmKKj_eKHw5gx76Q@mail.gmail.com>
 <20161020230341.jsxpia2sy53xn5l5@codemonkey.org.uk>
 <CALCETrVHXPw1PyKSQja07V+MxHJPcDkaLJ1rPF2Z3286tHY2Xw@mail.gmail.com>
 <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2016 at 08:27:52PM -0400, Dave Jones wrote:
> DaveC: Do these look like real problems, or is this more "looks like
> random memory corruption" ?  It's been a while since I did some stress
> testing on XFS, so these might not be new..
> 
> XFS: Assertion failed: oldlen > newlen, file: fs/xfs/libxfs/xfs_bmap.c, line: 2938
> ------------[ cut here ]------------
> kernel BUG at fs/xfs/xfs_message.c:113!
> invalid opcode: 0000 [#1] PREEMPT SMP
> CPU: 1 PID: 6227 Comm: trinity-c9 Not tainted 4.9.0-rc1-think+ #6 
> task: ffff8804f4658040 task.stack: ffff88050568c000
> RIP: 0010:[<ffffffffa02d3e2b>] 
>   [<ffffffffa02d3e2b>] assfail+0x1b/0x20 [xfs]
> RSP: 0000:ffff88050568f9e8  EFLAGS: 00010282
> RAX: 00000000ffffffea RBX: 0000000000000046 RCX: 0000000000000001
> RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffa02fe34d
> RBP: ffff88050568f9e8 R08: 0000000000000000 R09: 0000000000000000
> R10: 000000000000000a R11: f000000000000000 R12: ffff88050568fb44
> R13: 00000000000000f3 R14: ffff8804f292bf88 R15: 000ffffffffe0046
> FS:  00007fe2ddfdfb40(0000) GS:ffff88050a000000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe2dbabd000 CR3: 00000004f461f000 CR4: 00000000001406e0
> Stack:
>  ffff88050568fa88  ffffffffa027ccee  fffffffffffffff9  ffff8804f16fd8b0
>  0000000000003ffa  0000000000000032  ffff8804f292bf40  0000000000004976
>  000ffffffffe0008  00000000000004fd  ffff880400000000  0000000000005107
> Call Trace:
>  [<ffffffffa027ccee>] xfs_bmap_add_extent_hole_delay+0x54e/0x620 [xfs]
>  [<ffffffffa027f2d4>] xfs_bmapi_reserve_delalloc+0x2b4/0x400 [xfs]
>  [<ffffffffa02cadd7>] xfs_file_iomap_begin_delay.isra.12+0x247/0x3c0 [xfs]
>  [<ffffffffa02cb0d1>] xfs_file_iomap_begin+0x181/0x270 [xfs]
>  [<ffffffff8122e573>] iomap_apply+0x53/0x100
>  [<ffffffff8122e68b>] iomap_file_buffered_write+0x6b/0x90

All this iomap code is new, so it's entirely possible that this is a
new bug. The assert failure is indicative that the delalloc extent's
metadata reservation grew when we expected it to stay the same or
shrink.

> XFS: Assertion failed: tp->t_blk_res_used <= tp->t_blk_res, file: fs/xfs/xfs_trans.c, line: 309
...
>  [<ffffffffa057abe1>] xfs_trans_mod_sb+0x241/0x280 [xfs]
>  [<ffffffffa0548eff>] xfs_ag_resv_alloc_extent+0x4f/0xc0 [xfs]
>  [<ffffffffa050aa3d>] xfs_alloc_ag_vextent+0x23d/0x300 [xfs]
>  [<ffffffffa050bb1b>] xfs_alloc_vextent+0x5fb/0x6d0 [xfs]
>  [<ffffffffa051c1b4>] xfs_bmap_btalloc+0x304/0x8e0 [xfs]
>  [<ffffffffa054648e>] ? xfs_iext_bno_to_ext+0xee/0x170 [xfs]
>  [<ffffffffa051c8db>] xfs_bmap_alloc+0x2b/0x40 [xfs]
>  [<ffffffffa051dc30>] xfs_bmapi_write+0x640/0x1210 [xfs]
>  [<ffffffffa0569326>] xfs_iomap_write_allocate+0x166/0x350 [xfs]
>  [<ffffffffa05540b0>] xfs_map_blocks+0x1b0/0x260 [xfs]
>  [<ffffffffa0554beb>] xfs_do_writepage+0x23b/0x730 [xfs]

And that's indicative of a delalloc metadata reservation being
being too small and so we're allocating unreserved blocks.

Different symptoms, same underlying cause, I think.

I see the latter assert from time to time in my testing, but it's
not common (maybe once a month) and I've never been able to track it
down.  However, it doesn't affect production systems unless they hit
ENOSPC hard enough that it causes the critical reserve pool to be
exhausted iand so the allocation fails. That's extremely rare -
usually takes a several hundred processes all trying to write as had
as they can concurrently and to all slip through the ENOSPC
detection without the correct metadata reservations and all require
multiple metadata blocks to be allocated durign writeback...

If you've got a way to trigger it quickly and reliably, that would
be helpful...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
