Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46318 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946506AbdEZB3K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 21:29:10 -0400
Date: Thu, 25 May 2017 18:26:29 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: skip commit transaction if we don't have enough
 pinned bytes
Message-ID: <20170526012628.GA10204@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170519173915.29846-1-bo.li.liu@oracle.com>
 <2d7827f3-9e67-d2e7-fbe0-8c9c2a921350@suse.com>
 <20170525165048.GG4065@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525165048.GG4065@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 06:50:48PM +0200, David Sterba wrote:
> On Tue, May 23, 2017 at 12:06:40PM +0300, Nikolay Borisov wrote:
> > 
> > 
> > On 19.05.2017 20:39, Liu Bo wrote:
> > > We commit transaction in order to reclaim space from pinned bytes because
> > > it could process delayed refs, and in may_commit_transaction(), we check
> > > first if pinned bytes are enough for the required space, we then check if
> > > that plus bytes reserved for delayed insert are enough for the required
> > > space.
> > > 
> > > This changes the code to the above logic.
> > > 
> > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > 
> > Please add:
> > Fixes: b150a4f10d87 ("Btrfs: use a percpu to keep track of possibly
> > pinned bytes")
> > 
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
> > > 
> > 
> > With the minor nit above:
> > 
> > Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> > Tested-by: Nikolay Borisov <nborisov@suse.com>
> 
> Patch applied with updated tags.

Thank you for that!

-liubo
