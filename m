Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1050.oracle.com ([141.146.126.70]:40568 "EHLO
        aserp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbdCGT6v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 14:58:51 -0500
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
        by aserp1050.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v27JwF5c022986
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-btrfs@vger.kernel.org>; Tue, 7 Mar 2017 19:58:15 GMT
Date: Tue, 7 Mar 2017 11:55:11 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] Btrfs: fix regression in lock_delalloc_pages
Message-ID: <20170307195510.GB12408@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1488853256-10867-1-git-send-email-bo.li.liu@oracle.com>
 <da692faa-b89c-9740-b599-2d0f7284cc1c@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <da692faa-b89c-9740-b599-2d0f7284cc1c@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 07, 2017 at 01:54:31PM +0800, Qu Wenruo wrote:
> 
> 
> At 03/07/2017 10:20 AM, Liu Bo wrote:
> > The bug is a regression after commit
> > (da2c7009f6ca "btrfs: teach __process_pages_contig about PAGE_LOCK operation")
> > and commit
> > (76c0021db8fd "Btrfs: use helper to simplify lock/unlock pages").
> > 
> > So if the dirty pages which are under writeback got truncated partially
> > before we lock the dirty pages, we couldn't find all pages mapping to the
> > delalloc range, and the bug didn't return an error so it kept going on and
> > found that the delalloc range got truncated and got to unlock the dirty
> > pages, and then the ASSERT could caught the error, and showed
> > 
> > -----------------------------------------------------------------------------
> > assertion failed: page_ops & PAGE_LOCK, file: fs/btrfs/extent_io.c, line: 1716
> > -----------------------------------------------------------------------------
> 
> We also triggered such bug when running xfstests btrfs/070, although
> possibility is somewhat low.
> 
> However since it's more about possibility, any fsstress may trigger it
> though.
>

Yes, I think buffer writes with O_SYNC and some concurrent truncate
could get us to ASSERT.

Thanks,

-liubo

> Thanks,
> Qu
> 
> > 
> > This fixes the bug by returning the proper -EAGAIN.
> > 
> > Cc: David Sterba <dsterba@suse.com>
> > Reported-by: Dave Jones <davej@codemonkey.org.uk>
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent_io.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index 28e8192..8df7974 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -1714,7 +1714,8 @@ static int __process_pages_contig(struct address_space *mapping,
> >  			 * can we find nothing at @index.
> >  			 */
> >  			ASSERT(page_ops & PAGE_LOCK);
> > -			return ret;
> > +			err = -EAGAIN;
> > +			goto out;
> >  		}
> > 
> >  		for (i = 0; i < ret; i++) {
> > 
> 
> 
