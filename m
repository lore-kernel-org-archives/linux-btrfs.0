From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: avoid taking the chunk_mutex in do_chunk_alloc
Date: Tue, 12 Apr 2011 08:42:39 -0400
Message-ID: <20110412124239.GB26337@dhcp231-156.rdu.redhat.com>
References: <1302568224-4567-1-git-send-email-josef@redhat.com> <4DA3ABCF.4060405@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: liubo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DA3ABCF.4060405@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 12, 2011 at 09:33:03AM +0800, liubo wrote:
> On 04/12/2011 08:30 AM, Josef Bacik wrote:
> > Everytime we try to allocate disk space we try and see if we can pre-emptively
> > allocate a chunk, but in the common case we don't allocate anything, so there is
> > no sense in taking the chunk_mutex at all.  So instead if we are allocating a
> > chunk, mark it in the space_info so we don't get two people trying to allocate
> > at the same time.  Thanks,
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/btrfs/ctree.h       |    5 +++--
> >  fs/btrfs/extent-tree.c |   24 ++++++++++++++++++++++--
> >  2 files changed, 25 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> > index 0d00a07..a566780 100644
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > @@ -740,10 +740,11 @@ struct btrfs_space_info {
> >  	 */
> >  	unsigned long reservation_progress;
> >  
> > -	int full;		/* indicates that we cannot allocate any more
> > +	int full:1;		/* indicates that we cannot allocate any more
> >  				   chunks for this space */
> > -	int force_alloc;	/* set if we need to force a chunk alloc for
> > +	int force_alloc:1;	/* set if we need to force a chunk alloc for
> >  				   this space */
> > +	int chunk_alloc:1;	/* set if we are allocating a chunk */
> >  
> >  	struct list_head list;
> >  
> > diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> > index f619c3c..80c048f 100644
> > --- a/fs/btrfs/extent-tree.c
> > +++ b/fs/btrfs/extent-tree.c
> > @@ -3020,6 +3020,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
> >  	found->bytes_may_use = 0;
> >  	found->full = 0;
> >  	found->force_alloc = 0;
> > +	found->chunk_alloc = 0;
> >  	*space_info = found;
> >  	list_add_rcu(&found->list, &info->space_info);
> >  	atomic_set(&found->caching_threads, 0);
> > @@ -3273,10 +3274,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
> >  {
> >  	struct btrfs_space_info *space_info;
> >  	struct btrfs_fs_info *fs_info = extent_root->fs_info;
> > +	int wait_for_alloc = 0;
> >  	int ret = 0;
> >  
> > -	mutex_lock(&fs_info->chunk_mutex);
> > -
> >  	flags = btrfs_reduce_alloc_profile(extent_root, flags);
> >  
> >  	space_info = __find_space_info(extent_root->fs_info, flags);
> > @@ -3287,6 +3287,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
> >  	}
> >  	BUG_ON(!space_info);
> >  
> > +again:
> >  	spin_lock(&space_info->lock);
> >  	if (space_info->force_alloc)
> >  		force = 1;
> > @@ -3299,9 +3300,27 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
> >  					  alloc_bytes)) {
> >  		spin_unlock(&space_info->lock);
> >  		goto out;
> 
> hmm, the "goto" will lead to problems, cause in "out" clause there is a mutex_unlock(), which
> we do not have a mutex_lock yet.
>

Hrm I wonder why xfstests didn't trip over that, thats what I get for patching
while watching the kid.  Thanks,

Josef 
