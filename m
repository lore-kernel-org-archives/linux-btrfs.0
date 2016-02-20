Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41973 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946154AbcBTA7z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Feb 2016 19:59:55 -0500
Date: Fri, 19 Feb 2016 17:02:18 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@kernel.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] Btrfs: fix deadlock between direct IO reads and buffered
 writes
Message-ID: <20160220010218.GA4873@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1455817370-1832-1-git-send-email-fdmanana@kernel.org>
 <20160218195307.GB7164@localhost.localdomain>
 <CAL3q7H6Ev8_cbt0L8R_BaEwmvv5oM9CvsNKsMe_GH+carUu1tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H6Ev8_cbt0L8R_BaEwmvv5oM9CvsNKsMe_GH+carUu1tQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 18, 2016 at 08:05:33PM +0000, Filipe Manana wrote:
> On Thu, Feb 18, 2016 at 7:53 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Thu, Feb 18, 2016 at 05:42:50PM +0000, fdmanana@kernel.org wrote:
> >> From: Filipe Manana <fdmanana@suse.com>
[long stack]
> >> This happened because under specific timings the path for direct IO reads
> >> can deadlock with concurrent buffered writes. The diagram below shows how
> >> this happens for an example file that has the following layout:
> >>
> >>      [  extent A  ]  [  extent B  ]  [ ....
> >>      0K              4K              8K
> >>
> >>      CPU 1                                               CPU 2                             CPU 3
> >>
> >> DIO read against range
> >>  [0K, 8K[ starts
> >>
> >> btrfs_direct_IO()
> >>   --> calls btrfs_get_blocks_direct()
> >>       which finds the extent map for the
> >>       extent A and leaves the range
> >>       [0K, 4K[ locked in the inode's
> >>       io tree
> >>
> >>                                                    buffered write against
> >>                                                    range [4K, 8K[ starts
> >>
> >>                                                    __btrfs_buffered_write()
> >>                                                      --> dirties page at 4K
> >>
> >>                                                                                      a user space
> >>                                                                                      task calls sync
> >>                                                                                      for e.g or
> >>                                                                                      writepages() is
> >>                                                                                      invoked by mm
> >>
> >>                                                                                      writepages()
> >>                                                                                        run_delalloc_range()
> >>                                                                                          cow_file_range()
> >>                                                                                            --> ordered extent X
> >>                                                                                                for the buffered
> >>                                                                                                write is created
> >>                                                                                                and
> >>                                                                                                writeback starts
> >>
> >>   --> calls btrfs_get_blocks_direct()
> >>       again, without submitting first
> >>       a bio for reading extent A, and
> >>       finds the extent map for extent B
> >>
> >>   --> calls lock_extent_direct()
> >>
> >>       --> locks range [4K, 8K[
> >>       --> finds ordered extent X
> >>           covering range [4K, 8K[
> >>       --> unlocks range [4K, 8K[
> >>
> >>                                                   buffered write against
> >>                                                   range [0K, 8K[ starts
> >>
> >>                                                   __btrfs_buffered_write()
> >>                                                     prepare_pages()
> >>                                                       --> locks pages with
> >>                                                           offsets 0 and 4K
> >>                                                     lock_and_cleanup_extent_if_need()
> >>                                                       --> blocks attempting to
> >>                                                           lock range [0K, 8K[ in
> >>                                                           the inode's io tree,
> >>                                                           because the range [0, 4K[
> >>                                                           is already locked by the
> >>                                                           direct IO task at CPU 1
> >>
> >>       --> calls
> >>           btrfs_start_ordered_extent(oe X)
> >>
> >>           btrfs_start_ordered_extent(oe X)
> >>
> >>             --> At this point writeback for ordered
> >>                 extent X has not finished yet
> >>
> >>             filemap_fdatawrite_range()
> >>               btrfs_writepages()
> >>                 extent_writepages()
> >>                   extent_write_cache_pages()
> >>                     --> finds page with offset 0
> >>                         with the writeback tag
> >>                         (and not dirty)
> >>                     --> tries to lock it
> >>                          --> deadlock, task at CPU 1
> >                                                 ^^^^ CPU 2
> >>                              has the page locked and
> >>                              is blocked on the io range
> >>                              [0, 4K[ that was locked
> >>                              earlier by this task
> >
> > Looks like the task at _CPU 2_ has the page locked and is stuck in lock_and_cleanup_extent_if_need().
> 
> Yes, that's what is said above in the CPU 2 column, isn't it?

Yes, I was just trying to point a typo out.

> 
> >
> >>
> >> So fix this by falling back to a buffered read in the direct IO read path
> >> when an ordered extent for a buffered write is found.
> >
> > My question is, after we return ENOTBLK for [4k, 8k], will [0, 4k] dio
> > read submit the bio or fall back to buffered read?
> 
> Yes, it will call the submit bio callback for all the previous calls
> to btrfs_get_block_direct that succeeded.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Btw, after revisiting the code, I think that it is not necessary to limit
 'len' to sectorsize (which ends up with the above deadlock), the reason
 we did that is we can use extent_io_tree to store checksum, but now
we're in fact using csum array in btrfs_io_bio.  After that limit is
removed, xfstests cases in aio groups doesn't report errors, but I'm not
sure if it would survive your stress tests.

(cc Josef as Josef made that change.)

Thanks,

-liubo

> 
> thanks.
> 
> >
> > Thanks,
> >
> > -liubo
> >>
> >> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> >> ---
> >>  fs/btrfs/inode.c | 25 +++++++++++++++++++++++--
> >>  1 file changed, 23 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index a4d3c54a..64191a9 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -7419,7 +7419,26 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
> >>                                    cached_state, GFP_NOFS);
> >>
> >>               if (ordered) {
> >> -                     btrfs_start_ordered_extent(inode, ordered, 1);
> >> +                     /*
> >> +                      * If we are doing a DIO read and the ordered extent we
> >> +                      * found is for a buffered write, we can not wait for it
> >> +                      * to complete and retry, because if we do so we can
> >> +                      * deadlock with concurrent buffered writes on page
> >> +                      * locks. This happens only if our DIO read covers more
> >> +                      * than one extent map, if at this point has already
> >> +                      * created an ordered extent for a previous extent map
> >> +                      * and locked its range in the inode's io tree, and a
> >> +                      * concurrent write against that previous extent map's
> >> +                      * range and this range started (we unlock the ranges
> >> +                      * in the io tree only when the bios complete and
> >> +                      * buffered writes always lock pages before attempting
> >> +                      * to lock range in the io tree).
> >> +                      */
> >> +                     if (writing ||
> >> +                         test_bit(BTRFS_ORDERED_DIRECT, &ordered->flags))
> >> +                             btrfs_start_ordered_extent(inode, ordered, 1);
> >> +                     else
> >> +                             ret = -ENOTBLK;
> >>                       btrfs_put_ordered_extent(ordered);
> >>               } else {
> >>                       /*
> >> @@ -7436,9 +7455,11 @@ static int lock_extent_direct(struct inode *inode, u64 lockstart, u64 lockend,
> >>                        * that page.
> >>                        */
> >>                       ret = -ENOTBLK;
> >> -                     break;
> >>               }
> >>
> >> +             if (ret)
> >> +                     break;
> >> +
> >>               cond_resched();
> >>       }
> >>
> >> --
> >> 2.7.0.rc3
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
