Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23793 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab2KSKTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Nov 2012 05:19:15 -0500
Date: Mon, 19 Nov 2012 18:18:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Daniel J Blueman <daniel@quora.org>, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH RESEND] Btrfs: fix deadlock when the process of delayed
 refs fails
Message-ID: <20121119101847.GA8692@gmail.com>
Reply-To: bo.li.liu@oracle.com
References: <50A9F9C6.6090901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50A9F9C6.6090901@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 19, 2012 at 05:20:06PM +0800, Miao Xie wrote:
> Delayed ref mutexes are taken inside btrfs_commit_transaction. A later call
> fails and jumps to the cleanup_transaction label with these mutexes still held
> causing deadlock when they are reacquired.
> 
> Fix this problem by unlocking those mutexes at the suitable place.
> 
> Reported-by: Daniel J Blueman <daniel@quora.org>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/delayed-ref.c |  8 ++++++++
>  fs/btrfs/delayed-ref.h |  6 ++++++
>  fs/btrfs/extent-tree.c | 25 ++++++++++++++++++-------
>  3 files changed, 32 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/delayed-ref.c b/fs/btrfs/delayed-ref.c
> index ae94117..364cb90 100644
> --- a/fs/btrfs/delayed-ref.c
> +++ b/fs/btrfs/delayed-ref.c
> @@ -422,6 +422,14 @@ again:
>  	return 1;
>  }
>  
> +void btrfs_release_ref_cluster(struct list_head *cluster)
> +{
> +	struct list_head *pos, *q;
> +
> +	list_for_each_safe(pos, q, cluster)
> +		list_del_init(pos);
> +}
> +
>  /*
>   * helper function to update an extent delayed ref in the
>   * rbtree.  existing and update must both have the same
> diff --git a/fs/btrfs/delayed-ref.h b/fs/btrfs/delayed-ref.h
> index ab53005..fcc5a29 100644
> --- a/fs/btrfs/delayed-ref.h
> +++ b/fs/btrfs/delayed-ref.h
> @@ -176,8 +176,14 @@ struct btrfs_delayed_ref_head *
>  btrfs_find_delayed_ref_head(struct btrfs_trans_handle *trans, u64 bytenr);
>  int btrfs_delayed_ref_lock(struct btrfs_trans_handle *trans,
>  			   struct btrfs_delayed_ref_head *head);
> +static inline void btrfs_delayed_ref_unlock(struct btrfs_delayed_ref_head *head)
> +{
> +	mutex_unlock(&head->mutex);
> +}
> +
>  int btrfs_find_ref_cluster(struct btrfs_trans_handle *trans,
>  			   struct list_head *cluster, u64 search_start);
> +void btrfs_release_ref_cluster(struct list_head *cluster);
>  
>  int btrfs_check_delayed_seq(struct btrfs_fs_info *fs_info,
>  			    struct btrfs_delayed_ref_root *delayed_refs,
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d3e2c1..43a58cb 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2160,7 +2160,6 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  						      node->num_bytes);
>  			}
>  		}
> -		mutex_unlock(&head->mutex);

I think code can be clean here if we keep this mutex_unlock(), see below, please.

>  		return ret;
>  	}
>  
> @@ -2275,7 +2274,7 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  			 * process of being added. Don't run this ref yet.
>  			 */
>  			list_del_init(&locked_ref->cluster);
> -			mutex_unlock(&locked_ref->mutex);
> +			btrfs_delayed_ref_unlock(locked_ref);
>  			locked_ref = NULL;
>  			delayed_refs->num_heads_ready++;
>  			spin_unlock(&delayed_refs->lock);
> @@ -2316,14 +2315,12 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  				if (ret) {
>  					printk(KERN_DEBUG "btrfs: run_delayed_extent_op returned %d\n", ret);
>  					spin_lock(&delayed_refs->lock);
> +					btrfs_delayed_ref_unlock(locked_ref);
>  					return ret;
>  				}
>  
>  				goto next;
>  			}
> -
> -			list_del_init(&locked_ref->cluster);
> -			locked_ref = NULL;
>  		}
>  
>  		ref->in_tree = 0;
> @@ -2350,11 +2347,24 @@ static noinline int run_clustered_refs(struct btrfs_trans_handle *trans,
>  
>  		ret = run_one_delayed_ref(trans, root, ref, extent_op,
>  					  must_insert_reserved);
> -
> -		btrfs_put_delayed_ref(ref);
>  		kfree(extent_op);
>  		count++;
>  
> +		/*
> +		 * If this node is a head, we will pick the next head to deal
> +		 * with. If there is something wrong when we process the
> +		 * delayed ref, we will end our operation. So in these two
> +		 * cases, we have to unlock the head and drop it from the
> +		 * cluster list before we release it though the code is ugly.
> +		 */
> +		if (btrfs_delayed_ref_is_head(ref) || ret) {
> +			list_del_init(&locked_ref->cluster);
> +			btrfs_delayed_ref_unlock(locked_ref);
> +			locked_ref = NULL;
> +		}
> +

In case that we don't remove mutex_unlock above,

if ret is non-zero, either
A)locked_ref is not NULL, or
B)locked_ref is NULL, and it has done list_del_init above and
  also done mutex_unlock in run_one_delayed_ref().

So in the case A), it is ok to do list_del_init() and mutex_unlock(),
while in the case B), we need to do nothing.

Then the code can be clean as we wish,
if (ret) {
	if (locked_ref) {
		list_del_init();
		mutex_unlock();
	}
	...
}

thanks,
liubo

> +		btrfs_put_delayed_ref(ref);
> +
>  		if (ret) {
>  			printk(KERN_DEBUG "btrfs: run_one_delayed_ref returned %d\n", ret);
>  			spin_lock(&delayed_refs->lock);
> @@ -2510,6 +2520,7 @@ again:
>  
>  		ret = run_clustered_refs(trans, root, &cluster);
>  		if (ret < 0) {
> +			btrfs_release_ref_cluster(&cluster);
>  			spin_unlock(&delayed_refs->lock);
>  			btrfs_abort_transaction(trans, root, ret);
>  			return ret;
> -- 
> 1.7.11.7
> 
