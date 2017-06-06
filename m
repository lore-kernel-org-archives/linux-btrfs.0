Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f49.google.com ([74.125.83.49]:35486 "EHLO
        mail-pg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751437AbdFFXrH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 19:47:07 -0400
Received: by mail-pg0-f49.google.com with SMTP id k71so6836880pgd.2
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Jun 2017 16:47:07 -0700 (PDT)
Date: Tue, 6 Jun 2017 16:47:05 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip commit transaction if we don't have enough
 pinned bytes
Message-ID: <20170606234705.GA31692@vader.DHCP.thefacebook.com>
References: <20170519173915.29846-1-bo.li.liu@oracle.com>
 <20170602181413.GA20531@vader.DHCP.thefacebook.com>
 <20170606042946.GF4847@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606042946.GF4847@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 05, 2017 at 09:29:47PM -0700, Liu Bo wrote:
> On Fri, Jun 02, 2017 at 11:14:13AM -0700, Omar Sandoval wrote:
> > On Fri, May 19, 2017 at 11:39:15AM -0600, Liu Bo wrote:
> > > We commit transaction in order to reclaim space from pinned bytes because
> > > it could process delayed refs, and in may_commit_transaction(), we check
> > > first if pinned bytes are enough for the required space, we then check if
> > > that plus bytes reserved for delayed insert are enough for the required
> > > space.
> > > 
> > > This changes the code to the above logic.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > ---
> > >  fs/btrfs/extent-tree.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > > index e390451c72e6..bded1ddd1bb6 100644
> > > --- a/fs/btrfs/extent-tree.c
> > > +++ b/fs/btrfs/extent-tree.c
> > > @@ -4837,7 +4837,7 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> > >  
> > >  	spin_lock(&delayed_rsv->lock);
> > >  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> > > -				   bytes - delayed_rsv->size) >= 0) {
> > > +				   bytes - delayed_rsv->size) < 0) {
> > >  		spin_unlock(&delayed_rsv->lock);
> > >  		return -ENOSPC;
> > >  	}
> > 
> > I found this bug in my latest enospc investigation, too. However, the
> > total_bytes_pinned counter is pretty broken. E.g., on my laptop:
> > 
> > $ sync; grep -H '' /sys/fs/btrfs/*/allocation/*/total_bytes_pinned
> > /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/data/total_bytes_pinned:48693501952
> > /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/metadata/total_bytes_pinned:-258146304
> > /sys/fs/btrfs/f31cc926-37d3-442d-b50a-10c62d47badc/allocation/system/total_bytes_pinned:0
> > 
> > I have a patch to fix it that I haven't cleaned up yet, below. Without
> > it, Bo's fix will probably cause early ENOSPCs. Dave, should we pull
> > Bo's patch out of for-next? In any case, I'll get my fix sent out.
> >
> 
> When data delayed refs are not merged, __btrfs_free_extent() will dec
> the pinned as expected, but when they got merged, %pinned bytes only
> got inc'd but not dec'd because the delayed ref has been deleted due
> to ref_count == 0.
> 
> This doesn't happen to tree block ref since tree block ref doesn't
> have more than one ref, so ref_mod is either 1 or -1, and tree block
> ref gets removed via btrfs_free_tree_block(), which also needs to be
> changed.
> 
> Based on that, I think we can solve the problem by touching
> btrfs_free_tree_block() and data delayed ref instead of head ref.
> 
> thanks,
> -liubo

I just sent out the fixes split up into separate patches, so hopefully
the different bugs should be more clear.
