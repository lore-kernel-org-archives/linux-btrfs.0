Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48850 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbeBVUMW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Feb 2018 15:12:22 -0500
Date: Thu, 22 Feb 2018 12:09:45 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Filipe Manana <fdmanana@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: Fix locking during DIO read
Message-ID: <20180222190945.GA11675@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <1519213303-2802-1-git-send-email-nborisov@suse.com>
 <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
 <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
 <CAL3q7H7PiYd2yXNeG3Lkx8XVOgwFhx_1-9kaY8wqHBYkXStJ7w@mail.gmail.com>
 <20180221182817.GB9910@lim.localdomain>
 <CAL3q7H4eus5pO-NohXRKDytjPQcMjCXov9s7W_p+5JCuuYe_Lg@mail.gmail.com>
 <20180221223806.GA32259@lim.localdomain>
 <29ab09a7-a6a2-d9d4-13d7-724cf4050c1c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <29ab09a7-a6a2-d9d4-13d7-724cf4050c1c@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 22, 2018 at 08:49:30AM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.02.2018 00:38, Liu Bo wrote:
> > On Wed, Feb 21, 2018 at 07:05:13PM +0000, Filipe Manana wrote:
> >> On Wed, Feb 21, 2018 at 6:28 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> >>> On Wed, Feb 21, 2018 at 02:42:08PM +0000, Filipe Manana wrote:
> >>>> On Wed, Feb 21, 2018 at 2:15 PM, Nikolay Borisov <nborisov@suse.com> wrote:
> >>>>>
> >>>>>
> >>>>> On 21.02.2018 15:51, Filipe Manana wrote:
> >>>>>> On Wed, Feb 21, 2018 at 11:41 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> >>>>>>> Currently the DIO read cases uses a botched idea from ext4 to ensure
> >>>>>>> that DIO reads don't race with truncate. The idea is that if we have a
> >>>>>>> pending truncate we set BTRFS_INODE_READDIO_NEED_LOCK which in turn
> >>>>>>> forces the dio read case to fallback to inode_locking to prevent
> >>>>>>> read/truncate races. Unfortunately this is subtly broken for at least
> >>>>>>> 2 reasons:
> >>>>>>>
> >>>>>>> 1. inode_dio_begin in btrfs_direct_IO is called outside of inode_lock
> >>>>>>> (for the read case). This means that there is no ordering guarantee
> >>>>>>> between the invocation of inode_dio_wait and the increment of
> >>>>>>> i_dio_count in btrfs_direct_IO in the tread case.
> >>>>>>
> >>>>>> Also, looking at this changelog, the diff and the code, why is it a
> >>>>>> problem not calling inode_dio_begin without the inode lock in the dio
> >>>>>> read path?
> >>>>>> The truncate path calls inode_dio_wait after setting the bit
> >>>>>> BTRFS_INODE_READDIO_NEED_LOCK and before clearing it.
> >>>>>> Assuming the functions to set and clear that bit are correct, I don't
> >>>>>> see what problem this brings.
> >>>>>
> >>>>> Assume you have a truncate and a dio READ in parallel. So the following
> >>>>> execution is possible:
> >>>>>
> >>>>> T1:                                                           T2:
> >>>>> btrfs_setattr
> >>>>>  set_bit(BTRFS_INODE_READDIO_NEED_LOCK)
> >>>>>  inode_dio_wait (reads i_dio_count)                        btrfs_direct_IO
> >>>>>  clear_bit(BTRFS_INODE_READDIO_NEED_LOCK)                  inode_dio_begin (inc's i_dio_count)
> >>>>>
> >>>>> Since we have no ordering between beginning a dio and waiting for it then
> >>>>> truncate can assume there isn't any pending dio. At the same time
> >>>>> btrfs_direct_IO will increment i_dio_count but won't see BTRFS_INODE_READDIO_NEED_LOCK
> >>>>> ever being set and so will proceed servicing the read.
> >>>>
> >>>> So what you are saying, is that you are concerned with a dio read
> >>>> starting after clearing the BTRFS_INODE_READDIO_NEED_LOCK.
> >>>> I don't think that is a problem, because the truncate path has already
> >>>> started a transaction before, which means blocks/extents deallocated
> >>>> by the truncation can not be reused and allocated to other inodes or
> >>>> the same inode (only after the transaction is committed).
> >>>>
> >>>> And considering that, commit 2e60a51e62185cce48758e596ae7cb2da673b58f
> >>>> ("Btrfs: serialize unlocked dio reads with truncate"), which
> >>>> introduced all this protection logic, is completely bogus. Looking at
> >>>> its changelog:
> >>>>
> >>>>     Btrfs: serialize unlocked dio reads with truncate
> >>>>
> >>>>     Currently, we can do unlocked dio reads, but the following race
> >>>>     is possible:
> >>>>
> >>>>     dio_read_task                   truncate_task
> >>>>                                     ->btrfs_setattr()
> >>>>     ->btrfs_direct_IO
> >>>>         ->__blockdev_direct_IO
> >>>>           ->btrfs_get_block
> >>>>                                       ->btrfs_truncate()
> >>>>                                      #alloc truncated blocks
> >>>>                                      #to other inode
> >>>>           ->submit_io()
> >>>>          #INFORMATION LEAK
> >>>>
> >>>>     In order to avoid this problem, we must serialize unlocked dio reads with
> >>>>     truncate. There are two approaches:
> >>>>     - use extent lock to protect the extent that we truncate
> >>>>     - use inode_dio_wait() to make sure the truncating task will wait for
> >>>>       the read DIO.
> >>>>
> >>>>     If we use the 1st one, we will meet the endless truncation problem due to
> >>>>     the nonlocked read DIO after we implement the nonlocked write DIO. It is
> >>>>     because we still need invoke inode_dio_wait() avoid the race between write
> >>>>     DIO and truncation. By that time, we have to introduce
> >>>>
> >>>>       btrfs_inode_{block, resume}_nolock_dio()
> >>>>
> >>>>     again. That is we have to implement this patch again, so I choose the 2nd
> >>>>     way to fix the problem.
> >>>>
> >>>> It's concerned with extents deallocated during the truncate operation
> >>>> being leaked through concurrent reads from other inodes that got that
> >>>> those extents allocated to them in the meanwhile (and the dio reads
> >>>> complete after the re-allocations and before the extents get written
> >>>> with new data) - but that can't happen because truncate is holding a
> >>>> transaction open. Further all that code that it introduced, can only
> >>>> prevent concurrent reads from the same inode, not from other inodes.
> >>>> So I think that commit does absolutely nothing and we should revert
> >>>> it.
> >>>>
> >>>
> >>> Well...make sense, but still dio read can read stale data past isize
> >>> if this inode_dio_wait() is removed.
> >>
> >> Yes, the inode_dio_wait() would remain, to prevent a dio read from
> >> submitting the bio before truncate drops an extent and the bio finish
> >> after the transaction from truncate commits (at which point the pinned
> >> extents could have been allocated for someone else and be partially,
> >> fully rewritten or discarded). All that stuff with the bit
> >> BTRFS_INODE_READDIO_NEED_LOCK would go away.
> > 
> > The commit description doesn't point it out but the code has the
> > necessary comment, BTRFS_INODE_READDIO_NEED_LOCK is used to prevent a
> > livelock if there are enough agreesive dio readers rushing in.
> > 
> >> If the transaction commits after the dio read, then everything is fine
> >> as for the cases where it reads data past the isize set by truncate,
> >> that data is preserved since the dropped extents are pinned, there's
> >> no chance for the application to read partial contents or garbage from
> >> the dropped extents.
> > 
> > Not even that far, isize is truncated before calling inode_dio_wait()
> > and a memory barrier is set to ensure the correct order, so dio read
> > would simply return if it's reading past isize.
> 
> Please, describe concretely which meory barriers pairs with chich in
> order to ensure proper visibility. Because I'm of the opinion there are
> insufficient memoru barriers to ensure setting READDIO_LOCK is properly
> visible in btrfs_direct_IO. Since the latter has no barriers whatsoever.

smp_mb() is supposed to be paired, so there is one missing, I agree.

Thanks,

-liubo
