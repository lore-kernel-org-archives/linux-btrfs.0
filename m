Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37754 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750750AbdALWRK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Jan 2017 17:17:10 -0500
Date: Thu, 12 Jan 2017 14:24:27 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>, Anand.Jain.anand.jain@oracle.com
Subject: Re: [PATCH] Btrfs: adjust outstanding_extents counter properly when
 dio write is split
Message-ID: <20170112222427.GD24433@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1482455634-9185-1-git-send-email-bo.li.liu@oracle.com>
 <CAL3q7H5LxEARAm0Gg5eKCNAtKKr-F-79c1PUE5ng4Xb3LFGD4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5LxEARAm0Gg5eKCNAtKKr-F-79c1PUE5ng4Xb3LFGD4w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 06, 2017 at 11:28:06AM +0000, Filipe Manana wrote:
> On Fri, Dec 23, 2016 at 1:13 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > Currently how btrfs dio deals with split dio write is not good
> > enough if dio write is split into several segments due to the
> > lack of contiguous space, a large dio write like 'dd bs=1G count=1'
> > can end up with incorrect outstanding_extents counter and endio
> > would complain loudly with an assertion.
> >
> > This fixes the problem by compensating the outstanding_extents
> > counter in inode if a large dio write gets split.
> >
> > Reported-by: Anand Jain <anand.jain@oracle.com>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> 
> Bo, can you please create a test case for fstests?

It took me some time to recall all the details, anyway, I've sent out a
fstests case for it[1].

[1]: https://patchwork.kernel.org/patch/9514277/
Thanks,

-liubo

> 
> Thanks
> 
> > ---
> >  fs/btrfs/inode.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index a4c8796..4175987 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7641,11 +7641,18 @@ static void adjust_dio_outstanding_extents(struct inode *inode,
> >          * within our reservation, otherwise we need to adjust our inode
> >          * counter appropriately.
> >          */
> > -       if (dio_data->outstanding_extents) {
> > +       if (dio_data->outstanding_extents >= num_extents) {
> >                 dio_data->outstanding_extents -= num_extents;
> >         } else {
> > +               /*
> > +                * If dio write length has been split due to no large enough
> > +                * contiguous space, we need to compensate our inode counter
> > +                * appropriately.
> > +                */
> > +               u64 num_needed = num_extents - dio_data->outstanding_extents;
> > +
> >                 spin_lock(&BTRFS_I(inode)->lock);
> > -               BTRFS_I(inode)->outstanding_extents += num_extents;
> > +               BTRFS_I(inode)->outstanding_extents += num_needed;
> >                 spin_unlock(&BTRFS_I(inode)->lock);
> >         }
> >  }
> > --
> > 2.5.5
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "People will forget what you said,
>  people will forget what you did,
>  but people will never forget how you made them feel."
