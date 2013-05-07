Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:22959 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3EGHQI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 May 2013 03:16:08 -0400
Message-ID: <5188AA34.1090804@jan-o-sch.net>
Date: Tue, 07 May 2013 09:16:04 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix passing wrong arg gfp_t to decide the correct
 allocation mode
References: <51889D15.9050308@cn.fujitsu.com>
In-Reply-To: <51889D15.9050308@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 07, 2013 at 08:20 (+0200), Wang Shilong wrote:
> If you look the code carefully, you will see all the tree_mod_alloc()
> has to use GFP_ATOMIC. However, the original code pass the wrong arg
> gfp_t in some places, this dosen't cause any problems, because in the
> tree_mod_alloc(), it ignores arg gfp_t and just use GFP_ATOMIC directly,
> this is not good.
> 
> However, i think we should try best not to allocate with GFP_ATOMIC, so
> i keep the gfp_t there in the hope we can change allocation mode in the
> future.

NAK.

The code as it is now is prepared to get rid of at least some GFP_ATOMIC
allocations. You won't get rid of all of them, as there are a lot of spin lock
situations where we need to add to the tree mod lock anyway.

As a preparation we currently pass the "best" flags (least restrictive) we can
instead of always passing GFP_ATOMIC. I pointed you to this comment already:

 557         /*
 558          * once we switch from spin locks to something different, we should
 559          * honor the flags parameter here.
 560          */
 561         tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);

So, if you want less atomic allocations, find something more suitable than an
rwlock for fs_info->tree_mod_log_lock an you can in fact replace "GFP_ATOMIC"
with "flags" in the kzalloc().

The good thing is, because everything is already prepared you don't have to
think about all the callers again an pass the correct flags.

-Jan


