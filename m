Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:50546 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752990AbcLPWhT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Dec 2016 17:37:19 -0500
Date: Fri, 16 Dec 2016 14:37:02 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>
Subject: Re: resend: Re: Btrfs: adjust len of writes if following a
 preallocated extent
Message-ID: <20161216223702.GB2002@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1478287254-5458-1-git-send-email-bo.li.liu@oracle.com>
 <b600e06c-f946-853a-d868-eed429f9097b@profihost.ag>
 <20161123212210.GA24103@localhost.localdomain>
 <CAL3q7H4T35BVRh73pSoE51UygQwPCzdNSVHR1U1jbRqyO0j-rQ@mail.gmail.com>
 <20161202014111.GA11558@dhcp-whq-twvpn-2-vpnpool-10-159-164-218.vpn.oracle.com>
 <CAL3q7H4_KhCpjtfQguNW41EsKFzj=+hRVOixi4ppbOgsVDggKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H4_KhCpjtfQguNW41EsKFzj=+hRVOixi4ppbOgsVDggKw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 02, 2016 at 12:25:19PM +0000, Filipe Manana wrote:
> On Fri, Dec 2, 2016 at 1:41 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Thu, Nov 24, 2016 at 11:13:37AM +0000, Filipe Manana wrote:
> >> On Wed, Nov 23, 2016 at 9:22 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
...
> >>
> >> The analysis is correct Bo.
> >> Originally to fix races between fsync and direct IO writes there was a
> >> solution [1, 2] that didn't involve adding a semaphore and relied on
> >> creating first the ordered extents and then the extent maps only in
> >> the direct IO write path (we do things in the reverse order everywhere
> >> else). It worked and was documented in comments but wasn't
> >> particularly elegant and Josef was not happy because of that, so then
> >> we added the semaphore and made direct IO write path create the extent
> >> maps and ordered extents in the same order as everywhere else [3].
> >>
> >> So here I can only see 2 simple solutions. Either revert [3] (which
> >> added the semaphore) or acquire the semaphore at a higher level in
> >> direct IO write path like this:
> >>
> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> >> index 1f980ef..b2c277d 100644
> >> --- a/fs/btrfs/inode.c
> >> +++ b/fs/btrfs/inode.c
> >> @@ -7237,7 +7237,6 @@ static struct extent_map
> >> *btrfs_create_dio_extent(struct inode *inode,
> >>         struct extent_map *em = NULL;
> >>         int ret;
> >>
> >> -       down_read(&BTRFS_I(inode)->dio_sem);
> >>         if (type != BTRFS_ORDERED_NOCOW) {
> >>                 em = create_pinned_em(inode, start, len, orig_start,
> >>                                       block_start, block_len, orig_block_len,
> >> @@ -7256,8 +7255,6 @@ static struct extent_map
> >> *btrfs_create_dio_extent(struct inode *inode,
> >>                 em = ERR_PTR(ret);
> >>         }
> >>   out:
> >> -       up_read(&BTRFS_I(inode)->dio_sem);
> >> -
> >>         return em;
> >>  }
> >>
> >> @@ -8715,11 +8712,14 @@ static ssize_t btrfs_direct_IO(struct kiocb
> >> *iocb, struct iov_iter *iter)
> >>                 wakeup = false;
> >>         }
> >>
> >> +       if (iov_iter_rw(iter) == WRITE)
> >> +               down_read(&BTRFS_I(inode)->dio_sem);
> >>         ret = __blockdev_direct_IO(iocb, inode,
> >>
> >> BTRFS_I(inode)->root->fs_info->fs_devices->latest_bdev,
> >>                                    iter, btrfs_get_blocks_direct, NULL,
> >>                                    btrfs_submit_direct, flags);
> >>         if (iov_iter_rw(iter) == WRITE) {
> >> +               up_read(&BTRFS_I(inode)->dio_sem);
> >>                 current->journal_info = NULL;
> >>                 if (ret < 0 && ret != -EIOCBQUEUED) {
> >>                         if (dio_data.reserve)
> >>
> >>
> >> Let me know what you think. Thanks.
> >
> > Hi Filipe,
> >
> > After going over again fs/direct-io.c, the AIO dio_complete is diffrent from the
> > 'Note that' part in your patch [1], what am I missing?
> >
> > -------------------------------------------------------------------------
> > static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
> > {
> >         ...
> >         if (!(dio->flags & DIO_SKIP_DIO_COUNT))
> >                 inode_dio_end(dio->inode);
> >
> >         if (is_async) {
> >                 /*
> >                  * generic_write_sync expects ki_pos to have been updated
> >                  * already, but the submission path only does this for
> >                  * synchronous I/O.
> >                  */
> >                 dio->iocb->ki_pos += transferred;
> >
> >                 if (dio->op == REQ_OP_WRITE)
> >                         ret = generic_write_sync(dio->iocb,  transferred);
> >                 dio->iocb->ki_complete(dio->iocb, ret, 0);
> >         }
> >         ...
> > }
> 
> It's still the same as when I checked. The problem is that even after
> that call to inode_dio_end(), the inode->i_dio_count() is still
> non-zero (it's 1 iirc).
> I don't have any longer the debugging patch I used to find out that
> out (nor remember all the details), but I just tried again the
> approach of calling inode_dio_wait() in btrfs_sync_file() after
> locking the inode:
> 
> https://friendpaste.com/pRwJkgsFXv6HglftK1BqH
> 
> And the same deadlock ends up happening, which is trivial to reproduce
> with fstest generic/113:
> 
...
> I don't have the time to go now figure out all the details of the aio
> code path again as I'm on vacation. But it's pretty evident that that
> solution doesn't work unfortunately.

All right...I've got the deadlock under space pressure, i.e. run
generic/113 with '-o fragment=data'.

I was not able to reproduce the deadlock with generic/113 after applying
'inode_dio_wait' in fsync, but I agree on not using 'inode_dio_wait'
approach because dio reads also contribute to inode->i_dio_count.

With the above patch that acquires the semaphore at a higher level
in direct IO write path, the deadlock now has gone away.

So would you please make a single patch? (It's also a good candidate
for stable kernel.)

Thanks,

-liubo
