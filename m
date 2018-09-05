Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:42929 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbeIEGiu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 5 Sep 2018 02:38:50 -0400
Subject: Re: [PATCH 5/8] btrfs-progs: Wire up delayed refs
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
Cc: David Sterba <dsterba@suse.com>
References: <1534425035-323-1-git-send-email-nborisov@suse.com>
 <1534425035-323-6-git-send-email-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <811fcfa0-467a-ae61-a8a5-8fd7af1bfd73@gmx.com>
Date: Wed, 5 Sep 2018 10:10:45 +0800
MIME-Version: 1.0
In-Reply-To: <1534425035-323-6-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/8/16 下午9:10, Nikolay Borisov wrote:
> This commit enables the delayed refs infrastructures. This entails doing
> the following:
> 
> 1. Replacing existing calls of btrfs_extent_post_op (which is the
> equivalent of delayed refs) with the proper btrfs_run_delayed_refs.
> As well as eliminating open-coded calls to finish_current_insert and
> del_pending_extents which execute the delayed ops.
> 
> 2. Wiring up the addition of delayed refs when freeing extents
> (btrfs_free_extent) and when adding new extents (alloc_tree_block).
> 
> 3. Adding calls to btrfs_run_delayed refs in the transaction commit
> path alongside comments why every call is needed, since it's not always
> obvious (those call sites were derived empirically by running and
> debugging existing tests)
> 
> 4. Correctly flagging the transaction in which we are reinitialising
> the extent tree.
> 
> 5 Moving btrfs_write_dirty_block_groups to btrfs_write_dirty_block_groups
> since blockgroups should be written to disk after the last delayed refs
> have been run.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>

Is there something (maybe btrfs_run_delayed_refs()?) missing in btrfs-image?

btrfs-image from devel branch can't restore image correctly, the block
group used bytes is not correct, thus it can't pass misc nor fsck tests.

Thanks,
Qu

