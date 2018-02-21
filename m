Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752146AbeBUSea (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:34:30 -0500
Date: Wed, 21 Feb 2018 10:28:17 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] btrfs: Fix locking during DIO read
Message-ID: <20180221182817.GB9910@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1519213303-2802-1-git-send-email-nborisov@suse.com>
 <CAL3q7H4aiNyzgtDoziTXYkwuSggUAF+b9uLTWcm15GQSigp1_w@mail.gmail.com>
 <de457af6-6a9c-43f4-b9c6-429b69deec77@suse.com>
 <CAL3q7H7PiYd2yXNeG3Lkx8XVOgwFhx_1-9kaY8wqHBYkXStJ7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H7PiYd2yXNeG3Lkx8XVOgwFhx_1-9kaY8wqHBYkXStJ7w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 21, 2018 at 02:42:08PM +0000, Filipe Manana wrote:
> On Wed, Feb 21, 2018 at 2:15 PM, Nikolay Borisov <nborisov@suse.com> wrote:
> >
> >
> > On 21.02.2018 15:51, Filipe Manana wrote:
> >> On Wed, Feb 21, 2018 at 11:41 AM, Nikolay Borisov <nborisov@suse.com> wrote:
> >>> Currently the DIO read cases uses a botched idea from ext4 to ensure
> >>> that DIO reads don't race with truncate. The idea is that if we have a
> >>> pending truncate we set BTRFS_INODE_READDIO_NEED_LOCK which in turn
> >>> forces the dio read case to fallback to inode_locking to prevent
> >>> read/truncate races. Unfortunately this is subtly broken for at least
> >>> 2 reasons:
> >>>
> >>> 1. inode_dio_begin in btrfs_direct_IO is called outside of inode_lock
> >>> (for the read case). This means that there is no ordering guarantee
> >>> between the invocation of inode_dio_wait and the increment of
> >>> i_dio_count in btrfs_direct_IO in the tread case.
> >>
> >> Also, looking at this changelog, the diff and the code, why is it a
> >> problem not calling inode_dio_begin without the inode lock in the dio
> >> read path?
> >> The truncate path calls inode_dio_wait after setting the bit
> >> BTRFS_INODE_READDIO_NEED_LOCK and before clearing it.
> >> Assuming the functions to set and clear that bit are correct, I don't
> >> see what problem this brings.
> >
> > Assume you have a truncate and a dio READ in parallel. So the following
> > execution is possible:
> >
> > T1:                                                           T2:
> > btrfs_setattr
> >  set_bit(BTRFS_INODE_READDIO_NEED_LOCK)
> >  inode_dio_wait (reads i_dio_count)                        btrfs_direct_IO
> >  clear_bit(BTRFS_INODE_READDIO_NEED_LOCK)                  inode_dio_begin (inc's i_dio_count)
> >
> > Since we have no ordering between beginning a dio and waiting for it then
> > truncate can assume there isn't any pending dio. At the same time
> > btrfs_direct_IO will increment i_dio_count but won't see BTRFS_INODE_READDIO_NEED_LOCK
> > ever being set and so will proceed servicing the read.
> 
> So what you are saying, is that you are concerned with a dio read
> starting after clearing the BTRFS_INODE_READDIO_NEED_LOCK.
> I don't think that is a problem, because the truncate path has already
> started a transaction before, which means blocks/extents deallocated
> by the truncation can not be reused and allocated to other inodes or
> the same inode (only after the transaction is committed).
> 
> And considering that, commit 2e60a51e62185cce48758e596ae7cb2da673b58f
> ("Btrfs: serialize unlocked dio reads with truncate"), which
> introduced all this protection logic, is completely bogus. Looking at
> its changelog:
> 
>     Btrfs: serialize unlocked dio reads with truncate
> 
>     Currently, we can do unlocked dio reads, but the following race
>     is possible:
> 
>     dio_read_task                   truncate_task
>                                     ->btrfs_setattr()
>     ->btrfs_direct_IO
>         ->__blockdev_direct_IO
>           ->btrfs_get_block
>                                       ->btrfs_truncate()
>                                      #alloc truncated blocks
>                                      #to other inode
>           ->submit_io()
>          #INFORMATION LEAK
> 
>     In order to avoid this problem, we must serialize unlocked dio reads with
>     truncate. There are two approaches:
>     - use extent lock to protect the extent that we truncate
>     - use inode_dio_wait() to make sure the truncating task will wait for
>       the read DIO.
> 
>     If we use the 1st one, we will meet the endless truncation problem due to
>     the nonlocked read DIO after we implement the nonlocked write DIO. It is
>     because we still need invoke inode_dio_wait() avoid the race between write
>     DIO and truncation. By that time, we have to introduce
> 
>       btrfs_inode_{block, resume}_nolock_dio()
> 
>     again. That is we have to implement this patch again, so I choose the 2nd
>     way to fix the problem.
> 
> It's concerned with extents deallocated during the truncate operation
> being leaked through concurrent reads from other inodes that got that
> those extents allocated to them in the meanwhile (and the dio reads
> complete after the re-allocations and before the extents get written
> with new data) - but that can't happen because truncate is holding a
> transaction open. Further all that code that it introduced, can only
> prevent concurrent reads from the same inode, not from other inodes.
> So I think that commit does absolutely nothing and we should revert
> it.
>

Well...make sense, but still dio read can read stale data past isize
if this inode_dio_wait() is removed.

thanks,

-liubo
