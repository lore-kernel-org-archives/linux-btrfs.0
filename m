Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32711 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdESSfA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 19 May 2017 14:35:00 -0400
Date: Fri, 19 May 2017 11:32:14 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, jeffm@suse.com
Subject: Re: btrfs metadata reclaim behavior/performance characteristics
Message-ID: <20170519183214.GB10137@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <dc9f3787-767b-6710-9694-9eb02aa07728@suse.com>
 <20170518144532.GA28854@lim.localdomain>
 <a9c76afa-a18a-36e2-b3e8-a66bce9a0c3f@suse.com>
 <20170518214724.GA10554@lim.localdomain>
 <7a698730-6f67-b158-c172-0a74a291277f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7a698730-6f67-b158-c172-0a74a291277f@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 12:54:59PM +0300, Nikolay Borisov wrote:
> > From: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Subject: [PATCH] Btrfs: skip commit transaction if we don't have enough pinned bytes
> > 
> > We commit transaction in order to reclaim space from pinned bytes because it could process delayed refs, and in may_commit_transaction(), we check first if pinned bytes are enough for the required space, we then check if that plus bytes reserved for delayed insert are enough for the required space.
> > 
> > This changes the code to the above logic.
> > 
> > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > ---
> >  fs/btrfs/extent-tree.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index e390451c72e6..bded1ddd1bb6 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> >  
> > 	spin_lock(&delayed_rsv->lock);
> >  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> > -			   bytes - delayed_rsv->size) >= 0) {
> > +			   	   		         bytes - delayed_rsv->size) < 0) {
> >  							       spin_unlock(&delayed_rsv->lock);
> > 								return -ENOSPC;
> >  								}
> > 
> 
> Your patch does make a very big difference. Here are a couple of runs of
> slow-rm:
> 
> 
> 
> root@ubuntu-virtual:~# ./slow-rm.sh
> Created 837 files before returning error, time taken 3
> Created 920 files before returning error, time taken 3
> Created 949 files before returning error, time taken 3
> Created 930 files before returning error, time taken 3
> Created 1101 files before returning error, time taken 4
> Created 1082 files before returning error, time taken 4
> Created 1608 files before returning error, time taken 5
> Created 1735 files before returning error, time taken 5
> rming took 1 seconds
> 
> root@ubuntu-virtual:~# ./slow-rm.sh
> Created 801 files before returning error, time taken 3
> Created 829 files before returning error, time taken 3
> Created 983 files before returning error, time taken 3
> Created 978 files before returning error, time taken 3
> Created 1023 files before returning error, time taken 3
> Created 1126 files before returning error, time taken 3
> Created 1538 files before returning error, time taken 4
> Created 1737 files before returning error, time taken 5
> rming took 2 seconds
> 
> root@ubuntu-virtual:~# ./slow-rm.sh
> Created 875 files before returning error, time taken 3
> Created 891 files before returning error, time taken 3
> Created 969 files before returning error, time taken 4
> Created 1002 files before returning error, time taken 4
> Created 1039 files before returning error, time taken 4
> Created 1051 files before returning error, time taken 4
> Created 1191 files before returning error, time taken 4
> Created 2137 files before returning error, time taken 8
> rming took 2 seconds
> 
> So rming is a lot faster, but we create less files all in all and get
> ENOSPC earlier. This means that most of the time bytes_pinned is not
> enough to satisfy the allocation hence we are hitting the second
> percpu_counter comparison.
>

Right, it's sort of my expected bahavior because all 1K buffered IO ends up
being inline extent, it's likely to run out of metadata space very soon.

> Also, the reason why the previous links showed 0 for bytes_pinned was
> due to me having completely forgotten that bytes_pinned is a percpu
> counter, hence my stap script wasn't actually reading it correctly.

I see, bytes_pinned in space_info is different from the percpu one, they're
updated at different time, but overall the percpu one is the the preciser
counter.

-liubo
