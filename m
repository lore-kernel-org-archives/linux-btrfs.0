Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:53209 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751443AbcJZPuG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Oct 2016 11:50:06 -0400
Date: Wed, 26 Oct 2016 11:49:19 -0400
From: Tejun Heo <htejun@fb.com>
To: Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>, <david@fromorbit.com>,
        <jack@suse.cz>, <linux-fsdevel@vger.kernel.org>,
        <viro@zeniv.linux.org.uk>, <hch@infradead.org>, <jweiner@fb.com>
Subject: Re: [PATCH 3/5] writeback: add counters for metadata usage
Message-ID: <20161026154919.GA26329@htj.duckdns.org>
References: <1477420904-1399-1-git-send-email-jbacik@fb.com>
 <1477420904-1399-4-git-send-email-jbacik@fb.com>
 <20161025195037.GC13857@htj.duckdns.org>
 <3578d0de-b971-8405-8e7a-71b79a7f9850@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <3578d0de-b971-8405-8e7a-71b79a7f9850@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, Josef.

On Wed, Oct 26, 2016 at 11:20:16AM -0400, Josef Bacik wrote:
> > > @@ -3701,7 +3703,20 @@ static unsigned long node_pagecache_reclaimable(struct pglist_data *pgdat)
> > >  	if (unlikely(delta > nr_pagecache_reclaimable))
> > >  		delta = nr_pagecache_reclaimable;
> > > 
> > > -	return nr_pagecache_reclaimable - delta;
> > > +	nr_metadata_reclaimable =
> > > +		node_page_state(pgdat, NR_METADATA_BYTES) >> PAGE_SHIFT;
> > > +	/*
> > > +	 * We don't do writeout through the shrinkers so subtract any
> > > +	 * dirty/writeback metadata bytes from the reclaimable count.
> > > +	 */
> > 
> > Hmm... up until this point, the dirty metadata was handled the same
> > way as regular dirty data but it deviates here.  Is this right?  The
> > calculations in writeback code also assumes that the dirty pages are
> > reclaimable.  If this is inherently different, it'd be nice to explain
> > more explicitly why this is different from others.
> 
> So there is logic above this that subtracts out the NR_FILE_DIRTY from the
> file reclaimable if we can't do write's during reclaim.  Since we can always
> wait on writeback during reclaim it doesn't subtract out writeback.  I took
> this to mean that the general expectation of this function is to only count
> thing things that the shrinker can specifically reclaim itself, so I
> discounted anything under io since the slab shrinkers have no idea if its ok
> to write or not and so in the case of btrfs simply skip anything that is
> dirty or under writeback.  Does that make sense?  I'll fix up the other
> issues you pointed out.  Thanks,

Yeap, that makes sense to me.

Thanks for the explanation.

-- 
tejun
