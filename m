Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40050 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762001AbdAKQQ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Jan 2017 11:16:59 -0500
Date: Wed, 11 Jan 2017 17:16:56 +0100
From: Michal Hocko <mhocko@kernel.org>
To: David Sterba <dsterba@suse.cz>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] etrfs: fix up misleading GFP_NOFS usage in
 btrfs_releasepage
Message-ID: <20170111161655.GF16365@dhcp22.suse.cz>
References: <20170109143903.32280-1-mhocko@kernel.org>
 <20170111135550.GJ12081@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170111135550.GJ12081@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 11-01-17 14:55:50, David Sterba wrote:
> On Mon, Jan 09, 2017 at 03:39:02PM +0100, Michal Hocko wrote:
> > From: Michal Hocko <mhocko@suse.com>
> > 
> > b335b0034e25 ("Btrfs: Avoid using __GFP_HIGHMEM with slab allocator")
> > has reduced the allocation mask in btrfs_releasepage to GFP_NOFS just
> > to prevent from giving an unappropriate gfp mask to the slab allocator
> > deeper down the callchain (in alloc_extent_state). This is wrong for
> > two reasons a) GFP_NOFS might be just too restrictive for the calling
> > context b) it is better to tweak the gfp mask down when it needs that.
> > 
> > So just remove the mask tweaking from btrfs_releasepage and move it
> > down to alloc_extent_state where it is needed.
> > 
> > Signed-off-by: Michal Hocko <mhocko@suse.com>
> > ---
> >  fs/btrfs/extent_io.c | 5 +++++
> >  fs/btrfs/inode.c     | 2 +-
> >  2 files changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> > index b38150eec6b4..f6ae94a4acad 100644
> > --- a/fs/btrfs/extent_io.c
> > +++ b/fs/btrfs/extent_io.c
> > @@ -226,6 +226,11 @@ static struct extent_state *alloc_extent_state(gfp_t mask)
> >  {
> >  	struct extent_state *state;
> >  
> > +	/*
> > +	 * The given mask might be not appropriate for the slab allocator,
> > +	 * drop the unsupported bits
> > +	 */
> > +	mask &= ~(__GFP_DMA32|__GFP_HIGHMEM);
> 
> Is this future proof enough? As it's enumerating some gfp flags, what if
> more are necessary in the future? I'm interested about some synthetic
> gfp flags that would not require knowledge about what is or is not
> acceptable for slab allocator.

Well, I agree, that something like slab_restrict_gfp_mask(gfp_t gfp_mask)
would be much better. And in fact that sounds like a nice future
cleanup. I haven't checked how many users would find it useful yet but I
am putting that on my todo list.

> But otherwise looks ok to me, I'm going to merge the patch. Thanks.

Thanks!

-- 
Michal Hocko
SUSE Labs
