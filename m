Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49725 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753075AbdHXOnf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 10:43:35 -0400
Subject: Re: [PATCH][v2] btrfs: change how we decide to commit transactions
 during flushing
To: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1503432039-7666-1-git-send-email-jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <703e4090-1bd7-afd7-ecb6-a4f07047d823@suse.com>
Date: Thu, 24 Aug 2017 17:43:29 +0300
MIME-Version: 1.0
In-Reply-To: <1503432039-7666-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 22.08.2017 23:00, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Nikolay reported that generic/273 was failing currently with ENOSPC.
> Turns out this is because we get to the point where the outstanding
> reservations are greater than the pinned space on the fs.  This is a
> mistake, previously we used the current reservation amount in
> may_commit_transaction, not the entire outstanding reservation amount.
> Fix this to find the minimum byte size needed to make progress in
> flushing, and pass that into may_commit_transaction.  From there we can
> make a smarter decision on whether to commit the transaction or not.
> This fixes the failure in generic/273.
> 
> Reported-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Reviewed-and-tested-by: Nikolay Borisov <nborisov@suse.com>
> ---
> v1->v2:
> - check the ticket bytes in may_commit_transaction instead of copying bytes
>   around.
> - clean up may_commit_transaction to remove unused arguments
> 
>  fs/btrfs/extent-tree.c | 42 ++++++++++++++++++++++++++++--------------
>  1 file changed, 28 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a5d59dd..1464678 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -4836,6 +4836,13 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>  	}
>  }
>  
> +struct reserve_ticket {
> +	u64 bytes;
> +	int error;
> +	struct list_head list;
> +	wait_queue_head_t wait;
> +};
> +
>  /**
>   * maybe_commit_transaction - possibly commit the transaction if its ok to
>   * @root - the root we're allocating for
> @@ -4847,18 +4854,29 @@ static void shrink_delalloc(struct btrfs_fs_info *fs_info, u64 to_reclaim,
>   * will return -ENOSPC.
>   */
>  static int may_commit_transaction(struct btrfs_fs_info *fs_info,
> -				  struct btrfs_space_info *space_info,
> -				  u64 bytes, int force)
> +				  struct btrfs_space_info *space_info)
>  {
> +	struct reserve_ticket *ticket = NULL;
>  	struct btrfs_block_rsv *delayed_rsv = &fs_info->delayed_block_rsv;
>  	struct btrfs_trans_handle *trans;
> +	u64 bytes;
>  
>  	trans = (struct btrfs_trans_handle *)current->journal_info;
>  	if (trans)
>  		return -EAGAIN;
>  
> -	if (force)
> -		goto commit;
> +	spin_lock(&space_info->lock);
> +	if (!list_empty(&space_info->priority_tickets))
> +		ticket = list_first_entry(&space_info->priority_tickets,
> +					  struct reserve_ticket, list);
> +	else if (!list_empty(&space_info->tickets))
> +		ticket = list_first_entry(&space_info->tickets,
> +					  struct reserve_ticket, list);
> +	bytes = (ticket) ? ticket->bytes : 0;
> +	spin_unlock(&space_info->lock);
> +
> +	if (!bytes)
> +		return 0;
>  
>  	/* See if there is enough pinned space to make this reservation */
>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> @@ -4873,8 +4891,12 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  		return -ENOSPC;
>  
>  	spin_lock(&delayed_rsv->lock);
> +	if (delayed_rsv->size > bytes)
> +		bytes = 0;
> +	else
> +		bytes -= delayed_rsv->size;
>  	if (percpu_counter_compare(&space_info->total_bytes_pinned,
> -				   bytes - delayed_rsv->size) < 0) {
> +				   bytes) < 0) {
>  		spin_unlock(&delayed_rsv->lock);
>  		return -ENOSPC;
>  	}
> @@ -4888,13 +4910,6 @@ static int may_commit_transaction(struct btrfs_fs_info *fs_info,
>  	return btrfs_commit_transaction(trans);
>  }
>  
> -struct reserve_ticket {
> -	u64 bytes;
> -	int error;
> -	struct list_head list;
> -	wait_queue_head_t wait;
> -};
> -
>  /*
>   * Try to flush some data based on policy set by @state. This is only advisory
>   * and may fail for various reasons. The caller is supposed to examine the
> @@ -4944,8 +4959,7 @@ static void flush_space(struct btrfs_fs_info *fs_info,
>  			ret = 0;
>  		break;
>  	case COMMIT_TRANS:
> -		ret = may_commit_transaction(fs_info, space_info,
> -					     num_bytes, 0);
> +		ret = may_commit_transaction(fs_info, space_info);
>  		break;
>  	default:
>  		ret = -ENOSPC;
> 
