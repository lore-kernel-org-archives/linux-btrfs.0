From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH 2/2] Btrfs: serialize flushers in reserve_metadata_bytes
Date: Thu, 9 Jun 2011 11:45:47 +0200
Message-ID: <20110609094547.GK12709@twin.jikos.cz>
References: <1307479449-14765-1-git-send-email-josef@redhat.com>
 <1307479449-14765-3-git-send-email-josef@redhat.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1307479449-14765-3-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 07, 2011 at 04:44:09PM -0400, Josef Bacik wrote:
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2932,6 +2932,8 @@ static int update_space_info(struct btrfs_fs_info *info, u64 flags,
>  	found->full = 0;
>  	found->force_alloc = CHUNK_ALLOC_NO_FORCE;
>  	found->chunk_alloc = 0;
> +	found->flush = 0;
> +	init_waitqueue_head(&found->wait);
>  	*space_info = found;
>  	list_add_rcu(&found->list, &info->space_info);
>  	atomic_set(&found->caching_threads, 0);
> @@ -3314,9 +3316,13 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
>  	if (reserved == 0)
>  		return 0;
>  
> -	/* nothing to shrink - nothing to reclaim */
> -	if (root->fs_info->delalloc_bytes == 0)
> +	smp_mb();

can you please explain why do you use the barrier here? (and add that
explanation as a comment)

it's for the delalloc_bytes test, right? this is being modified in
btrfs_set_bit_hook/btrfs_clear_bit_hook, protected by a spinlock.
the counter is sum of all delalloc_bytes for each delalloc inode.
if the counter is nonzero, then fs_info->delalloc_inodes is expected to
be nonempty, but the list is not touched in this function, but
indirectly from writeback_inodes_sb_nr_if_idle and the respective
.writepages callback, ending up in __extent_writepage which starts
messing with delalloc.

it think it's possible to reach state, where counter is nonzero, but the
delalloc_inodes list is empty. then writeback will just skip the
delalloc work in this round and will process it later.
even with a barrier in place:

btrfs_set_bit_hook:
# counter increased, a barrier will assure len is obtained from
# delalloc_bytes in shrink_delalloc
1349                 root->fs_info->delalloc_bytes += len;
# but fs_info->delalloc_list may be empty
1350                 if (do_list && list_empty(&BTRFS_I(inode)->delalloc_inodes)) {
1351				list_add_tail(&BTRFS_I(inode)->delalloc_inodes,
1352				&root->fs_info->delalloc_inodes);
1353                 }

although this does not seem to crash or cause corruption, I suggest to
use the spinlock as the synchronization mechanism to protect reading
fs_info->delalloc_bytes


david



> +	if (root->fs_info->delalloc_bytes == 0) {
> +		if (trans)
> +			return 0;
> +		btrfs_wait_ordered_extents(root, 0, 0);
>  		return 0;
> +	}
>  
>  	max_reclaim = min(reserved, to_reclaim);
>  
> @@ -3360,6 +3366,8 @@ static int shrink_delalloc(struct btrfs_trans_handle *trans,
>  		}
>  
>  	}
> +	if (reclaimed >= to_reclaim && !trans)
> +		btrfs_wait_ordered_extents(root, 0, 0);
>  	return reclaimed >= to_reclaim;
>  }
>  
> @@ -3384,15 +3392,36 @@ static int reserve_metadata_bytes(struct btrfs_trans_handle *trans,
>  	u64 num_bytes = orig_bytes;
>  	int retries = 0;
>  	int ret = 0;
> -	bool reserved = false;
>  	bool committed = false;
> +	bool flushing = false;
>  
>  again:
> -	ret = -ENOSPC;
> -	if (reserved)
> -		num_bytes = 0;
> -
> +	ret = 0;
>  	spin_lock(&space_info->lock);
> +	/*
> +	 * We only want to wait if somebody other than us is flushing and we are
> +	 * actually alloed to flush.
> +	 */
> +	while (flush && !flushing && space_info->flush) {
> +		spin_unlock(&space_info->lock);
> +		/*
> +		 * If we have a trans handle we can't wait because the flusher
> +		 * may have to commit the transaction, which would mean we would
> +		 * deadlock since we are waiting for the flusher to finish, but
> +		 * hold the current transaction open.
> +		 */
> +		if (trans)
> +			return -EAGAIN;
> +		ret = wait_event_interruptible(space_info->wait,
> +					       !space_info->flush);
> +		/* Must have been interrupted, return */
> +		if (ret)
> +			return -EINTR;
> +
> +		spin_lock(&space_info->lock);
> +	}
> +
> +	ret = -ENOSPC;
>  	unused = space_info->bytes_used + space_info->bytes_reserved +
>  		 space_info->bytes_pinned + space_info->bytes_readonly +
>  		 space_info->bytes_may_use;
> @@ -3407,8 +3436,7 @@ again:
>  	if (unused <= space_info->total_bytes) {
>  		unused = space_info->total_bytes - unused;
>  		if (unused >= num_bytes) {
> -			if (!reserved)
> -				space_info->bytes_may_use += orig_bytes;
> +			space_info->bytes_may_use += orig_bytes;
>  			ret = 0;
>  		} else {
>  			/*
> @@ -3433,17 +3461,14 @@ again:
>  	 * to reclaim space we can actually use it instead of somebody else
>  	 * stealing it from us.
>  	 */
> -	if (ret && !reserved) {
> -		space_info->bytes_may_use += orig_bytes;
> -		reserved = true;
> +	if (ret && flush) {
> +		flushing = true;
> +		space_info->flush = 1;
>  	}
>  
>  	spin_unlock(&space_info->lock);
>  
> -	if (!ret)
> -		return 0;
> -
> -	if (!flush)
> +	if (!ret || !flush)
>  		goto out;
>  
>  	/*
> @@ -3451,9 +3476,7 @@ again:
>  	 * metadata until after the IO is completed.
>  	 */
>  	ret = shrink_delalloc(trans, root, num_bytes, 1);
> -	if (ret > 0)
> -		return 0;
> -	else if (ret < 0)
> +	if (ret < 0)
>  		goto out;
>  
>  	/*
> @@ -3466,11 +3489,11 @@ again:
>  		goto again;
>  	}
>  
> -	spin_lock(&space_info->lock);
>  	/*
>  	 * Not enough space to be reclaimed, don't bother committing the
>  	 * transaction.
>  	 */
> +	spin_lock(&space_info->lock);
>  	if (space_info->bytes_pinned < orig_bytes)
>  		ret = -ENOSPC;
>  	spin_unlock(&space_info->lock);
> @@ -3493,12 +3516,12 @@ again:
>  	}
>  
>  out:
> -	if (reserved) {
> +	if (flushing) {
>  		spin_lock(&space_info->lock);
> -		space_info->bytes_may_use -= orig_bytes;
> +		space_info->flush = 0;
> +		wake_up_all(&space_info->wait);
>  		spin_unlock(&space_info->lock);
>  	}
> -
>  	return ret;
>  }
>  
> -- 
> 1.7.2.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
