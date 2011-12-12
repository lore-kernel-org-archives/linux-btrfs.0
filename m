From: David Sterba <dave@jikos.cz>
Subject: Re: warning and bug on 3.2-rc4 + for-linus from yesterday
Date: Mon, 12 Dec 2011 01:30:31 +0100
Message-ID: <20111212003031.GA7322@twin.jikos.cz>
References: <20111209203948.GA12378@hostway.ca>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Simon Kirby <sim@hostway.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111209203948.GA12378@hostway.ca>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Dec 09, 2011 at 12:39:48PM -0800, Simon Kirby wrote:
> ------------[ cut here ]------------
> WARNING: at mm/page-writeback.c:1763 __set_page_dirty_nobuffers+0x17b/0x190()
> Hardware name: PowerEdge 1950
> Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
> Pid: 14299, comm: btrfs-delalloc- Tainted: G        W    3.2.0-rc4-hw+ #71
> Call Trace:
>  [<ffffffff810dec2b>] ? __set_page_dirty_nobuffers+0x17b/0x190
>  [<ffffffff8105b050>] warn_slowpath_common+0x80/0xc0
>  [<ffffffff8105b0a5>] warn_slowpath_null+0x15/0x20
>  [<ffffffff810dec2b>] __set_page_dirty_nobuffers+0x17b/0x190
>  [<ffffffff81303b95>] compress_file_range+0x535/0x5e0
>  [<ffffffff811174ee>] ? kfree+0xee/0x120
>  [<ffffffff81303c70>] async_cow_start+0x30/0x50
>  [<ffffffff813220a3>] worker_loop+0x173/0x530
>  [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
>  [<ffffffff81321f30>] ? btrfs_queue_worker+0x310/0x310
>  [<ffffffff8107c7f6>] kthread+0x96/0xb0
>  [<ffffffff816e09b4>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8107c760>] ? kthread_worker_fn+0x190/0x190
>  [<ffffffff816e09b0>] ? gs_change+0x13/0x13
> ---[ end trace 52453f1ad38744b8 ]---
> 
> (several hours later)

1761                 if (mapping2) { /* Race with truncate? */
1762                         BUG_ON(mapping2 != mapping);
1763                         WARN_ON_ONCE(!PagePrivate(page) && !PageUptodate(page));
^^^^
1764                         account_page_dirtied(page, mapping);
1765                         radix_tree_tag_set(&mapping->page_tree,
1766                                 page_index(page), PAGECACHE_TAG_DIRTY);
1767                 }

The warning pops up just the first time, so I think it may happen more
often, would be interesting to verify this.

> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/inode.c:1587!
> invalid opcode: 0000 [#1] SMP
> CPU 2
> Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler aoe bnx2
> 
> Pid: 4477, comm: btrfs-fixup-0 Tainted: G        W    3.2.0-rc4-hw+ #71 Dell Inc. PowerEdge 1950/0NK937
> RIP: 0010:[<ffffffff812fbe10>]  [<ffffffff812fbe10>] btrfs_writepage_fixup_worker+0x160/0x170

I was chasing this BUG last week with 3.1+cmason/for-linus and I'm able
to trigger it quite reliably with looped xfstests/209 and low writeback
activity like looped make all & clean in kernel tree (reliably means
like from 10 minutes to 1 day).

Chris told me to instrument SetPageDirty and based on a similar tracing
patchset (http://lwn.net/Articles/315511/) I tried but to no avail, the
instrumentation must have significantly changed timing and the bug did not fire
at all.

I skip the details of my debugging results for now, the first
stacktrace contains something I was hoping for :)

async_cow_start -- calls compress_file_range directly,

compress_file_range+0x535
(gdb) l *(compress_file_range+0x535)
0x31605 is in compress_file_range (fs/btrfs/inode.c:540).
535                      * for the async work queue to run cow_file_range to do
536                      * the normal delalloc dance
537                      */
538                     if (page_offset(locked_page) >= start &&
539                         page_offset(locked_page) <= end) {
540                             __set_page_dirty_nobuffers(locked_page);
541                             /* unlocked later on in the async handlers */
542                     }
543                     add_async_extent(async_cow, start, end - start + 1,
544                                      0, NULL, 0, BTRFS_COMPRESS_NONE);

this code is reached from (or in a general case when compression is not done):

 356         /*
 357          * we don't want to send crud past the end of i_size through
 358          * compression, that's just a waste of CPU time.  So, if the
 359          * end of the file is before the start of our current
 360          * requested range of bytes, we bail out to the uncompressed
 361          * cleanup code that can deal with all of this.
 362          *
 363          * It isn't really the fastest way to fix things, but this is a
 364          * very uncommon corner.
 365          */
 366         if (actual_end <= start)
 367                 goto cleanup_and_bail_uncompressed;

... but seems that 'uncommon' happens and could trigger the bug in fixup
worker if there is some race with truncate.

I'll try to put together details and logs from my debugging.


david
