Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:53316 "EHLO
        arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755818AbcJTWsZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 20 Oct 2016 18:48:25 -0400
Date: Thu, 20 Oct 2016 18:48:16 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Jens Axboe <axboe@fb.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>
Subject: Re: bio linked list corruption.
Message-ID: <20161020224816.tshmynpaj7ekbh6t@codemonkey.org.uk>
References: <20161011144507.okg6baqvodn2m2lh@codemonkey.org.uk>
 <20161018224205.bjgloslaxcej2td2@codemonkey.org.uk>
 <e9e28964-4540-6e95-b4b7-aafd509fd8bc@fb.com>
 <20161018233148.GA93792@clm-mbp.masoncoding.com>
 <CA+55aFz37uBqo9LG6pwRCB1pU94o3yz1SXwj3xwzHRXtg5Cgyw@mail.gmail.com>
 <20161018234248.GB93792@clm-mbp.masoncoding.com>
 <CA+55aFyXi-iUYx6kOnQrCjzGj-uoOa+0voz0HZz7DAFPYK6ctg@mail.gmail.com>
 <CA+55aFxA1QrO2sBwwtEQVp3FFgs6CGWzJg+U5kif+-msFc90uA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+55aFxA1QrO2sBwwtEQVp3FFgs6CGWzJg+U5kif+-msFc90uA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 18, 2016 at 05:28:44PM -0700, Linus Torvalds wrote:
 > On Tue, Oct 18, 2016 at 5:10 PM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > Adding Andy to the cc, because this *might* be triggered by the
 > > vmalloc stack code itself. Maybe the re-use of stacks showing some
 > > problem? Maybe Chris (who can't see the problem) doesn't have
 > > CONFIG_VMAP_STACK enabled?
 > 
 > I bet it's the plug itself that is the stack address. In fact, it's
 > probably that mq_list head pointer

So I've done a few experiments the last couple days.

1, I see some kind of disaster happen with every filesystem
ext4, btrfs, xfs.  For some reason I can repro it faster on btrfs
(though xfs blew up pretty quickly too, but I don't know if it's
the same as this list corruption bug).

2, I ran for 24 hours with VMAP_STACK turned off.  I saw some
_different_ btrfs problems, but I never hit that list debug corruption
once.

3, I turned vmap stacks back on, and got this pretty quickly.
Another new flavor of crash, but Chris recommended I post this one
because it looks interesting.

[ 3943.514961] BUG: Bad page state in process kworker/u8:14  pfn:482244
[ 3943.532400] page:ffffea0012089100 count:0 mapcount:0 mapping:ffff8804c40d6ae0 index:0x2f
[ 3943.551865] flags: 0x4000000000000008(uptodate)
[ 3943.561652] page dumped because: non-NULL mapping
[ 3943.587698] CPU: 2 PID: 26823 Comm: kworker/u8:14 Not tainted 4.9.0-rc1-think+ #9 
[ 3943.607409] Workqueue: writeback wb_workfn
[ 3943.617194]  (flush-btrfs-2)
[ 3943.617260]  ffffc90001bf7870
[ 3943.627007]  ffffffff8130c93c
[ 3943.627075]  ffffea0012089100
[ 3943.627112]  ffffffff819ff37c
[ 3943.627149]  ffffc90001bf7898
[ 3943.636918]  ffffffff81150fef
[ 3943.636985]  0000000000000000
[ 3943.637021]  ffffea0012089100
[ 3943.637059]  4000000000000008
[ 3943.646965]  ffffc90001bf78a8
[ 3943.647041]  ffffffff811510aa
[ 3943.647081]  ffffc90001bf78f0
[ 3943.647126] Call Trace:
[ 3943.657068]  [<ffffffff8130c93c>] dump_stack+0x4f/0x73
[ 3943.666996]  [<ffffffff81150fef>] bad_page+0xbf/0x120
[ 3943.676839]  [<ffffffff811510aa>] free_pages_check_bad+0x5a/0x70
[ 3943.686646]  [<ffffffff8115355b>] free_hot_cold_page+0x20b/0x270
[ 3943.696402]  [<ffffffff8115387b>] free_hot_cold_page_list+0x2b/0x50
[ 3943.706092]  [<ffffffff8115c1fd>] release_pages+0x2bd/0x350
[ 3943.715726]  [<ffffffff8115d732>] __pagevec_release+0x22/0x30
[ 3943.725358]  [<ffffffffa00a0d4e>] extent_write_cache_pages.isra.48.constprop.63+0x32e/0x400 [btrfs]
[ 3943.735126]  [<ffffffffa00a1199>] extent_writepages+0x49/0x60 [btrfs]
[ 3943.744808]  [<ffffffffa0081840>] ? btrfs_releasepage+0x40/0x40 [btrfs]
[ 3943.754457]  [<ffffffffa007e993>] btrfs_writepages+0x23/0x30 [btrfs]
[ 3943.764085]  [<ffffffff8115a91c>] do_writepages+0x1c/0x30
[ 3943.773667]  [<ffffffff811f65f3>] __writeback_single_inode+0x33/0x180
[ 3943.783233]  [<ffffffff811f6de8>] writeback_sb_inodes+0x2a8/0x5b0
[ 3943.792870]  [<ffffffff811f733b>] wb_writeback+0xeb/0x1f0
[ 3943.802326]  [<ffffffff811f7972>] wb_workfn+0xd2/0x280
[ 3943.811673]  [<ffffffff810906e5>] process_one_work+0x1d5/0x490
[ 3943.821044]  [<ffffffff81090685>] ? process_one_work+0x175/0x490
[ 3943.830447]  [<ffffffff810909e9>] worker_thread+0x49/0x490
[ 3943.839756]  [<ffffffff810909a0>] ? process_one_work+0x490/0x490
[ 3943.849074]  [<ffffffff810909a0>] ? process_one_work+0x490/0x490
[ 3943.858264]  [<ffffffff81095b5e>] kthread+0xee/0x110
[ 3943.867451]  [<ffffffff81095a70>] ? kthread_park+0x60/0x60
[ 3943.876616]  [<ffffffff81095a70>] ? kthread_park+0x60/0x60
[ 3943.885624]  [<ffffffff81095a70>] ? kthread_park+0x60/0x60
[ 3943.894580]  [<ffffffff81790492>] ret_from_fork+0x22/0x30

This feels like chasing a moving target, because the crash keeps changing..
I'm going to spend some time trying to at least pin down a selection
of syscalls that trinity can reproduce this with quickly.

Early-on, it seemed like this was xattr related, but now I'm not so sure.
Once or twice, I was able to repro it within a few minutes using just
writev, fsync, lsetxattr and lremovexattr.  Then a day later, I found I
could run for a day before seeing it.  Position of the moon or something.
Or it could have been entirely unrelated to the actual syscalls being run,
and based just on how contended the cpu/memory was.

	Dave

