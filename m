Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27803 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3AHCth (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jan 2013 21:49:37 -0500
Date: Tue, 8 Jan 2013 10:46:38 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix off-by-one in lseek
Message-ID: <20130108024637.GA1916@liubo>
Reply-To: bo.li.liu@oracle.com
References: <1357530788-5790-1-git-send-email-bo.li.liu@oracle.com>
 <20130107162050.GJ20089@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130107162050.GJ20089@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 07, 2013 at 05:20:50PM +0100, David Sterba wrote:
> On Mon, Jan 07, 2013 at 11:53:08AM +0800, Liu Bo wrote:
> > Lock end is inclusive.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/file.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 77061bf..1e16b6d 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -2241,6 +2241,7 @@ static int find_desired_extent(struct inode *inode, loff_t *offset, int whence)
> >  	if (lockend <= lockstart)
> >  		lockend = lockstart + root->sectorsize;
> >  
> > +	lockend--;
> >  	len = lockend - lockstart + 1;
> >  
> >  	len = max_t(u64, len, root->sectorsize);
> 
> Fix looks ok. I think this should be caught at runtime as well, the
> number of ways how the lock start and end are passed is not small and it
> need not be always possible to catch it from reading sources. The range
> is inclusive, so it's 'lock end % 2 == 1' right? (in the bit
> manipulating primitives).

Hmm, not always here, lockend = inode->i_size - 1, so lockend % 2 == 1 may not
be true.

But this check can worked in those places where we've rounded the range up to
PAGE_SIZE :)

thanks,
liubo
