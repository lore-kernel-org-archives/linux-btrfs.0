Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:44476 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477Ab3GBHf3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Jul 2013 03:35:29 -0400
Message-ID: <51D282C0.5040201@jan-o-sch.net>
Date: Tue, 02 Jul 2013 09:35:28 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: stop using GFP_ATOMIC for the tree mod log allocations
References: <1372710317-9739-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1372710317-9739-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, July 01, 2013 at 22:25 (+0200), Josef Bacik wrote:
> Previously we held the tree mod lock when adding stuff because we use it to
> check and see if we truly do want to track tree modifications.  This is
> admirable, but GFP_ATOMIC in a critical area that is going to get hit pretty
> hard and often is not nice.  So instead do our basic checks to see if we don't
> need to track modifications, and if those pass then do our allocation, and then
> when we go to insert the new modification check if we still care, and if we
> don't just free up our mod and return.  Otherwise we're good to go and we can
> carry on.  Thanks,

I'd like to look at a side-by-side diff of that patch in my editor. However, it
does not apply to your current master branch, and git even refuses trying a
3-way-merge because your "Repository lacks necessary blobs". Can you please push
something?

Thanks,
-Jan

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/ctree.c |  161 ++++++++++++++++++------------------------------------
>  1 files changed, 54 insertions(+), 107 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 127e1fd..fff08f9 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -484,8 +484,27 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>  	struct rb_node **new;
>  	struct rb_node *parent = NULL;
>  	struct tree_mod_elem *cur;
> +	int ret = 0;
> +
> +	BUG_ON(!tm);
> +
> +	tree_mod_log_write_lock(fs_info);
> +	if (list_empty(&fs_info->tree_mod_seq_list)) {
> +		tree_mod_log_write_unlock(fs_info);
> +		/*
> +		 * Ok we no longer care about logging modifications, free up tm
> +		 * and return 0.  Any callers shouldn't be using tm after
> +		 * calling tree_mod_log_insert, but if they do we can just
> +		 * change this to return a special error code to let the callers
> +		 * do their own thing.
> +		 */
> +		kfree(tm);
> +		return 0;
> +	}
>  
> -	BUG_ON(!tm || !tm->seq);
> +	spin_lock(&fs_info->tree_mod_seq_lock);
> +	tm->seq = btrfs_inc_tree_mod_seq_minor(fs_info);
> +	spin_unlock(&fs_info->tree_mod_seq_lock);
>  
>  	tm_root = &fs_info->tree_mod_log;
>  	new = &tm_root->rb_node;
> @@ -501,14 +520,17 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>  		else if (cur->seq > tm->seq)
>  			new = &((*new)->rb_right);
>  		else {
> +			ret = -EEXIST;
>  			kfree(tm);
> -			return -EEXIST;
> +			goto out;
>  		}
>  	}
>  
>  	rb_link_node(&tm->node, parent, new);
>  	rb_insert_color(&tm->node, tm_root);
> -	return 0;
> +out:
> +	tree_mod_log_write_unlock(fs_info);
> +	return ret;
>  }
>  
>  /*
> @@ -524,55 +546,17 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
>  		return 1;
>  	if (eb && btrfs_header_level(eb) == 0)
>  		return 1;
> -
> -	tree_mod_log_write_lock(fs_info);
> -	if (list_empty(&fs_info->tree_mod_seq_list)) {
> -		/*
> -		 * someone emptied the list while we were waiting for the lock.
> -		 * we must not add to the list when no blocker exists.
> -		 */
> -		tree_mod_log_write_unlock(fs_info);
> -		return 1;
> -	}
> -
>  	return 0;
>  }
>  
> -/*
> - * This allocates memory and gets a tree modification sequence number.
> - *
> - * Returns <0 on error.
> - * Returns >0 (the added sequence number) on success.
> - */
> -static inline struct tree_mod_elem *
> -tree_mod_alloc(struct btrfs_fs_info *fs_info, gfp_t flags)
> -{
> -	struct tree_mod_elem *tm;
> -
> -	/*
> -	 * once we switch from spin locks to something different, we should
> -	 * honor the flags parameter here.
> -	 */
> -	tm = *tm_ret = kzalloc(sizeof(*tm), GFP_ATOMIC);
> -	if (!tm)
> -		return NULL;
> -
> -	spin_lock(&fs_info->tree_mod_seq_lock);
> -	tm->seq = btrfs_inc_tree_mod_seq_minor(fs_info);
> -	spin_unlock(&fs_info->tree_mod_seq_lock);
> -
> -	return tm;
> -}
> -
>  static inline int
>  __tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
>  			  struct extent_buffer *eb, int slot,
>  			  enum mod_log_op op, gfp_t flags)
>  {
> -	int ret;
>  	struct tree_mod_elem *tm;
>  
> -	tm = tree_mod_alloc(fs_info, flags);
> +	tm = kzalloc(sizeof(*tm), flags);
>  	if (!tm)
>  		return -ENOMEM;
>  
> @@ -589,34 +573,14 @@ __tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
>  }
>  
>  static noinline int
> -tree_mod_log_insert_key_mask(struct btrfs_fs_info *fs_info,
> -			     struct extent_buffer *eb, int slot,
> -			     enum mod_log_op op, gfp_t flags)
> +tree_mod_log_insert_key(struct btrfs_fs_info *fs_info,
> +			struct extent_buffer *eb, int slot,
> +			enum mod_log_op op, gfp_t flags)
>  {
> -	int ret;
> -
>  	if (tree_mod_dont_log(fs_info, eb))
>  		return 0;
>  
> -	ret = __tree_mod_log_insert_key(fs_info, eb, slot, op, flags);
> -
> -	tree_mod_log_write_unlock(fs_info);
> -	return ret;
> -}
> -
> -static noinline int
> -tree_mod_log_insert_key(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
> -			int slot, enum mod_log_op op)
> -{
> -	return tree_mod_log_insert_key_mask(fs_info, eb, slot, op, GFP_NOFS);
> -}
> -
> -static noinline int
> -tree_mod_log_insert_key_locked(struct btrfs_fs_info *fs_info,
> -			     struct extent_buffer *eb, int slot,
> -			     enum mod_log_op op)
> -{
> -	return __tree_mod_log_insert_key(fs_info, eb, slot, op, GFP_NOFS);
> +	return __tree_mod_log_insert_key(fs_info, eb, slot, op, flags);
>  }
>  
>  static noinline int
> @@ -637,16 +601,14 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>  	 * buffer, i.e. dst_slot < src_slot.
>  	 */
>  	for (i = 0; i + dst_slot < src_slot && i < nr_items; i++) {
> -		ret = tree_mod_log_insert_key_locked(fs_info, eb, i + dst_slot,
> -					      MOD_LOG_KEY_REMOVE_WHILE_MOVING);
> +		ret = __tree_mod_log_insert_key(fs_info, eb, i + dst_slot,
> +				MOD_LOG_KEY_REMOVE_WHILE_MOVING, GFP_NOFS);
>  		BUG_ON(ret < 0);
>  	}
>  
> -	tm = tree_mod_alloc(fs_info, flags);
> -	if (!tm) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	tm = kzalloc(sizeof(*tm), flags);
> +	if (!tm)
> +		return -ENOMEM;
>  
>  	tm->index = eb->start >> PAGE_CACHE_SHIFT;
>  	tm->slot = src_slot;
> @@ -654,10 +616,7 @@ tree_mod_log_insert_move(struct btrfs_fs_info *fs_info,
>  	tm->move.nr_items = nr_items;
>  	tm->op = MOD_LOG_MOVE_KEYS;
>  
> -	ret = __tree_mod_log_insert(fs_info, tm);
> -out:
> -	tree_mod_log_write_unlock(fs_info);
> -	return ret;
> +	return __tree_mod_log_insert(fs_info, tm);
>  }
>  
>  static inline void
> @@ -672,8 +631,8 @@ __tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
>  
>  	nritems = btrfs_header_nritems(eb);
>  	for (i = nritems - 1; i >= 0; i--) {
> -		ret = tree_mod_log_insert_key_locked(fs_info, eb, i,
> -					      MOD_LOG_KEY_REMOVE_WHILE_FREEING);
> +		ret = __tree_mod_log_insert_key(fs_info, eb, i,
> +				MOD_LOG_KEY_REMOVE_WHILE_FREEING, GFP_NOFS);
>  		BUG_ON(ret < 0);
>  	}
>  }
> @@ -685,7 +644,6 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  			 int log_removal)
>  {
>  	struct tree_mod_elem *tm;
> -	int ret;
>  
>  	if (tree_mod_dont_log(fs_info, NULL))
>  		return 0;
> @@ -693,11 +651,9 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  	if (log_removal)
>  		__tree_mod_log_free_eb(fs_info, old_root);
>  
> -	tm = tree_mod_alloc(fs_info, flags);
> -	if (!tm) {
> -		ret = -ENOMEM;
> -		goto out;
> -	}
> +	tm = kzalloc(sizeof(*tm), flags);
> +	if (!tm)
> +		return -ENOMEM;
>  
>  	tm->index = new_root->start >> PAGE_CACHE_SHIFT;
>  	tm->old_root.logical = old_root->start;
> @@ -705,10 +661,7 @@ tree_mod_log_insert_root(struct btrfs_fs_info *fs_info,
>  	tm->generation = btrfs_header_generation(old_root);
>  	tm->op = MOD_LOG_ROOT_REPLACE;
>  
> -	ret = __tree_mod_log_insert(fs_info, tm);
> -out:
> -	tree_mod_log_write_unlock(fs_info);
> -	return ret;
> +	return __tree_mod_log_insert(fs_info, tm);
>  }
>  
>  static struct tree_mod_elem *
> @@ -788,23 +741,20 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>  	if (tree_mod_dont_log(fs_info, NULL))
>  		return;
>  
> -	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0) {
> -		tree_mod_log_write_unlock(fs_info);
> +	if (btrfs_header_level(dst) == 0 && btrfs_header_level(src) == 0)
>  		return;
> -	}
>  
>  	for (i = 0; i < nr_items; i++) {
> -		ret = tree_mod_log_insert_key_locked(fs_info, src,
> +		ret = __tree_mod_log_insert_key(fs_info, src,
>  						i + src_offset,
> -						MOD_LOG_KEY_REMOVE);
> +						MOD_LOG_KEY_REMOVE, GFP_NOFS);
>  		BUG_ON(ret < 0);
> -		ret = tree_mod_log_insert_key_locked(fs_info, dst,
> +		ret = __tree_mod_log_insert_key(fs_info, dst,
>  						     i + dst_offset,
> -						     MOD_LOG_KEY_ADD);
> +						     MOD_LOG_KEY_ADD,
> +						     GFP_NOFS);
>  		BUG_ON(ret < 0);
>  	}
> -
> -	tree_mod_log_write_unlock(fs_info);
>  }
>  
>  static inline void
> @@ -823,9 +773,9 @@ tree_mod_log_set_node_key(struct btrfs_fs_info *fs_info,
>  {
>  	int ret;
>  
> -	ret = tree_mod_log_insert_key_mask(fs_info, eb, slot,
> -					   MOD_LOG_KEY_REPLACE,
> -					   atomic ? GFP_ATOMIC : GFP_NOFS);
> +	ret = __tree_mod_log_insert_key(fs_info, eb, slot,
> +					MOD_LOG_KEY_REPLACE,
> +					atomic ? GFP_ATOMIC : GFP_NOFS);
>  	BUG_ON(ret < 0);
>  }
>  
> @@ -834,10 +784,7 @@ tree_mod_log_free_eb(struct btrfs_fs_info *fs_info, struct extent_buffer *eb)
>  {
>  	if (tree_mod_dont_log(fs_info, eb))
>  		return;
> -
>  	__tree_mod_log_free_eb(fs_info, eb);
> -
> -	tree_mod_log_write_unlock(fs_info);
>  }
>  
>  static noinline void
> @@ -1087,7 +1034,7 @@ static noinline int __btrfs_cow_block(struct btrfs_trans_handle *trans,
>  
>  		WARN_ON(trans->transid != btrfs_header_generation(parent));
>  		tree_mod_log_insert_key(root->fs_info, parent, parent_slot,
> -					MOD_LOG_KEY_REPLACE);
> +					MOD_LOG_KEY_REPLACE, GFP_NOFS);
>  		btrfs_set_node_blockptr(parent, parent_slot,
>  					cow->start);
>  		btrfs_set_node_ptr_generation(parent, parent_slot,
> @@ -3213,7 +3160,7 @@ static void insert_ptr(struct btrfs_trans_handle *trans,
>  	}
>  	if (level) {
>  		ret = tree_mod_log_insert_key(root->fs_info, lower, slot,
> -					      MOD_LOG_KEY_ADD);
> +					      MOD_LOG_KEY_ADD, GFP_NOFS);
>  		BUG_ON(ret < 0);
>  	}
>  	btrfs_set_node_key(lower, key, slot);
> @@ -4647,7 +4594,7 @@ static void del_ptr(struct btrfs_root *root, struct btrfs_path *path,
>  			      (nritems - slot - 1));
>  	} else if (level) {
>  		ret = tree_mod_log_insert_key(root->fs_info, parent, slot,
> -					      MOD_LOG_KEY_REMOVE);
> +					      MOD_LOG_KEY_REMOVE, GFP_NOFS);
>  		BUG_ON(ret < 0);
>  	}
>  
> 
