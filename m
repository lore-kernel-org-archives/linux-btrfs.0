Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34206 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbeCHPhg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 10:37:36 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 815E0ADDF
        for <linux-btrfs@vger.kernel.org>; Thu,  8 Mar 2018 15:37:35 +0000 (UTC)
Subject: Re: [PATCH 14/22] btrfs: remove trivial locking wrappers of tree mod
 log
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1520518876.git.dsterba@suse.com>
 <4888ae25fe8e1f1f87f3187dc199eed4799a3a99.1520518876.git.dsterba@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <4a72bdae-2a5a-e4e4-1cb0-086b3ddd9857@suse.com>
Date: Thu, 8 Mar 2018 17:37:33 +0200
MIME-Version: 1.0
In-Reply-To: <4888ae25fe8e1f1f87f3187dc199eed4799a3a99.1520518876.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  8.03.2018 16:33, David Sterba wrote:
> The wrappers are trivial and do bring any extra value on top of the

nit: s/do/don't/ ?

> plain locking primitives.
> 
> Signed-off-by: David Sterba <dsterba@suse.com>

Just 2 minor nits, otherwise LGTM:

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/ctree.c | 58 +++++++++++++++++++-------------------------------------
>  1 file changed, 19 insertions(+), 39 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 716c140798c3..7d39ef6ce20a 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -330,26 +330,6 @@ struct tree_mod_elem {
>  	struct tree_mod_root old_root;
>  };
>  
> -static inline void tree_mod_log_read_lock(struct btrfs_fs_info *fs_info)
> -{
> -	read_lock(&fs_info->tree_mod_log_lock);
> -}
> -
> -static inline void tree_mod_log_read_unlock(struct btrfs_fs_info *fs_info)
> -{
> -	read_unlock(&fs_info->tree_mod_log_lock);
> -}
> -
> -static inline void tree_mod_log_write_lock(struct btrfs_fs_info *fs_info)
> -{
> -	write_lock(&fs_info->tree_mod_log_lock);
> -}
> -
> -static inline void tree_mod_log_write_unlock(struct btrfs_fs_info *fs_info)
> -{
> -	write_unlock(&fs_info->tree_mod_log_lock);
> -}
> -
>  /*
>   * Pull a new tree mod seq number for our operation.
>   */
> @@ -369,14 +349,14 @@ static inline u64 btrfs_inc_tree_mod_seq(struct btrfs_fs_info *fs_info)
>  u64 btrfs_get_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  			   struct seq_list *elem)
>  {
> -	tree_mod_log_write_lock(fs_info);
> +	write_lock(&fs_info->tree_mod_log_lock);
>  	spin_lock(&fs_info->tree_mod_seq_lock);
>  	if (!elem->seq) {
>  		elem->seq = btrfs_inc_tree_mod_seq(fs_info);
>  		list_add_tail(&elem->list, &fs_info->tree_mod_seq_list);
>  	}
>  	spin_unlock(&fs_info->tree_mod_seq_lock);
> -	tree_mod_log_write_unlock(fs_info);
> +	write_unlock(&fs_info->tree_mod_log_lock);
>  
>  	return elem->seq;
>  }
> @@ -418,7 +398,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  	 * anything that's lower than the lowest existing (read: blocked)
>  	 * sequence number can be removed from the tree.
>  	 */
> -	tree_mod_log_write_lock(fs_info);
> +	write_lock(&fs_info->tree_mod_log_lock);
>  	tm_root = &fs_info->tree_mod_log;
>  	for (node = rb_first(tm_root); node; node = next) {
>  		next = rb_next(node);
> @@ -428,7 +408,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
>  		rb_erase(node, tm_root);
>  		kfree(tm);
>  	}
> -	tree_mod_log_write_unlock(fs_info);
> +	write_unlock(&fs_info->tree_mod_log_lock);
>  }
>  
>  /*
> @@ -439,7 +419,7 @@ void btrfs_put_tree_mod_seq(struct btrfs_fs_info *fs_info,
>   * for root replace operations, or the logical address of the affected
>   * block for all other operations.
>   *
> - * Note: must be called with write lock (tree_mod_log_write_lock).
> + * Note: must be called with write lock for fs_info_;;tree_mod_log_lock.
nit: s/;;/::/
>   */
>  static noinline int
>  __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
> @@ -477,7 +457,7 @@ __tree_mod_log_insert(struct btrfs_fs_info *fs_info, struct tree_mod_elem *tm)
>   * Determines if logging can be omitted. Returns 1 if it can. Otherwise, it
>   * returns zero with the tree_mod_log_lock acquired. The caller must hold
>   * this until all tree mod log insertions are recorded in the rb tree and then
> - * call tree_mod_log_write_unlock() to release.
> + * write unlock fs_info::tree_mod_log_lock.
>   */
>  static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
>  				    struct extent_buffer *eb) {
> @@ -487,9 +467,9 @@ static inline int tree_mod_dont_log(struct btrfs_fs_info *fs_info,
>  	if (eb && btrfs_header_level(eb) == 0)
>  		return 1;
>  
> -	tree_mod_log_write_lock(fs_info);
> +	write_lock(&fs_info->tree_mod_log_lock);
>  	if (list_empty(&(fs_info)->tree_mod_seq_list)) {
> -		tree_mod_log_write_unlock(fs_info);
> +		write_unlock(&fs_info->tree_mod_log_lock);
>  		return 1;
>  	}
>  
> @@ -551,7 +531,7 @@ static noinline int tree_mod_log_insert_key(struct extent_buffer *eb, int slot,
>  	}
>  
>  	ret = __tree_mod_log_insert(eb->fs_info, tm);
> -	tree_mod_log_write_unlock(eb->fs_info);
> +	write_unlock(&eb->fs_info->tree_mod_log_lock);
>  	if (ret)
>  		kfree(tm);
>  
> @@ -613,7 +593,7 @@ static noinline int tree_mod_log_insert_move(struct extent_buffer *eb,
>  	ret = __tree_mod_log_insert(eb->fs_info, tm);
>  	if (ret)
>  		goto free_tms;
> -	tree_mod_log_write_unlock(eb->fs_info);
> +	write_unlock(&eb->fs_info->tree_mod_log_lock);
>  	kfree(tm_list);
>  
>  	return 0;
> @@ -624,7 +604,7 @@ static noinline int tree_mod_log_insert_move(struct extent_buffer *eb,
>  		kfree(tm_list[i]);
>  	}
>  	if (locked)
> -		tree_mod_log_write_unlock(eb->fs_info);
> +		write_unlock(&eb->fs_info->tree_mod_log_lock);
>  	kfree(tm_list);
>  	kfree(tm);
>  
> @@ -703,7 +683,7 @@ static noinline int tree_mod_log_insert_root(struct extent_buffer *old_root,
>  	if (!ret)
>  		ret = __tree_mod_log_insert(fs_info, tm);
>  
> -	tree_mod_log_write_unlock(fs_info);
> +	write_unlock(&fs_info->tree_mod_log_lock);
>  	if (ret)
>  		goto free_tms;
>  	kfree(tm_list);
> @@ -730,7 +710,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
>  	struct tree_mod_elem *cur = NULL;
>  	struct tree_mod_elem *found = NULL;
>  
> -	tree_mod_log_read_lock(fs_info);
> +	read_lock(&fs_info->tree_mod_log_lock);
>  	tm_root = &fs_info->tree_mod_log;
>  	node = tm_root->rb_node;
>  	while (node) {
> @@ -758,7 +738,7 @@ __tree_mod_log_search(struct btrfs_fs_info *fs_info, u64 start, u64 min_seq,
>  			break;
>  		}
>  	}
> -	tree_mod_log_read_unlock(fs_info);
> +	read_unlock(&fs_info->tree_mod_log_lock);
>  
>  	return found;
>  }
> @@ -839,7 +819,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>  			goto free_tms;
>  	}
>  
> -	tree_mod_log_write_unlock(fs_info);
> +	write_unlock(&fs_info->tree_mod_log_lock);
>  	kfree(tm_list);
>  
>  	return 0;
> @@ -851,7 +831,7 @@ tree_mod_log_eb_copy(struct btrfs_fs_info *fs_info, struct extent_buffer *dst,
>  		kfree(tm_list[i]);
>  	}
>  	if (locked)
> -		tree_mod_log_write_unlock(fs_info);
> +		write_unlock(&fs_info->tree_mod_log_lock);
>  	kfree(tm_list);
>  
>  	return ret;
> @@ -906,7 +886,7 @@ static noinline int tree_mod_log_free_eb(struct extent_buffer *eb)
>  		goto free_tms;
>  
>  	ret = __tree_mod_log_free_eb(eb->fs_info, tm_list, nritems);
> -	tree_mod_log_write_unlock(eb->fs_info);
> +	write_unlock(&eb->fs_info->tree_mod_log_lock);
>  	if (ret)
>  		goto free_tms;
>  	kfree(tm_list);
> @@ -1262,7 +1242,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  	unsigned long p_size = sizeof(struct btrfs_key_ptr);
>  
>  	n = btrfs_header_nritems(eb);
> -	tree_mod_log_read_lock(fs_info);
> +	read_lock(&fs_info->tree_mod_log_lock);
>  	while (tm && tm->seq >= time_seq) {
>  		/*
>  		 * all the operations are recorded with the operator used for
> @@ -1317,7 +1297,7 @@ __tree_mod_log_rewind(struct btrfs_fs_info *fs_info, struct extent_buffer *eb,
>  		if (tm->logical != first_tm->logical)
>  			break;
>  	}
> -	tree_mod_log_read_unlock(fs_info);
> +	read_unlock(&fs_info->tree_mod_log_lock);
>  	btrfs_set_header_nritems(eb, n);
>  }
>  
> 
