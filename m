Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:26736 "EHLO
	aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbcCUUlh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 16:41:37 -0400
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
	by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id u2LJ8cZS000476
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 19:08:39 GMT
Date: Mon, 21 Mar 2016 12:10:46 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Roman Mamedov <rm@romanrm.net>,
        Holger =?iso-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix performance regression of writing to
 prealloc/nocow file
Message-ID: <20160321191046.GA1111@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1458252975-1349-1-git-send-email-bo.li.liu@oracle.com>
 <20160318174403.273da4f2@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160318174403.273da4f2@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Fri, Mar 18, 2016 at 05:44:03PM +0500, Roman Mamedov wrote:
> On Thu, 17 Mar 2016 15:16:15 -0700
> Liu Bo <bo.li.liu@oracle.com> wrote:
> 
> > For nocow/prealloc files, we try our best to not allocate space, however,
> > this ends up a huge performance regression since it's expensive to check
> > if data is shared.
> > 
> > Let's go back to only go check shared data once we're not able to allocate
> > space.
> 
> As mentioned by Holger there's another patch modifying the same function:
> https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/fs/btrfs?h=integration-4.6&id=4da2e26a2a32b174878744bd0f07db180c875f26
> and that one fixes a serious regression in the 4.4 series.
> I did not try yours, but could you please ensure that you do not hit the
> described problem with your version of the patch, or perhaps even better,
> consider re-testing performance and then basing any further performance
> optimizations upon a state with no known grave functionality bugs (i.e. with
> the above patch applied).

I've verified with the above test that my patch doesn't introduce a
regression although there're some patch conflicts to deal with.

In fact they're fixing two different problems.

Zhao's patch is fixing the incorrect behavior of parsing error caused by
creating snapshots, while my patch is to go back to reserving space for
nocow/prealloc writes unless we've run out of space.

Thanks,

-liubo
> 
> Thanks
> 
> > The test was made against a tmpfs backed loop device:
> > 
> > xfs_io -f -c "falloc 0 400M" foobar
> > xfs_io -c "pwrite -W -b 4096 0 400M" foobar
> > 
> > Vanilla:
> > wrote 419430400/419430400 bytes at offset 0
> > 400 MiB, 102400 ops; 0:00:01.00 (200.015 MiB/sec and 51203.8403 ops/sec)
> > 
> > Patched kernel:
> > wrote 419430400/419430400 bytes at offset 0
> > 400 MiB, 102400 ops; 0:00:01.00 (346.137 MiB/sec and 88610.9796 ops/sec)
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/file.c | 17 ++++++++---------
> >  1 file changed, 8 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > index 098bb8f..f66c1bc 100644
> > --- a/fs/btrfs/file.c
> > +++ b/fs/btrfs/file.c
> > @@ -1525,16 +1525,12 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
> >  
> >  		reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> >  
> > -		if (BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> > -					     BTRFS_INODE_PREALLOC)) {
> > +		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
> > +		if (ret == -ENOSPC &&
> > +		    BTRFS_I(inode)->flags & (BTRFS_INODE_NODATACOW |
> > +						     BTRFS_INODE_PREALLOC)) {
> >  			ret = check_can_nocow(inode, pos, &write_bytes);
> > -			if (ret < 0)
> > -				break;
> >  			if (ret > 0) {
> > -				/*
> > -				 * For nodata cow case, no need to reserve
> > -				 * data space.
> > -				 */
> >  				only_release_metadata = true;
> >  				/*
> >  				 * our prealloc extent may be smaller than
> > @@ -1543,10 +1539,13 @@ static noinline ssize_t __btrfs_buffered_write(struct file *file,
> >  				num_pages = DIV_ROUND_UP(write_bytes + offset,
> >  							 PAGE_CACHE_SIZE);
> >  				reserve_bytes = num_pages << PAGE_CACHE_SHIFT;
> > +
> > +				ret = 0;
> >  				goto reserve_metadata;
> > +			} else {
> > +				ret = -ENOSPC;
> >  			}
> >  		}
> > -		ret = btrfs_check_data_free_space(inode, pos, write_bytes);
> >  		if (ret < 0)
> >  			break;
> >  
> 
> 
> -- 
> With respect,
> Roman


