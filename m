Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29692 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752672AbdDJSdK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 14:33:10 -0400
Date: Mon, 10 Apr 2017 11:32:02 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <n.borisov.lkml@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix segment fault when doing dio read
Message-ID: <20170410183202.GB15214@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1491595870-9633-1-git-send-email-bo.li.liu@oracle.com>
 <5afa50b0-2e6c-d3fa-4dd8-dedbdf1af8b4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5afa50b0-2e6c-d3fa-4dd8-dedbdf1af8b4@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Apr 09, 2017 at 08:08:05PM +0300, Nikolay Borisov wrote:
> 
> 
> On  7.04.2017 23:11, Liu Bo wrote:
> > Commit 2dabb3248453 ("Btrfs: Direct I/O read: Work on sectorsized blocks")
> > introduced this bug during iterating bio pages in dio read's endio hook,
> > and it could end up with segment fault of the dio reading task.
> > 
> > So the reason is 'if (nr_sectors--)', and it makes the code assume that
> > there is one more block in the same page, so page offset is increased and
> > the bio which is created to repair the bad block then has an incorrect
> > bvec.bv_offset, and a later access of the page content would throw a
> > segment fault.
> > 
> > This also adds ASSERT to check page offset against page size.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/inode.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index c875e68..5e71f1e 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7972,8 +7972,10 @@ static int __btrfs_correct_data_nocsum(struct inode *inode,
> >  
> >  		start += sectorsize;
> >  
> > -		if (nr_sectors--) {
> > +		nr_sectors--;
> Why not if(--nr_sectors)? I know it's more of a style issue but it will
> reduce the size of the diff ?

It's error-prone, as shown by how the bug in the original commit was introduced.

Thanks,

-liubo

> > +		if (nr_sectors) {
> >  			pgoff += sectorsize;
> > +			ASSERT(pgoff < PAGE_SIZE);
> >  			goto next_block_or_try_again;
> >  		}
> >  	}
> > @@ -8074,8 +8076,10 @@ static int __btrfs_subio_endio_read(struct inode *inode,
> >  
> >  		ASSERT(nr_sectors);
> >  
> > -		if (--nr_sectors) {
> > +		nr_sectors--;
> > +		if (nr_sectors) {
> >  			pgoff += sectorsize;
> > +			ASSERT(pgoff < PAGE_SIZE);
> >  			goto next_block;
> >  		}
> >  	}
>