> ---
>  check/main.c  |   3 +-
>  extent-tree.c | 166 ++++++++++++++++++++++++++++++----------------------------
>  transaction.c |  27 +++++++++-
>  3 files changed, 112 insertions(+), 84 deletions(-)
> 
> diff --git a/check/main.c b/check/main.c
> index bc2ee22f7943..b361cd7e26a0 100644
> --- a/check/main.c
> +++ b/check/main.c
> @@ -8710,7 +8710,7 @@ static int reinit_extent_tree(struct btrfs_trans_handle *trans,
>  			fprintf(stderr, "Error adding block group\n");
>  			return ret;
>  		}
> -		btrfs_extent_post_op(trans);
> +		btrfs_run_delayed_refs(trans, -1);
>  	}
>  
>  	ret = reset_balance(trans, fs_info);
> @@ -9767,6 +9767,7 @@ int cmd_check(int argc, char **argv)
>  			goto close_out;
>  		}
>  
> +		trans->reinit_extent_tree = true;
>  		if (init_extent_tree) {
>  			printf("Creating a new extent tree\n");
>  			ret = reinit_extent_tree(trans, info,
> diff --git a/extent-tree.c b/extent-tree.c
> index 7d6c37c6b371..2fa51bbc0359 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1418,8 +1418,6 @@ int btrfs_inc_extent_ref(struct btrfs_trans_handle *trans,
>  		err = ret;
>  out:
>  	btrfs_free_path(path);
> -	finish_current_insert(trans);
> -	del_pending_extents(trans);
>  	BUG_ON(err);
>  	return err;
>  }
> @@ -1602,8 +1600,6 @@ int btrfs_set_block_flags(struct btrfs_trans_handle *trans, u64 bytenr,
>  	btrfs_set_extent_flags(l, item, flags);
>  out:
>  	btrfs_free_path(path);
> -	finish_current_insert(trans);
> -	del_pending_extents(trans);
>  	return ret;
>  }
>  
> @@ -1701,7 +1697,6 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>  				 struct btrfs_block_group_cache *cache)
>  {
>  	int ret;
> -	int pending_ret;
>  	struct btrfs_root *extent_root = trans->fs_info->extent_root;
>  	unsigned long bi;
>  	struct extent_buffer *leaf;
> @@ -1717,12 +1712,8 @@ static int write_one_cache_group(struct btrfs_trans_handle *trans,
>  	btrfs_mark_buffer_dirty(leaf);
>  	btrfs_release_path(path);
>  fail:
> -	finish_current_insert(trans);
> -	pending_ret = del_pending_extents(trans);
>  	if (ret)
>  		return ret;
> -	if (pending_ret)
> -		return pending_ret;
>  	return 0;
>  
>  }
> @@ -2049,6 +2040,7 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>  	int skinny_metadata =
>  		btrfs_fs_incompat(extent_root->fs_info, SKINNY_METADATA);
>  
> +
>  	while(1) {
>  		ret = find_first_extent_bit(&info->extent_ins, 0, &start,
>  					    &end, EXTENT_LOCKED);
> @@ -2080,6 +2072,8 @@ static int finish_current_insert(struct btrfs_trans_handle *trans)
>  			BUG_ON(1);
>  		}
>  
> +
> +		printf("shouldn't be executed\n");
>  		clear_extent_bits(&info->extent_ins, start, end, EXTENT_LOCKED);
>  		kfree(extent_op);
>  	}
> @@ -2379,7 +2373,6 @@ static int __free_extent(struct btrfs_trans_handle *trans,
>  	}
>  fail:
>  	btrfs_free_path(path);
> -	finish_current_insert(trans);
>  	return ret;
>  }
>  
> @@ -2462,33 +2455,30 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      u64 bytenr, u64 num_bytes, u64 parent,
>  		      u64 root_objectid, u64 owner, u64 offset)
>  {
> -	struct btrfs_root *extent_root = root->fs_info->extent_root;
> -	int pending_ret;
>  	int ret;
>  
>  	WARN_ON(num_bytes < root->fs_info->sectorsize);
> -	if (root == extent_root) {
> -		struct pending_extent_op *extent_op;
> -
> -		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
> -		BUG_ON(!extent_op);
> -
> -		extent_op->type = PENDING_EXTENT_DELETE;
> -		extent_op->bytenr = bytenr;
> -		extent_op->num_bytes = num_bytes;
> -		extent_op->level = (int)owner;
> -
> -		set_extent_bits(&root->fs_info->pending_del,
> -				bytenr, bytenr + num_bytes - 1,
> -				EXTENT_LOCKED);
> -		set_state_private(&root->fs_info->pending_del,
> -				  bytenr, (unsigned long)extent_op);
> -		return 0;
> +	/*
> +	 * tree log blocks never actually go into the extent allocation
> +	 * tree, just update pinning info and exit early.
> +	 */
> +	if (root_objectid == BTRFS_TREE_LOG_OBJECTID) {
> +		printf("PINNING EXTENTS IN LOG TREE\n");
> +		WARN_ON(owner >= BTRFS_FIRST_FREE_OBJECTID);
> +		btrfs_pin_extent(trans->fs_info, bytenr, num_bytes);
> +		ret = 0;
> +	} else if (owner < BTRFS_FIRST_FREE_OBJECTID) {
> +		BUG_ON(offset);
> +		ret = btrfs_add_delayed_tree_ref(trans->fs_info, trans,
> +						 bytenr, num_bytes, parent,
> +						 root_objectid, (int)owner,
> +						 BTRFS_DROP_DELAYED_REF,
> +						 NULL, NULL, NULL);
> +	} else {
> +		ret = __free_extent(trans, bytenr, num_bytes, parent,
> +				    root_objectid, owner, offset, 1);
>  	}
> -	ret = __free_extent(trans, bytenr, num_bytes, parent,
> -			    root_objectid, owner, offset, 1);
> -	pending_ret = del_pending_extents(trans);
> -	return ret ? ret : pending_ret;
> +	return ret;
>  }
>  
>  static u64 stripe_align(struct btrfs_root *root, u64 val)
> @@ -2694,6 +2684,8 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>  	struct btrfs_delayed_tree_ref *ref = btrfs_delayed_node_to_tree_ref(node);
>  	struct btrfs_key ins;
>  	bool skinny_metadata = btrfs_fs_incompat(trans->fs_info, SKINNY_METADATA);
> +	int ret;
> +	u64 start, end;
>  
>  	ins.objectid = node->bytenr;
>  	if (skinny_metadata) {
> @@ -2704,10 +2696,25 @@ static int alloc_reserved_tree_block2(struct btrfs_trans_handle *trans,
>  		ins.type = BTRFS_EXTENT_ITEM_KEY;
>  	}
>  
> -	return alloc_reserved_tree_block(trans, ref->root, trans->transid,
> -					 extent_op->flags_to_set,
> -					 &extent_op->key, ref->level, &ins);
> +	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
> +		ret = find_first_extent_bit(&trans->fs_info->extent_ins,
> +					    node->bytenr, &start, &end,
> +					    EXTENT_LOCKED);
> +		ASSERT(!ret);
> +		ASSERT(start == node->bytenr);
> +		ASSERT(end == node->bytenr + node->num_bytes - 1);
> +	}
> +
> +	ret = alloc_reserved_tree_block(trans, ref->root, trans->transid,
> +					extent_op->flags_to_set,
> +					&extent_op->key, ref->level, &ins);
>  
> +	if (ref->root == BTRFS_EXTENT_TREE_OBJECTID) {
> +		clear_extent_bits(&trans->fs_info->extent_ins, start, end,
> +				  EXTENT_LOCKED);
> +	}
> +
> +	return ret;
>  }
>  
>  static int alloc_reserved_tree_block(struct btrfs_trans_handle *trans,
> @@ -2772,39 +2779,50 @@ static int alloc_tree_block(struct btrfs_trans_handle *trans,
>  			    u64 search_end, struct btrfs_key *ins)
>  {
>  	int ret;
> +	u64 extent_size;
> +	struct btrfs_delayed_extent_op *extent_op;
> +	bool skinny_metadata = btrfs_fs_incompat(root->fs_info,
> +						 SKINNY_METADATA);
> +
> +	extent_op = btrfs_alloc_delayed_extent_op();
> +	if (!extent_op)
> +		return -ENOMEM;
> +
>  	ret = btrfs_reserve_extent(trans, root, num_bytes, empty_size,
>  				   hint_byte, search_end, ins, 0);
>  	BUG_ON(ret);
>  
> +	if (key)
> +		memcpy(&extent_op->key, key, sizeof(extent_op->key));
> +	else
> +		memset(&extent_op->key, 0, sizeof(extent_op->key));
> +	extent_op->flags_to_set = flags;
> +	extent_op->update_key = skinny_metadata ? false : true;
> +	extent_op->update_flags = true;
> +	extent_op->is_data = false;
> +	extent_op->level = level;
> +
> +	extent_size = ins->offset;
> +
> +	if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
> +		ins->offset = level;
> +		ins->type = BTRFS_METADATA_ITEM_KEY;
> +	}
> +
> +	/* Ensure this reserved extent is not found by the allocator */
>  	if (root_objectid == BTRFS_EXTENT_TREE_OBJECTID) {
> -		struct pending_extent_op *extent_op;
> -
> -		extent_op = kmalloc(sizeof(*extent_op), GFP_NOFS);
> -		BUG_ON(!extent_op);
> -
> -		extent_op->type = PENDING_EXTENT_INSERT;
> -		extent_op->bytenr = ins->objectid;
> -		extent_op->num_bytes = ins->offset;
> -		extent_op->level = level;
> -		extent_op->flags = flags;
> -		memcpy(&extent_op->key, key, sizeof(*key));
> -
> -		set_extent_bits(&root->fs_info->extent_ins, ins->objectid,
> -				ins->objectid + ins->offset - 1,
> -				EXTENT_LOCKED);
> -		set_state_private(&root->fs_info->extent_ins,
> -				  ins->objectid, (unsigned long)extent_op);
> -	} else {
> -		if (btrfs_fs_incompat(root->fs_info, SKINNY_METADATA)) {
> -			ins->offset = level;
> -			ins->type = BTRFS_METADATA_ITEM_KEY;
> -		}
> -		ret = alloc_reserved_tree_block(trans, root_objectid,
> -						generation, flags,
> -						key, level, ins);
> -		finish_current_insert(trans);
> -		del_pending_extents(trans);
> +		ret = set_extent_bits(&trans->fs_info->extent_ins,
> +				      ins->objectid,
> +				      ins->objectid + extent_size - 1,
> +				      EXTENT_LOCKED);
> +
> +		BUG_ON(ret);
>  	}
> +
> +	ret = btrfs_add_delayed_tree_ref(root->fs_info, trans, ins->objectid,
> +					 extent_size, 0, root_objectid,
> +					 level, BTRFS_ADD_DELAYED_EXTENT,
> +					 extent_op, NULL, NULL);
>  	return ret;
>  }
>  
> @@ -3329,11 +3347,6 @@ int btrfs_make_block_group(struct btrfs_trans_handle *trans,
>  				sizeof(cache->item));
>  	BUG_ON(ret);
>  
> -	ret = finish_current_insert(trans);
> -	BUG_ON(ret);
> -	ret = del_pending_extents(trans);
> -	BUG_ON(ret);
> -
>  	return 0;
>  }
>  
> @@ -3429,10 +3442,6 @@ int btrfs_make_block_groups(struct btrfs_trans_handle *trans,
>  					sizeof(cache->item));
>  		BUG_ON(ret);
>  
> -		finish_current_insert(trans);
> -		ret = del_pending_extents(trans);
> -		BUG_ON(ret);
> -
>  		cur_start = cache->key.objectid + cache->key.offset;
>  	}
>  	return 0;
> @@ -3814,14 +3823,9 @@ int btrfs_fix_block_accounting(struct btrfs_trans_handle *trans)
>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>  	struct btrfs_root *root = fs_info->extent_root;
>  
> -	while(extent_root_pending_ops(fs_info)) {
> -		ret = finish_current_insert(trans);
> -		if (ret)
> -			return ret;
> -		ret = del_pending_extents(trans);
> -		if (ret)
> -			return ret;
> -	}
> +	ret = btrfs_run_delayed_refs(trans, -1);
> +	if (ret)
> +		return ret;
>  
>  	while(1) {
>  		cache = btrfs_lookup_first_block_group(fs_info, start);
> @@ -4026,7 +4030,7 @@ static int __btrfs_record_file_extent(struct btrfs_trans_handle *trans,
>  		} else if (ret != -EEXIST) {
>  			goto fail;
>  		}
> -		btrfs_extent_post_op(trans);
> +		btrfs_run_delayed_refs(trans, -1);
>  		extent_bytenr = disk_bytenr;
>  		extent_num_bytes = num_bytes;
>  		extent_offset = 0;
> diff --git a/transaction.c b/transaction.c
> index 96d9891b0d1c..bfda769210ee 100644
> --- a/transaction.c
> +++ b/transaction.c
> @@ -61,7 +61,6 @@ static int update_cowonly_root(struct btrfs_trans_handle *trans,
>  	u64 old_root_bytenr;
>  	struct btrfs_root *tree_root = root->fs_info->tree_root;
>  
> -	btrfs_write_dirty_block_groups(trans);
>  	while(1) {
>  		old_root_bytenr = btrfs_root_bytenr(&root->root_item);
>  		if (old_root_bytenr == root->node->start)
> @@ -98,6 +97,17 @@ int commit_tree_roots(struct btrfs_trans_handle *trans,
>  	if (ret)
>  		return ret;
>  
> +	/*
> +	 * If the above CoW is the first one to dirty the current tree_root,
> +	 * delayed refs for it won't be run until after this function has
> +	 * finished executing, meaning we won't process the extent tree root,
> +	 * which will have been added to ->dirty_cowonly_roots.  So run
> +	 * delayed refs here as well.
> +	 */
> +	ret = btrfs_run_delayed_refs(trans, -1);
> +	if (ret)
> +		return ret;
> +
>  	while(!list_empty(&fs_info->dirty_cowonly_roots)) {
>  		next = fs_info->dirty_cowonly_roots.next;
>  		list_del_init(next);
> @@ -147,6 +157,12 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  
>  	if (trans->fs_info->transaction_aborted)
>  		return -EROFS;
> +	/*
> +	 * Flush all accumulated delayed refs so that root-tree updates are
> +	 * consistent
> +	 */
> +	ret = btrfs_run_delayed_refs(trans, -1);
> +	BUG_ON(ret);
>  
>  	if (root->commit_root == root->node)
>  		goto commit_tree;
> @@ -164,11 +180,18 @@ int btrfs_commit_transaction(struct btrfs_trans_handle *trans,
>  	ret = btrfs_update_root(trans, root->fs_info->tree_root,
>  				&root->root_key, &root->root_item);
>  	BUG_ON(ret);
> +
>  commit_tree:
>  	ret = commit_tree_roots(trans, fs_info);
>  	BUG_ON(ret);
> -	ret = __commit_transaction(trans, root);
> +	/*
> +	 * Ensure that all comitted roots are properly accounted in the
> +	 * extent tree
> +	 */
> +	ret = btrfs_run_delayed_refs(trans, -1);
>  	BUG_ON(ret);
> +	btrfs_write_dirty_block_groups(trans);
> +	__commit_transaction(trans, root);
>  	write_ctree_super(trans);
>  	btrfs_finish_extent_commit(trans, fs_info->extent_root,
>  			           &fs_info->pinned_extents);
> 
