Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:53182 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273Ab3DXNAT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 09:00:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D818C7C0643
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 07:00:18 -0600 (MDT)
Date: Wed, 24 Apr 2013 09:00:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: only exclude supers in the range of our block
 group V2
Message-ID: <20130424130016.GE2631@localhost.localdomain>
References: <1366742934-4214-1-git-send-email-jbacik@fusionio.com>
 <20130424085739.GG19283@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130424085739.GG19283@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 24, 2013 at 02:57:40AM -0600, Liu Bo wrote:
> On Tue, Apr 23, 2013 at 02:48:54PM -0400, Josef Bacik wrote:
> > If we fail to load block groups halfway through we can leave extent_state's on
> > the excluded tree.  This is because we just lookup the supers and add them to
> > the excluded tree regardless of which block group we are looking at currently.
> > This is a problem because we remove the excluded extents for the range of the
> > block group only, so if we don't ever load a block group for one of the excluded
> > extents we won't ever free it.  This fixes the problem by only adding excluded
> > extents if it falls in the block group range we care about.  With this patch
> > we're no longer leaking space when we fail to read all of the block groups.
> > Thanks,
> > 
> > Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> > ---
> > V1->V2: fixed a slight problem where i should have been comparing to the end of
> > hte block group not the begining.
> > 
> >  fs/btrfs/extent-tree.c |   24 +++++++++++++++++++++---
> >  1 files changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index b441be3..a81f689 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -270,9 +270,27 @@ static int exclude_super_stripes(struct btrfs_root *root,
> >  			return ret;
> >  
> >  		while (nr--) {
> > -			cache->bytes_super += stripe_len;
> > -			ret = add_excluded_extent(root, logical[nr],
> > -						  stripe_len);
> > +			u64 start, len;
> > +
> > +			if (logical[nr] > cache->key.objectid +
> > +			    cache->key.offset)
> > +				continue;
> > +
> > +			if (logical[nr] + stripe_len <= cache->key.objectid)
> > +				continue;
> 
> hmm...I just doubt that these two cases can happen.
> 
> btrfs_rmap_block() ensures that logical[nr] will be larger than
> cache->key.objectid.
> 
> Am I missing something?

Yeah, we can still get ranges that are past the end of the cache, just put a
printk in there and you'll see it happen.  Now it's not likely that a logical
will be less than the start but better safe than sorry.  Thanks,

Josef
