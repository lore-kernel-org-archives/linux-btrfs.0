Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41345 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760078AbcKCSu5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Nov 2016 14:50:57 -0400
Subject: Re: [PATCH 3/4] btrfs: Expoert and move leaf/subtree qgroup helpers
 to qgroup.c
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20161018013129.23331-1-quwenruo@cn.fujitsu.com>
 <20161018013129.23331-4-quwenruo@cn.fujitsu.com>
Cc: rgoldwyn@suse.com
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <ae30bc88-b27a-a871-3937-ffc712976301@suse.de>
Date: Thu, 3 Nov 2016 13:50:50 -0500
MIME-Version: 1.0
In-Reply-To: <20161018013129.23331-4-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-and-Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

On 10/17/2016 08:31 PM, Qu Wenruo wrote:
> Move account_shared_subtree() to qgroup.c and rename it to
> btrfs_qgroup_trace_subtree().
> 
> Do the same thing for account_leaf_items() and rename it to
> btrfs_qgroup_trace_leaf_items().
> 
> Since all these functions are only for qgroup, move them to qgroup.c and
> export them is more appropriate.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 220 +------------------------------------------------
>  fs/btrfs/qgroup.c      | 211 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/qgroup.h      |  23 ++++++
>  3 files changed, 237 insertions(+), 217 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 024eb5d..f7aa49d 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -8535,220 +8535,6 @@ reada:
>  	wc->reada_slot = slot;
>  }
>  
> -static int account_leaf_items(struct btrfs_trans_handle *trans,
> -			      struct btrfs_root *root,
> -			      struct extent_buffer *eb)
> -{
> -	int nr = btrfs_header_nritems(eb);
> -	int i, extent_type, ret;
> -	struct btrfs_key key;
> -	struct btrfs_file_extent_item *fi;
> -	u64 bytenr, num_bytes;
> -
> -	/* We can be called directly from walk_up_proc() */
> -	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags))
> -		return 0;
> -
> -	for (i = 0; i < nr; i++) {
> -		btrfs_item_key_to_cpu(eb, &key, i);
> -
> -		if (key.type != BTRFS_EXTENT_DATA_KEY)
> -			continue;
> -
> -		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
> -		/* filter out non qgroup-accountable extents  */
> -		extent_type = btrfs_file_extent_type(eb, fi);
> -
> -		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> -			continue;
> -
> -		bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
> -		if (!bytenr)
> -			continue;
> -
> -		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
> -
> -		ret = btrfs_qgroup_trace_extent(trans, root->fs_info,
> -						bytenr, num_bytes, GFP_NOFS);
> -		if (ret)
> -			return ret;
> -	}
> -	return 0;
> -}
> -
> -/*
> - * Walk up the tree from the bottom, freeing leaves and any interior
> - * nodes which have had all slots visited. If a node (leaf or
> - * interior) is freed, the node above it will have it's slot
> - * incremented. The root node will never be freed.
> - *
> - * At the end of this function, we should have a path which has all
> - * slots incremented to the next position for a search. If we need to
> - * read a new node it will be NULL and the node above it will have the
> - * correct slot selected for a later read.
> - *
> - * If we increment the root nodes slot counter past the number of
> - * elements, 1 is returned to signal completion of the search.
> - */
> -static int adjust_slots_upwards(struct btrfs_root *root,
> -				struct btrfs_path *path, int root_level)
> -{
> -	int level = 0;
> -	int nr, slot;
> -	struct extent_buffer *eb;
> -
> -	if (root_level == 0)
> -		return 1;
> -
> -	while (level <= root_level) {
> -		eb = path->nodes[level];
> -		nr = btrfs_header_nritems(eb);
> -		path->slots[level]++;
> -		slot = path->slots[level];
> -		if (slot >= nr || level == 0) {
> -			/*
> -			 * Don't free the root -  we will detect this
> -			 * condition after our loop and return a
> -			 * positive value for caller to stop walking the tree.
> -			 */
> -			if (level != root_level) {
> -				btrfs_tree_unlock_rw(eb, path->locks[level]);
> -				path->locks[level] = 0;
> -
> -				free_extent_buffer(eb);
> -				path->nodes[level] = NULL;
> -				path->slots[level] = 0;
> -			}
> -		} else {
> -			/*
> -			 * We have a valid slot to walk back down
> -			 * from. Stop here so caller can process these
> -			 * new nodes.
> -			 */
> -			break;
> -		}
> -
> -		level++;
> -	}
> -
> -	eb = path->nodes[root_level];
> -	if (path->slots[root_level] >= btrfs_header_nritems(eb))
> -		return 1;
> -
> -	return 0;
> -}
> -
> -/*
> - * root_eb is the subtree root and is locked before this function is called.
> - */
> -static int account_shared_subtree(struct btrfs_trans_handle *trans,
> -				  struct btrfs_root *root,
> -				  struct extent_buffer *root_eb,
> -				  u64 root_gen,
> -				  int root_level)
> -{
> -	int ret = 0;
> -	int level;
> -	struct extent_buffer *eb = root_eb;
> -	struct btrfs_path *path = NULL;
> -
> -	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
> -	BUG_ON(root_eb == NULL);
> -
> -	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags))
> -		return 0;
> -
> -	if (!extent_buffer_uptodate(root_eb)) {
> -		ret = btrfs_read_buffer(root_eb, root_gen);
> -		if (ret)
> -			goto out;
> -	}
> -
> -	if (root_level == 0) {
> -		ret = account_leaf_items(trans, root, root_eb);
> -		goto out;
> -	}
> -
> -	path = btrfs_alloc_path();
> -	if (!path)
> -		return -ENOMEM;
> -
> -	/*
> -	 * Walk down the tree.  Missing extent blocks are filled in as
> -	 * we go. Metadata is accounted every time we read a new
> -	 * extent block.
> -	 *
> -	 * When we reach a leaf, we account for file extent items in it,
> -	 * walk back up the tree (adjusting slot pointers as we go)
> -	 * and restart the search process.
> -	 */
> -	extent_buffer_get(root_eb); /* For path */
> -	path->nodes[root_level] = root_eb;
> -	path->slots[root_level] = 0;
> -	path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
> -walk_down:
> -	level = root_level;
> -	while (level >= 0) {
> -		if (path->nodes[level] == NULL) {
> -			int parent_slot;
> -			u64 child_gen;
> -			u64 child_bytenr;
> -
> -			/* We need to get child blockptr/gen from
> -			 * parent before we can read it. */
> -			eb = path->nodes[level + 1];
> -			parent_slot = path->slots[level + 1];
> -			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
> -			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
> -
> -			eb = read_tree_block(root, child_bytenr, child_gen);
> -			if (IS_ERR(eb)) {
> -				ret = PTR_ERR(eb);
> -				goto out;
> -			} else if (!extent_buffer_uptodate(eb)) {
> -				free_extent_buffer(eb);
> -				ret = -EIO;
> -				goto out;
> -			}
> -
> -			path->nodes[level] = eb;
> -			path->slots[level] = 0;
> -
> -			btrfs_tree_read_lock(eb);
> -			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> -			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
> -
> -			ret = btrfs_qgroup_trace_extent(trans,
> -					root->fs_info, child_bytenr,
> -					root->nodesize, GFP_NOFS);
> -			if (ret)
> -				goto out;
> -		}
> -
> -		if (level == 0) {
> -			ret = account_leaf_items(trans, root, path->nodes[level]);
> -			if (ret)
> -				goto out;
> -
> -			/* Nonzero return here means we completed our search */
> -			ret = adjust_slots_upwards(root, path, root_level);
> -			if (ret)
> -				break;
> -
> -			/* Restart search with new slots */
> -			goto walk_down;
> -		}
> -
> -		level--;
> -	}
> -
> -	ret = 0;
> -out:
> -	btrfs_free_path(path);
> -
> -	return ret;
> -}
> -
>  /*
>   * helper to process tree block while walking down the tree.
>   *
> @@ -8977,8 +8763,8 @@ skip:
>  		}
>  
>  		if (need_account) {
> -			ret = account_shared_subtree(trans, root, next,
> -						     generation, level - 1);
> +			ret = btrfs_qgroup_trace_subtree(trans, root, next,
> +							 generation, level - 1);
>  			if (ret) {
>  				btrfs_err_rl(root->fs_info,
>  					     "Error %d accounting shared subtree. Quota is out of sync, rescan required.",
> @@ -9075,7 +8861,7 @@ static noinline int walk_up_proc(struct btrfs_trans_handle *trans,
>  			else
>  				ret = btrfs_dec_ref(trans, root, eb, 0);
>  			BUG_ON(ret); /* -ENOMEM */
> -			ret = account_leaf_items(trans, root, eb);
> +			ret = btrfs_qgroup_trace_leaf_items(trans, root, eb);
>  			if (ret) {
>  				btrfs_err_rl(root->fs_info,
>  					     "error %d accounting leaf items. Quota is out of sync, rescan required.",
> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
> index e73eea3..e97f304 100644
> --- a/fs/btrfs/qgroup.c
> +++ b/fs/btrfs/qgroup.c
> @@ -1510,6 +1510,217 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>  	return 0;
>  }
>  
> +int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
> +				  struct btrfs_root *root,
> +				  struct extent_buffer *eb)
> +{
> +	int nr = btrfs_header_nritems(eb);
> +	int i, extent_type, ret;
> +	struct btrfs_key key;
> +	struct btrfs_file_extent_item *fi;
> +	u64 bytenr, num_bytes;
> +
> +	/* We can be called directly from walk_up_proc() */
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags))
> +		return 0;
> +
> +	for (i = 0; i < nr; i++) {
> +		btrfs_item_key_to_cpu(eb, &key, i);
> +
> +		if (key.type != BTRFS_EXTENT_DATA_KEY)
> +			continue;
> +
> +		fi = btrfs_item_ptr(eb, i, struct btrfs_file_extent_item);
> +		/* filter out non qgroup-accountable extents  */
> +		extent_type = btrfs_file_extent_type(eb, fi);
> +
> +		if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> +			continue;
> +
> +		bytenr = btrfs_file_extent_disk_bytenr(eb, fi);
> +		if (!bytenr)
> +			continue;
> +
> +		num_bytes = btrfs_file_extent_disk_num_bytes(eb, fi);
> +
> +		ret = btrfs_qgroup_trace_extent(trans, root->fs_info,
> +						bytenr, num_bytes, GFP_NOFS);
> +		if (ret)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Walk up the tree from the bottom, freeing leaves and any interior
> + * nodes which have had all slots visited. If a node (leaf or
> + * interior) is freed, the node above it will have it's slot
> + * incremented. The root node will never be freed.
> + *
> + * At the end of this function, we should have a path which has all
> + * slots incremented to the next position for a search. If we need to
> + * read a new node it will be NULL and the node above it will have the
> + * correct slot selected for a later read.
> + *
> + * If we increment the root nodes slot counter past the number of
> + * elements, 1 is returned to signal completion of the search.
> + */
> +static int adjust_slots_upwards(struct btrfs_root *root,
> +				struct btrfs_path *path, int root_level)
> +{
> +	int level = 0;
> +	int nr, slot;
> +	struct extent_buffer *eb;
> +
> +	if (root_level == 0)
> +		return 1;
> +
> +	while (level <= root_level) {
> +		eb = path->nodes[level];
> +		nr = btrfs_header_nritems(eb);
> +		path->slots[level]++;
> +		slot = path->slots[level];
> +		if (slot >= nr || level == 0) {
> +			/*
> +			 * Don't free the root -  we will detect this
> +			 * condition after our loop and return a
> +			 * positive value for caller to stop walking the tree.
> +			 */
> +			if (level != root_level) {
> +				btrfs_tree_unlock_rw(eb, path->locks[level]);
> +				path->locks[level] = 0;
> +
> +				free_extent_buffer(eb);
> +				path->nodes[level] = NULL;
> +				path->slots[level] = 0;
> +			}
> +		} else {
> +			/*
> +			 * We have a valid slot to walk back down
> +			 * from. Stop here so caller can process these
> +			 * new nodes.
> +			 */
> +			break;
> +		}
> +
> +		level++;
> +	}
> +
> +	eb = path->nodes[root_level];
> +	if (path->slots[root_level] >= btrfs_header_nritems(eb))
> +		return 1;
> +
> +	return 0;
> +}
> +
> +int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root,
> +			       struct extent_buffer *root_eb,
> +			       u64 root_gen, int root_level)
> +{
> +	int ret = 0;
> +	int level;
> +	struct extent_buffer *eb = root_eb;
> +	struct btrfs_path *path = NULL;
> +
> +	BUG_ON(root_level < 0 || root_level > BTRFS_MAX_LEVEL);
> +	BUG_ON(root_eb == NULL);
> +
> +	if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &root->fs_info->flags))
> +		return 0;
> +
> +	if (!extent_buffer_uptodate(root_eb)) {
> +		ret = btrfs_read_buffer(root_eb, root_gen);
> +		if (ret)
> +			goto out;
> +	}
> +
> +	if (root_level == 0) {
> +		ret = btrfs_qgroup_trace_leaf_items(trans, root, root_eb);
> +		goto out;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	/*
> +	 * Walk down the tree.  Missing extent blocks are filled in as
> +	 * we go. Metadata is accounted every time we read a new
> +	 * extent block.
> +	 *
> +	 * When we reach a leaf, we account for file extent items in it,
> +	 * walk back up the tree (adjusting slot pointers as we go)
> +	 * and restart the search process.
> +	 */
> +	extent_buffer_get(root_eb); /* For path */
> +	path->nodes[root_level] = root_eb;
> +	path->slots[root_level] = 0;
> +	path->locks[root_level] = 0; /* so release_path doesn't try to unlock */
> +walk_down:
> +	level = root_level;
> +	while (level >= 0) {
> +		if (path->nodes[level] == NULL) {
> +			int parent_slot;
> +			u64 child_gen;
> +			u64 child_bytenr;
> +
> +			/* We need to get child blockptr/gen from
> +			 * parent before we can read it. */
> +			eb = path->nodes[level + 1];
> +			parent_slot = path->slots[level + 1];
> +			child_bytenr = btrfs_node_blockptr(eb, parent_slot);
> +			child_gen = btrfs_node_ptr_generation(eb, parent_slot);
> +
> +			eb = read_tree_block(root, child_bytenr, child_gen);
> +			if (IS_ERR(eb)) {
> +				ret = PTR_ERR(eb);
> +				goto out;
> +			} else if (!extent_buffer_uptodate(eb)) {
> +				free_extent_buffer(eb);
> +				ret = -EIO;
> +				goto out;
> +			}
> +
> +			path->nodes[level] = eb;
> +			path->slots[level] = 0;
> +
> +			btrfs_tree_read_lock(eb);
> +			btrfs_set_lock_blocking_rw(eb, BTRFS_READ_LOCK);
> +			path->locks[level] = BTRFS_READ_LOCK_BLOCKING;
> +
> +			ret = btrfs_qgroup_trace_extent(trans,
> +					root->fs_info, child_bytenr,
> +					root->nodesize, GFP_NOFS);
> +			if (ret)
> +				goto out;
> +		}
> +
> +		if (level == 0) {
> +			ret = btrfs_qgroup_trace_leaf_items(trans, root,
> +					path->nodes[level]);
> +			if (ret)
> +				goto out;
> +
> +			/* Nonzero return here means we completed our search */
> +			ret = adjust_slots_upwards(root, path, root_level);
> +			if (ret)
> +				break;
> +
> +			/* Restart search with new slots */
> +			goto walk_down;
> +		}
> +
> +		level--;
> +	}
> +
> +	ret = 0;
> +out:
> +	btrfs_free_path(path);
> +
> +	return ret;
> +}
> +
>  #define UPDATE_NEW	0
>  #define UPDATE_OLD	1
>  /*
> diff --git a/fs/btrfs/qgroup.h b/fs/btrfs/qgroup.h
> index 9303e09..99c879d 100644
> --- a/fs/btrfs/qgroup.h
> +++ b/fs/btrfs/qgroup.h
> @@ -122,6 +122,29 @@ int btrfs_qgroup_trace_extent(struct btrfs_trans_handle *trans,
>  		struct btrfs_fs_info *fs_info, u64 bytenr, u64 num_bytes,
>  		gfp_t gfp_flag);
>  
> +/*
> + * Inform qgroup to trace all leaf items of data
> + *
> + * Return 0 for success
> + * Return <0 for error(ENOMEM)
> + */
> +int btrfs_qgroup_trace_leaf_items(struct btrfs_trans_handle *trans,
> +				  struct btrfs_root *root,
> +				  struct extent_buffer *eb);
> +/*
> + * Inform qgroup to trace a whole subtree, including all its child tree
> + * blocks and data.
> + * The root tree block is specified by @root_eb.
> + *
> + * Normally used by relocation(tree block swap) and subvolume deletion.
> + *
> + * Return 0 for success
> + * Return <0 for error(ENOMEM or tree search error)
> + */
> +int btrfs_qgroup_trace_subtree(struct btrfs_trans_handle *trans,
> +			       struct btrfs_root *root,
> +			       struct extent_buffer *root_eb,
> +			       u64 root_gen, int root_level);
>  int
>  btrfs_qgroup_account_extent(struct btrfs_trans_handle *trans,
>  			    struct btrfs_fs_info *fs_info,
> 

-- 
Goldwyn
