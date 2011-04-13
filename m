From: liubo <liubo2009@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs: avoid taking the chunk_mutex in do_chunk_alloc
 V2
Date: Wed, 13 Apr 2011 09:19:39 +0800
Message-ID: <4DA4FA2B.7060704@cn.fujitsu.com>
References: <1302612902-14113-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302612902-14113-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/12/2011 08:55 PM, Josef Bacik wrote:
> Everytime we try to allocate disk space we try and see if we can pre-emptively
> allocate a chunk, but in the common case we don't allocate anything, so there is
> no sense in taking the chunk_mutex at all.  So instead if we are allocating a
> chunk, mark it in the space_info so we don't get two people trying to allocate
> at the same time.  Thanks,
> 

Reviewed-by: Liu Bo <liubo2009@cn.fujitsu.com>

> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
> V1->V2: Return in the case where we don't need to allocate a chunk instead of
> going to out.
> 
>  fs/btrfs/ctree.h       |    5 +++--
>  fs/btrfs/extent-tree.c |   29 ++++++++++++++++++++++++-----
>  2 files changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0d00a07..a566780 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -740,10 +740,11 @@ struct btrfs_space_info {
>  	 */
>  	unsigned long reservation_progress;
>  
> -	int full;		/* indicates that we cannot allocate any more
> +	int full:1;		/* indicates that we cannot allocate any more
>  				   chunks for this space */
> -	int force_alloc;	/* set if we need to force a chunk alloc for
> +	int force_alloc:1;	/* set if we need to force a chunk alloc for
>  				   this space */
> +	int chunk_alloc:1;	/* set if we are allocating a chunk */
>  
>  	struct list_head list;
>  
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f619c3c..362cc9b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3020,6 +3020,7 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	found->bytes_may_use = 0;
>  	found->full = 0;
>  	found->force_alloc = 0;
> +	found->chunk_alloc = 0;
>  	*space_info = found;
>  	list_add_rcu(&found->list, &info->space_info);
>  	atomic_set(&found->caching_threads, 0);
> @@ -3273,10 +3274,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  {
>  	struct btrfs_space_info *space_info;
>  	struct btrfs_fs_info *fs_info = extent_root->fs_info;
> +	int wait_for_alloc = 0;
>  	int ret = 0;
>  
> -	mutex_lock(&fs_info->chunk_mutex);
> -
>  	flags = btrfs_reduce_alloc_profile(extent_root, flags);
>  
>  	space_info = __find_space_info(extent_root->fs_info, flags);
> @@ -3287,21 +3287,40 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  	}
>  	BUG_ON(!space_info);
>  
> +again:
>  	spin_lock(&space_info->lock);
>  	if (space_info->force_alloc)
>  		force = 1;
>  	if (space_info->full) {
>  		spin_unlock(&space_info->lock);
> -		goto out;
> +		return 0;
>  	}
>  
>  	if (!force && !should_alloc_chunk(extent_root, space_info,
>  					  alloc_bytes)) {
>  		spin_unlock(&space_info->lock);
> -		goto out;
> +		return 0;
> +	} else if (space_info->chunk_alloc) {
> +		wait_for_alloc = 1;
> +	} else {
> +		space_info->chunk_alloc = 1;
>  	}
>  	spin_unlock(&space_info->lock);
>  
> +	mutex_lock(&fs_info->chunk_mutex);
> +
> +	/*
> +	 * The chunk_mutex is held throughout the entirety of a chunk
> +	 * allocation, so once we've acquired the chunk_mutex we know that the
> +	 * other guy is done and we need to recheck and see if we should
> +	 * allocate.
> +	 */
> +	if (wait_for_alloc) {
> +		mutex_unlock(&fs_info->chunk_mutex);
> +		wait_for_alloc = 0;
> +		goto again;
> +	}
> +
>  	/*
>  	 * If we have mixed data/metadata chunks we want to make sure we keep
>  	 * allocating mixed chunks instead of individual chunks.
> @@ -3327,9 +3346,9 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>  		space_info->full = 1;
>  	else
>  		ret = 1;
> +	space_info->chunk_alloc = 0;
>  	space_info->force_alloc = 0;
>  	spin_unlock(&space_info->lock);
> -out:
>  	mutex_unlock(&extent_root->fs_info->chunk_mutex);
>  	return ret;
>  }

