Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39584 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751449AbdFGUUP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jun 2017 16:20:15 -0400
Date: Wed, 7 Jun 2017 13:18:10 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        kernel-team@fb.com
Subject: Re: [PATCH 6/7] Btrfs: rework delayed ref total_bytes_pinned
 accounting
Message-ID: <20170607201810.GB16793@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <cover.1496792333.git.osandov@fb.com>
 <e632aa7e9beeff738885de7b7c9e689f5e54ae70.1496792333.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e632aa7e9beeff738885de7b7c9e689f5e54ae70.1496792333.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 04:45:31PM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The total_bytes_pinned counter is completely broken when accounting
> delayed refs:
> 
> - If two drops for the same extent are merged, we will decrement
>   total_bytes_pinned twice but only increment it once.
> - If an add is merged into a drop or vice versa, we will decrement the
>   total_bytes_pinned counter but never increment it.
> - If multiple references to an extent are dropped, we will account it
>   multiple times, potentially vastly over-estimating the number of bytes
>   that will be freed by a commit and doing unnecessary work when we're
>   close to ENOSPC.
> 
> The last issue is relatively minor, but the first two make the
> total_bytes_pinned counter leak or underflow very often. These
> accounting issues were introduced in b150a4f10d87 ("Btrfs: use a percpu
> to keep track of possibly pinned bytes"), but they were papered over by
> zeroing out the counter on every commit until d288db5dc011 ("Btrfs: fix
> race of using total_bytes_pinned").
> 
> We need to make sure that an extent is accounted as pinned exactly once
> if and only if we will drop references to it when when the transaction
> is committed. Ideally we would only add to total_bytes_pinned when the
> *last* reference is dropped, but this information isn't readily
> available for data extents. Again, this over-estimation can lead to
> extra commits when we're close to ENOSPC, but it's not as bad as before.
> 
> The fix implemented here is to increment total_bytes_pinned when the
> total refmod count for an extent goes negative and decrement it if the
> refmod count goes back to non-negative or after we've run all of the
> delayed refs for that extent.
>

The patch could be cleaner if we inc/dec %pinned inside delayed_ref.c.

The idea looks good to me.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  fs/btrfs/extent-tree.c | 41 ++++++++++++++++++++++++++++++++---------
>  1 file changed, 32 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 6dce7abafe84..75ad24f8d253 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2112,6 +2112,7 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  			 u64 bytenr, u64 num_bytes, u64 parent,
>  			 u64 root_objectid, u64 owner, u64 offset)
>  {
> +	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
>  	BUG_ON(owner < BTRFS_FIRST_FREE_OBJECTID &&
> @@ -2122,14 +2123,18 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  						 num_bytes, parent,
>  						 root_objectid, (int)owner,
>  						 BTRFS_ADD_DELAYED_REF, NULL,
> -						 NULL, NULL);
> +						 &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
>  						 num_bytes, parent,
>  						 root_objectid, owner, offset,
> -						 0, BTRFS_ADD_DELAYED_REF, NULL,
> -						 NULL);
> +						 0, BTRFS_ADD_DELAYED_REF,
> +						 &old_ref_mod, &new_ref_mod);
>  	}
> +
> +	if (ret == 0 && old_ref_mod < 0 && new_ref_mod >= 0)
> +		add_pinned_bytes(fs_info, -num_bytes, owner, root_objectid);
> +
>  	return ret;
>  }
>  
> @@ -2433,6 +2438,16 @@ static int run_one_delayed_ref(struct btrfs_trans_handle *trans,
>  		head = btrfs_delayed_node_to_head(node);
>  		trace_run_delayed_ref_head(fs_info, node, head, node->action);
>  
> +		if (head->total_ref_mod < 0) {
> +			struct btrfs_block_group_cache *cache;
> +
> +			cache = btrfs_lookup_block_group(fs_info, node->bytenr);
> +			ASSERT(cache);
> +			percpu_counter_add(&cache->space_info->total_bytes_pinned,
> +					   -node->num_bytes);
> +			btrfs_put_block_group(cache);
> +		}
> +
>  		if (insert_reserved) {
>  			btrfs_pin_extent(fs_info, node->bytenr,
>  					 node->num_bytes, 1);
> @@ -6269,6 +6284,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
>  			trace_btrfs_space_reservation(info, "pinned",
>  						      cache->space_info->flags,
>  						      num_bytes, 1);
> +			percpu_counter_add(&cache->space_info->total_bytes_pinned,
> +					   num_bytes);
>  			set_extent_dirty(info->pinned_extents,
>  					 bytenr, bytenr + num_bytes - 1,
>  					 GFP_NOFS | __GFP_NOFAIL);
> @@ -7038,8 +7055,6 @@ static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>  				goto out;
>  			}
>  		}
> -		add_pinned_bytes(info, -num_bytes, owner_objectid,
> -				 root_objectid);
>  	} else {
>  		if (found_extent) {
>  			BUG_ON(is_data && refs_to_drop !=
> @@ -7171,13 +7186,16 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  	int ret;
>  
>  	if (root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID) {
> +		int old_ref_mod, new_ref_mod;
> +
>  		ret = btrfs_add_delayed_tree_ref(fs_info, trans, buf->start,
>  						 buf->len, parent,
>  						 root->root_key.objectid,
>  						 btrfs_header_level(buf),
>  						 BTRFS_DROP_DELAYED_REF, NULL,
> -						 NULL, NULL);
> +						 &old_ref_mod, &new_ref_mod);
>  		BUG_ON(ret); /* -ENOMEM */
> +		pin = old_ref_mod >= 0 && new_ref_mod < 0;
>  	}
>  
>  	if (last_ref && btrfs_header_generation(buf) == trans->transid) {
> @@ -7226,12 +7244,12 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      u64 bytenr, u64 num_bytes, u64 parent, u64 root_objectid,
>  		      u64 owner, u64 offset)
>  {
> +	int old_ref_mod, new_ref_mod;
>  	int ret;
>  
>  	if (btrfs_is_testing(fs_info))
>  		return 0;
>  
> -	add_pinned_bytes(fs_info, num_bytes, owner, root_objectid);
>  
>  	/*
>  	 * tree log blocks never actually go into the extent allocation
> @@ -7241,20 +7259,25 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
>  		/* unlocks the pinned mutex */
>  		btrfs_pin_extent(fs_info, bytenr, num_bytes, 1);
> +		old_ref_mod = new_ref_mod = 0;
>  		ret = 0;
>  	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
>  		ret = btrfs_add_delayed_tree_ref(fs_info, trans, bytenr,
>  						 num_bytes, parent,
>  						 root_objectid, (int)owner,
>  						 BTRFS_DROP_DELAYED_REF, NULL,
> -						 NULL, NULL);
> +						 &old_ref_mod, &new_ref_mod);
>  	} else {
>  		ret = btrfs_add_delayed_data_ref(fs_info, trans, bytenr,
>  						 num_bytes, parent,
>  						 root_objectid, owner, offset,
>  						 0, BTRFS_DROP_DELAYED_REF,
> -						 NULL, NULL);
> +						 &old_ref_mod, &new_ref_mod);
>  	}
> +
> +	if (ret == 0 && old_ref_mod >= 0 && new_ref_mod < 0)
> +		add_pinned_bytes(fs_info, num_bytes, owner, root_objectid);
> +
>  	return ret;
>  }
>  
> -- 
> 2.13.0
> 
