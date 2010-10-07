From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: add support for mixed data+metadata block
	groups V2
Date: Thu, 7 Oct 2010 07:27:32 -0400
Message-ID: <20101007112732.GC12383@dhcp231-156.rdu.redhat.com>
References: <1286396497-30027-1-git-send-email-josef@redhat.com> <1286439050.3341.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: Ian Kent <raven@themaw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1286439050.3341.34.camel@localhost>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 07, 2010 at 04:10:50PM +0800, Ian Kent wrote:
> On Wed, 2010-10-06 at 16:21 -0400, Josef Bacik wrote:
> > There are just a few things that need to be fixed in the kernel to support mixed
> > data+metadata block groups.  Mostly we just need to make sure that if we are
> > using mixed block groups that we continue to allocate mixed block groups as we
> > need them.  Also we need to make sure __find_space_info will find our space info
> > if we search for DATA or METADATA only.  Tested this with xfstests and it works
> > nicely.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> > V1->V2: In do_chunk_alloc I was changing flags to == space_info->flags, which
> > isn't right since space_info doesn't carry the RAID profiles anymore, so instead
> > check to see if the space info has DATA and METADATA set and if so set that in
> > the flags as well.
> > 
> >  fs/btrfs/extent-tree.c |   26 +++++++++++++++++++++++---
> >  1 files changed, 23 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index 91a0a41..27eddb3 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -547,7 +547,7 @@ static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
> >  
> >  	rcu_read_lock();
> >  	list_for_each_entry_rcu(found, head, list) {
> > -		if (found->flags == flags) {
> > +		if (found->flags & flags) {
> >  			rcu_read_unlock();
> >  			return found;
> >  		}
> > @@ -3267,6 +3267,15 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
> >  	spin_unlock(&space_info->lock);
> >  
> >  	/*
> > +	 * If we have mixed data/metadata chunks we want to make sure we keep
> > +	 * allocating mixed chunks instead of individual chunks.
> > +	 */
> > +	if ((space_info->flags & (BTRFS_BLOCK_GROUP_DATA |
> > +				  BTRFS_BLOCK_GROUP_METADATA)) ==
> > +	    (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA))
> > +		flags |= (BTRFS_BLOCK_GROUP_DATA | BTRFS_BLOCK_GROUP_METADATA);
> 
> This sort of construct appears a few times.
> Personally, I prefer a macroish (read 'inline function') construct,
> perhaps with a longish name if needed, than multiple line breaks within
> a logical expression. IMHO, having multiple line breaks makes the code
> somewhat harder to read.
>

Agreed I thought of that after I hit send.  I'll clean this up and resend,
thanks,

Josef