> Signed-off-by: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.c |   37 ++++++++++++++++++-------------------
>  1 files changed, 18 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index de6de8e..33c9061 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -553,7 +553,7 @@ static inline int tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags,
>  	 * once we switch from spin locks to something different, we should
>  	 * honor the flags parameter here.
>  	 */
> -	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
> +	tm = *tm_ret = kzalloc(sizeof(*tm), flags);
>  	if (!tm)
>  		return -ENOMEM;
>  
> @@ -591,14 +591,14 @@ __tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
>  static noinline int
>  tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
>  			     struct extent_buffer *eb, int slot,
> -			     enum mod_log_op op, gfp_t flags)
> +			     enum mod_log_op op)
>  {
>  	int ret;
>  
>  	if (tree_mod_dont_log(fs_info, eb))
>  		return 0;
>  
> -	ret = __tree_mod_log_insert_key(fs_info, eb, slot, op, flags);
> +	ret = __tree_mod_log_insert_key(fs_info, eb, slot, op, GFP_ATOMIC);
>  
>  	tree_mod_log_write_unlock(fs_info);
>  	return ret;
> @@ -608,7 +608,7 @@ static noinline int
>  tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  			int slot, enum mod_log_op op)
>  {
> -	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op, GFP_NOFS);
> +	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op);
>  }
>  
>  static noinline int
> @@ -616,13 +616,13 @@ tree_mod_log_insert_key_locked(struct btrfs_fs_info *fs_info,
>  			     struct extent_buffer *eb, int slot,
>  			     enum mod_log_op op)
>  {
> -	return __tree_mod_log_insert_key(fs_info, eb, slot, op, GFP_NOFS);
> +	return __tree_mod_log_insert_key(fs_info, eb, slot, op, GFP_ATOMIC);
>  }
>  
>  static noinline int
>  tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>  			 struct extent_buffer *eb, int dst_slot, int src_slot,
> -			 int nr_items, gfp_t flags)
> +			 int nr_items)
>  {
>  	struct tree_mod_elem *tm;
>  	int ret;
> @@ -642,7 +642,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>  		BUG_ON(ret < 0);
>  	}
>  
> -	ret = tree_mod_alloc(fs_info, flags, &tm);
> +	ret = tree_mod_alloc(fs_info, GFP_ATOMIC, &tm);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -679,7 +679,7 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
>  static noinline int
>  tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  			 struct extent_buffer *old_root,
> -			 struct extent_buffer *new_root, gfp_t flags,
> +			 struct extent_buffer *new_root,
>  			 int log_removal)
>  {
>  	struct tree_mod_elem *tm;
> @@ -691,7 +691,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  	if (log_removal)
>  		__tree_mod_log_free_eb(fs_info, old_root);
>  
> -	ret = tree_mod_alloc(fs_info, flags, &tm);
> +	ret = tree_mod_alloc(fs_info, GFP_ATOMIC, &tm);
>  	if (ret < 0)
>  		goto out;
>  
> @@ -809,19 +809,18 @@ tree_mod_log_eb_move(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>  {
>  	int ret;
>  	ret = tree_mod_log_insert_move(fs_info, dst, dst_offset, src_offset,
> -				       nr_items, GFP_NOFS);
> +				       nr_items);
>  	BUG_ON(ret < 0);
>  }
>  
>  static noinline void
>  tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
> -			  struct extent_buffer *eb, int slot, int atomic)
> +			  struct extent_buffer *eb, int slot)
>  {
>  	int ret;
>  
>  	ret = tree_mod_log_insert_key_mask(fs_info, eb, slot,
> -					   MOD_LOG_KEY_REPLACE,
> -					   atomic ? GFP_ATOMIC : GFP_NOFS);
> +					   MOD_LOG_KEY_REPLACE);
>  	BUG_ON(ret < 0);
>  }
>  
> @@ -843,7 +842,7 @@ tree_mod_log_set_root_pointer(struct btrfs_root *root,
>  {
>  	int ret;
>  	ret = tree_mod_log_insert_root(root->fs_info, root->node,
> -				       new_root_node, GFP_NOFS, log_removal);
> +				       new_root_node, log_removal);
>  	BUG_ON(ret < 0);
>  }
>  
> @@ -1886,7 +1885,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  			struct btrfs_disk_key right_key;
>  			btrfs_node_key(right, &right_key, 0);
>  			tree_mod_log_set_node_key(root->fs_info, parent,
> -						  pslot + 1, 0);
> +						  pslot + 1);
>  			btrfs_set_node_key(parent, &right_key, pslot + 1);
>  			btrfs_mark_buffer_dirty(parent);
>  		}
> @@ -1931,7 +1930,7 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  		struct btrfs_disk_key mid_key;
>  		btrfs_node_key(mid, &mid_key, 0);
>  		tree_mod_log_set_node_key(root->fs_info, parent,
> -					  pslot, 0);
> +					  pslot);
>  		btrfs_set_node_key(parent, &mid_key, pslot);
>  		btrfs_mark_buffer_dirty(parent);
>  	}
> @@ -2030,7 +2029,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  			orig_slot += left_nr;
>  			btrfs_node_key(mid, &disk_key, 0);
>  			tree_mod_log_set_node_key(root->fs_info, parent,
> -						  pslot, 0);
> +						  pslot);
>  			btrfs_set_node_key(parent, &disk_key, pslot);
>  			btrfs_mark_buffer_dirty(parent);
>  			if (btrfs_header_nritems(left) > orig_slot) {
> @@ -2083,7 +2082,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  
>  			btrfs_node_key(right, &disk_key, 0);
>  			tree_mod_log_set_node_key(root->fs_info, parent,
> -						  pslot + 1, 0);
> +						  pslot + 1);
>  			btrfs_set_node_key(parent, &disk_key, pslot + 1);
>  			btrfs_mark_buffer_dirty(parent);
>  
> @@ -2963,7 +2962,7 @@ static void fixup_low_keys(struct btrfs_root *root, struct btrfs_path *path,
>  		if (!path->nodes[i])
>  			break;
>  		t = path->nodes[i];
> -		tree_mod_log_set_node_key(root->fs_info, t, tslot, 1);
> +		tree_mod_log_set_node_key(root->fs_info, t, tslot);
>  		btrfs_set_node_key(t, key, tslot);
>  		btrfs_mark_buffer_dirty(path->nodes[i]);
>  		if (tslot != 0)
> 
