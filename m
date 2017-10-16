Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44211 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752274AbdJPOFX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 10:05:23 -0400
Subject: Re: [PATCH 09/21] btrfs: move extent_op cleanup to a helper
To: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <1506714245-23072-1-git-send-email-jbacik@fb.com>
 <1506714245-23072-10-git-send-email-jbacik@fb.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <762cd1c0-2a51-847d-5dbb-1ba8e7952b70@suse.com>
Date: Mon, 16 Oct 2017 17:05:19 +0300
MIME-Version: 1.0
In-Reply-To: <1506714245-23072-10-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 29.09.2017 22:43, Josef Bacik wrote:
> Move the extent_op cleanup for an empty head ref to a helper function to
> help simplify __btrfs_run_delayed_refs.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 77 ++++++++++++++++++++++++++------------------------
>  1 file changed, 40 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f356b4a66186..f4048b23c7be 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2587,6 +2587,26 @@ unselect_delayed_ref_head(struct btrfs_delayed_ref_root *delayed_refs,
>  	btrfs_delayed_ref_unlock(head);
>  }
>  
> +static int cleanup_extent_op(struct btrfs_trans_handle *trans,
> +			     struct btrfs_fs_info *fs_info,

Do we really need the fs_info as a separate argument, since we can
obtain it from trans->fs_info, admittedly this would require refactoring
run_delayed_extent_op as well? Looking at the other patches which
simplify delayed refs there are numerous function which take both a
transaction and a fs_info. Is there a case where trans' fs_info is not
the same as the fs_info based, I'd say no?

> +			     struct btrfs_delayed_ref_head *head)
> +{
> +	struct btrfs_delayed_extent_op *extent_op = head->extent_op;
> +	int ret;
> +
> +	if (!extent_op)
> +		return 0;
> +	head->extent_op = NULL;
> +	if (head->must_insert_reserved) {
> +		btrfs_free_delayed_extent_op(extent_op);
> +		return 0;
> +	}
> +	spin_unlock(&head->lock);
> +	ret = run_delayed_extent_op(trans, fs_info, &head->node, extent_op);
> +	btrfs_free_delayed_extent_op(extent_op);
> +	return ret ? ret : 1;
> +}
> +
>  /*
>   * Returns 0 on success or if called with an already aborted transaction.
>   * Returns -ENOMEM or -EIO on failure and will abort the transaction.
> @@ -2667,16 +2687,6 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			continue;
>  		}
>  
> -		/*
> -		 * record the must insert reserved flag before we
> -		 * drop the spin lock.
> -		 */
> -		must_insert_reserved = locked_ref->must_insert_reserved;
> -		locked_ref->must_insert_reserved = 0;
> -
> -		extent_op = locked_ref->extent_op;
> -		locked_ref->extent_op = NULL;
> -
>  		if (!ref) {
>  
>  
> @@ -2686,33 +2696,17 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  			 */
>  			ref = &locked_ref->node;
>  
> -			if (extent_op && must_insert_reserved) {
> -				btrfs_free_delayed_extent_op(extent_op);
> -				extent_op = NULL;
> -			}
> -
> -			if (extent_op) {
> -				spin_unlock(&locked_ref->lock);
> -				ret = run_delayed_extent_op(trans, fs_info,
> -							    ref, extent_op);
> -				btrfs_free_delayed_extent_op(extent_op);
> -
> -				if (ret) {
> -					/*
> -					 * Need to reset must_insert_reserved if
> -					 * there was an error so the abort stuff
> -					 * can cleanup the reserved space
> -					 * properly.
> -					 */
> -					if (must_insert_reserved)
> -						locked_ref->must_insert_reserved = 1;
> -					unselect_delayed_ref_head(delayed_refs,
> -								  locked_ref);
> -					btrfs_debug(fs_info,
> -						    "run_delayed_extent_op returned %d",
> -						    ret);
> -					return ret;
> -				}
> +			ret = cleanup_extent_op(trans, fs_info, locked_ref);
> +			if (ret < 0) {
> +				unselect_delayed_ref_head(delayed_refs,
> +							  locked_ref);
> +				btrfs_debug(fs_info,
> +					    "run_delayed_extent_op returned %d",
> +					    ret);
> +				return ret;
> +			} else if (ret > 0) {
> +				/* We dropped our lock, we need to loop. */
> +				ret = 0;
>  				continue;
>  			}
>  
> @@ -2761,6 +2755,15 @@ static noinline int __btrfs_run_delayed_refs(struct btrfs_trans_handle *trans,
>  				WARN_ON(1);
>  			}
>  		}
> +		/*
> +		 * record the must insert reserved flag before we
> +		 * drop the spin lock.
> +		 */
> +		must_insert_reserved = locked_ref->must_insert_reserved;
> +		locked_ref->must_insert_reserved = 0;
> +
> +		extent_op = locked_ref->extent_op;
> +		locked_ref->extent_op = NULL;
>  		spin_unlock(&locked_ref->lock);
>  
>  		ret = run_one_delayed_ref(trans, fs_info, ref, extent_op,
> 
