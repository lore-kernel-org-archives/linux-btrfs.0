From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: force delalloc flushing when things get
 desperate
Date: Tue, 30 Mar 2010 21:25:54 -0400
Message-ID: <20100331012554.GU13190@think>
References: <20100312212309.GC2332@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100312212309.GC2332@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 12, 2010 at 04:23:09PM -0500, Josef Bacik wrote:
> When testing with max_extents=4k, we enospc out really really early.  The reason
> for this is we really overwhelm the system with our worst case calculation.
> When we try to flush delalloc, we don't want everybody to wait around forever,
> so we wake up the waiters when we've done some of the work in hopes that its
> enough work to get everything they need done.  The problem with this is we don't
> wait long enough sometimes.  So if we've already done a flush_delalloc and
> didn't find what we need, do it again and this time wait for the flushing to be
> completely finished before returning.  This makes my ENOSPC test actually
> finish, instead of finishing in about 20 seconds.  Thanks,

Thanks Josef, was this one against the per-cpu work?  It doesn't apply
cleanly but is simple enough that I can just bang it in there ;)

-chris

> 
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/btrfs/extent-tree.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 0085dcb..aeef481 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2873,7 +2873,7 @@ static noinline void flush_delalloc_async(struct btrfs_work *work)
>  	kfree(async);
>  }
>  
> -static void wait_on_flush(struct btrfs_root *root, struct btrfs_space_info *info)
> +static void wait_on_flush(struct btrfs_root *root, struct btrfs_space_info *info, int soft)
>  {
>  	DEFINE_WAIT(wait);
>  	u64 num_bytes;
> @@ -2895,6 +2895,12 @@ static void wait_on_flush(struct btrfs_root *root, struct btrfs_space_info *info
>  			break;
>  		}
>  
> +		if (!soft) {
> +			spin_unlock(&info->lock);
> +			schedule();
> +			continue;
> +		}
> +
>  		free = 0;
>  		for_each_possible_cpu(i) {
>  			struct btrfs_reserved_space_pool *pool;
> @@ -2924,7 +2930,7 @@ static void wait_on_flush(struct btrfs_root *root, struct btrfs_space_info *info
>  }
>  
>  static void flush_delalloc(struct btrfs_root *root,
> -				 struct btrfs_space_info *info)
> +			   struct btrfs_space_info *info, int soft)
>  {
>  	struct async_flush *async;
>  	bool wait = false;
> @@ -2939,7 +2945,7 @@ static void flush_delalloc(struct btrfs_root *root,
>  	spin_unlock(&info->lock);
>  
>  	if (wait) {
> -		wait_on_flush(root, info);
> +		wait_on_flush(root, info, soft);
>  		return;
>  	}
>  
> @@ -2953,7 +2959,7 @@ static void flush_delalloc(struct btrfs_root *root,
>  
>  	btrfs_queue_worker(&root->fs_info->enospc_workers,
>  			   &async->work);
> -	wait_on_flush(root, info);
> +	wait_on_flush(root, info, soft);
>  	return;
>  
>  flush:
> @@ -3146,14 +3152,17 @@ again:
>  
>  	if (!delalloc_flushed) {
>  		delalloc_flushed = true;
> -		flush_delalloc(root, meta_sinfo);
> +		flush_delalloc(root, meta_sinfo, 1);
>  		goto again;
>  	}
>  
>  	if (!chunk_allocated) {
> +		int ret;
> +
>  		chunk_allocated = true;
> -		btrfs_wait_ordered_extents(root, 0, 0);
> -		maybe_allocate_chunk(root, meta_sinfo);
> +		ret = maybe_allocate_chunk(root, meta_sinfo);
> +		if (!ret)
> +			flush_delalloc(root, meta_sinfo, 0);
>  		goto again;
>  	}
>  
> @@ -3338,7 +3347,7 @@ again:
>  
>  	if (!delalloc_flushed) {
>  		delalloc_flushed = true;
> -		flush_delalloc(root, meta_sinfo);
> +		flush_delalloc(root, meta_sinfo, 0);
>  		goto again;
>  	}
>  
> -- 
> 1.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
