Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:39066 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbcJZSSo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 14:18:44 -0400
Date: Wed, 26 Oct 2016 14:18:33 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: bio linked list corruption.
Message-ID: <20161026181833.ld7atax6yqbdgz7p@codemonkey.org.uk>
References: <20161021200245.kahjzgqzdfyoe3uz@codemonkey.org.uk>
 <20161022152033.gkmm3l75kqjzsije@codemonkey.org.uk>
 <b1bbcbfc-dba2-952d-f1c0-87f532d5936b@fb.com>
 <20161024044051.onmh4h6sc2bjxzzc@codemonkey.org.uk>
 <77d9983d-a00a-1dc1-a9a1-631de1d0c146@fb.com>
 <20161026002752.qvrm6yxqb54fiqnd@codemonkey.org.uk>
 <CA+55aFyv0k9e6bBqGm-LL3CUwimS4+rSu341P7SOV5ezYrrW_g@mail.gmail.com>
 <CA+55aFydo5oxo+ihUfGffMK6cAZnbZ8WyEiF7xgEx1Bh_aOMww@mail.gmail.com>
 <20161026163018.wx57yy554576s6e2@codemonkey.org.uk>
 <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFzsrRenu3NsDYr3qqO=fC9FUxkLc3M2wzeLBpN7ghwvwA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 26, 2016 at 09:48:39AM -0700, Linus Torvalds wrote:
 > On Wed, Oct 26, 2016 at 9:30 AM, Dave Jones <davej@codemonkey.org.uk> wrote:
 > >
 > > I gave this a go last thing last night. It crashed within 5 minutes,
 > > but it was one we've already seen (the bad page map trace) with nothing
 > > additional that looked interesting.
 > 
 > Did the bad page map trace have any registers that looked like they
 > had 0xd0d0d0d0d0d0 in them?
 > 
 > I assume not, but worth checking.
 
sadly not. In case I did overlook something, here's last nights..

BUG: Bad page state in process kworker/u8:13  pfn:4dae31
page:ffffea00136b8c40 count:0 mapcount:0 mapping:ffff8804f011d6e0 index:0xd1530
flags: 0x400000000000000c(referenced|uptodate)
page dumped because: non-NULL mapping
CPU: 3 PID: 1207 Comm: kworker/u8:13 Not tainted 4.9.0-rc2-think+ #3 
Workqueue: writeback wb_workfn
  (flush-btrfs-1)
 ffffc900006fb870
 ffffffff8130cf3c
 ffffea00136b8c40
 ffffffff819ff54c
 ffffc900006fb898
 ffffffff811511af
 0000000000000000
 ffffea00136b8c40
 400000000000000c
 ffffc900006fb8a8
 ffffffff8115126a
 ffffc900006fb8f0
Call Trace:
 [<ffffffff8130cf3c>] dump_stack+0x4f/0x73
 [<ffffffff811511af>] bad_page+0xbf/0x120
 [<ffffffff8115126a>] free_pages_check_bad+0x5a/0x70
 [<ffffffff81153b68>] free_hot_cold_page+0x248/0x290
 [<ffffffff81153e6b>] free_hot_cold_page_list+0x2b/0x50
 [<ffffffff8115c87d>] release_pages+0x2bd/0x350
 [<ffffffff8115ddb2>] __pagevec_release+0x22/0x30
 [<ffffffffa00a0d4e>] extent_write_cache_pages.isra.48.constprop.63+0x32e/0x400 [btrfs]
 [<ffffffffa00a1199>] extent_writepages+0x49/0x60 [btrfs]
 [<ffffffffa0081840>] ? btrfs_releasepage+0x40/0x40 [btrfs]
 [<ffffffffa007e993>] btrfs_writepages+0x23/0x30 [btrfs]
 [<ffffffff8115af9c>] do_writepages+0x1c/0x30
 [<ffffffff811f6d73>] __writeback_single_inode+0x33/0x180
 [<ffffffff811f7568>] writeback_sb_inodes+0x2a8/0x5b0
 [<ffffffff811f7abb>] wb_writeback+0xeb/0x1f0
 [<ffffffff811f80f2>] wb_workfn+0xd2/0x280
 [<ffffffff810908a5>] process_one_work+0x1d5/0x490
 [<ffffffff81090845>] ? process_one_work+0x175/0x490
 [<ffffffff81090ba9>] worker_thread+0x49/0x490
 [<ffffffff81090b60>] ? process_one_work+0x490/0x490
 [<ffffffff81095d1e>] kthread+0xee/0x110
 [<ffffffff81095c30>] ? kthread_park+0x60/0x60
 [<ffffffff81790a52>] ret_from_fork+0x22/0x30


 > > Heisenbugs man, literally the worst.
 > 
 > I know you already had this in some email, but I lost it. I think you
 > narrowed it down to a specific set of system calls that seems to
 > trigger this best. fallocate and xattrs or something?

I did. Or so I thought.  Then iirc, it ran for a really long time
with those.  I'll revisit that just to be sure.

Something else I tried: Trinity is very heavily stressing
the fork path, with new children forking off and doing crazy shit
all the time, segfaulting, repeat.  I wrote a small test app that
models all of that sans the "do crazy shit with syscalls", and that
didn't do anything useful in terms of reproducing this.
I hoped that had panned out, because I could totally see the relationship
between reusing vmap'ing stacks and heavy fork() use.
Perhaps I'm still missing something non-obvious.

	Dave

