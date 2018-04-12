Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751819AbeDLNmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 12 Apr 2018 09:42:02 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A030BAD00
        for <linux-btrfs@vger.kernel.org>; Thu, 12 Apr 2018 13:42:01 +0000 (UTC)
Date: Thu, 12 Apr 2018 15:39:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Do first key check under proper lock context
Message-ID: <20180412133932.GK21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180412100003.31907-1-wqu@suse.com>
 <20180412100003.31907-2-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180412100003.31907-2-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 12, 2018 at 06:00:03PM +0800, Qu Wenruo wrote:
> The original first key check is handled in
> btree_read_extent_buffer_pages(), which is good enough for level check,
> but to verify first key, we need at least read lock on the extent
> buffer, or we can hit some race and cause false alert.
> 
> Fix it by adding new verifcation function: btrfs_verify_first_key(),
> which will first check lock context of both parent and child extent
> buffer, and only when we have proper lock hold (write or read lock if
> extent buffer is not in commit root) we will verify the first key.
> 
> Most of the verification happens in ctree.c after function call like
> read_tree_block(), read_node_slot() and read_block_for_search(), and
> only call btrfs_verify_first_key() after we acquire read/write lock.
> 
> Also, since first_key check is not as good as level and could easily
> trigger false alerts due to lock context, put it under
> CONFIG_BTRFS_FS_CHECK_INTEGRITY to avoid damage to end user.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/ctree.c       | 69 ++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ctree.h       | 58 +++++++++++++++++++++++++++++++++++
>  fs/btrfs/extent-tree.c |  6 ++++
>  fs/btrfs/qgroup.c      |  5 +++
>  fs/btrfs/ref-verify.c  |  6 ++++
>  fs/btrfs/relocation.c  | 13 ++++++++
>  6 files changed, 157 insertions(+)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index e044b51a2789..57721aead371 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1649,6 +1649,11 @@ int btrfs_realloc_node(struct btrfs_trans_handle *trans,
>  
>  		btrfs_tree_lock(cur);
>  		btrfs_set_lock_blocking(cur);
> +		if (btrfs_verify_first_key(cur, parent, i)) {
> +			err = -EUCLEAN;
> +			btrfs_tree_unlock(cur);
> +			free_extent_buffer(cur);
> +		}
>  		err = __btrfs_cow_block(trans, root, cur, parent, i,
>  					&cur, search_start,
>  					min(16 * blocksize,
> @@ -1863,6 +1868,12 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  
>  		btrfs_tree_lock(child);
>  		btrfs_set_lock_blocking(child);
> +		if (btrfs_verify_first_key(child, mid, 0)) {
> +			ret = -EUCLEAN;
> +			btrfs_tree_unlock(child);
> +			free_extent_buffer(child);
> +			goto enospc;
> +		}
>  		ret = btrfs_cow_block(trans, root, child, mid, 0, &child);
>  		if (ret) {
>  			btrfs_tree_unlock(child);
> @@ -1901,6 +1912,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  	if (left) {
>  		btrfs_tree_lock(left);
>  		btrfs_set_lock_blocking(left);
> +		if (btrfs_verify_first_key(left, parent, pslot - 1)) {
> +			ret = -EUCLEAN;
> +			goto enospc;
> +		}
>  		wret = btrfs_cow_block(trans, root, left,
>  				       parent, pslot - 1, &left);
>  		if (wret) {
> @@ -1916,6 +1931,10 @@ static noinline int balance_level(struct btrfs_trans_handle *trans,
>  	if (right) {
>  		btrfs_tree_lock(right);
>  		btrfs_set_lock_blocking(right);
> +		if (btrfs_verify_first_key(right, parent, pslot + 1)) {
> +			ret = -EUCLEAN;
> +			goto enospc;
> +		}
>  		wret = btrfs_cow_block(trans, root, right,
>  				       parent, pslot + 1, &right);
>  		if (wret) {
> @@ -2079,6 +2098,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  
>  		btrfs_tree_lock(left);
>  		btrfs_set_lock_blocking(left);
> +		if (btrfs_verify_first_key(left, parent, pslot - 1))
> +			goto left_out;
>  
>  		left_nr = btrfs_header_nritems(left);
>  		if (left_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
> @@ -2119,6 +2140,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  			}
>  			return 0;
>  		}
> +left_out:
>  		btrfs_tree_unlock(left);
>  		free_extent_buffer(left);
>  	}
> @@ -2134,6 +2156,8 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  
>  		btrfs_tree_lock(right);
>  		btrfs_set_lock_blocking(right);
> +		if (btrfs_verify_first_key(right, parent, pslot + 1))
> +			goto right_out;
>  
>  		right_nr = btrfs_header_nritems(right);
>  		if (right_nr >= BTRFS_NODEPTRS_PER_BLOCK(fs_info) - 1) {
> @@ -2174,6 +2198,7 @@ static noinline int push_nodes_for_insert(struct btrfs_trans_handle *trans,
>  			}
>  			return 0;
>  		}
> +right_out:
>  		btrfs_tree_unlock(right);
>  		free_extent_buffer(right);
>  	}
> @@ -2868,6 +2893,11 @@ int btrfs_search_slot(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>  					p->locks[level] = BTRFS_READ_LOCK;
>  				}
>  				p->nodes[level] = b;
> +				if (btrfs_verify_first_key(b, p->nodes[level + 1],
> +							   slot)) {
> +					ret = -EUCLEAN;
> +					goto done;
> +				}
>  			}
>  		} else {
>  			p->slots[level] = slot;
> @@ -2981,6 +3011,12 @@ int btrfs_search_old_slot(struct btrfs_root *root, const struct btrfs_key *key,
>  				goto done;
>  			}
>  
> +			/*
> +			 * NOTE: both parent and child go through
> +			 * tree_mod_log_rewind(), first key check is no
> +			 * longer consistent. So no btrfs_verify_first_key()
> +			 * for this read_block_for_search().
> +			 */
>  			err = read_block_for_search(root, p, &b, level,
>  						    slot, key);
>  			if (err == -EAGAIN)
> @@ -3753,6 +3789,8 @@ static int push_leaf_right(struct btrfs_trans_handle *trans, struct btrfs_root
>  
>  	btrfs_tree_lock(right);
>  	btrfs_set_lock_blocking(right);
> +	if (btrfs_verify_first_key(right, upper, slot + 1))
> +		goto out_unlock;
>  
>  	free_space = btrfs_leaf_free_space(fs_info, right);
>  	if (free_space < data_size)
> @@ -3987,6 +4025,10 @@ static int push_leaf_left(struct btrfs_trans_handle *trans, struct btrfs_root
>  
>  	btrfs_tree_lock(left);
>  	btrfs_set_lock_blocking(left);
> +	if (btrfs_verify_first_key(left, path->nodes[1], slot - 1)) {
> +		ret = 1;
> +		goto out;
> +	}
>  
>  	free_space = btrfs_leaf_free_space(fs_info, left);
>  	if (free_space < data_size) {
> @@ -5205,6 +5247,12 @@ int btrfs_search_forward(struct btrfs_root *root, struct btrfs_key *min_key,
>  		}
>  
>  		btrfs_tree_read_lock(cur);
> +		if (btrfs_verify_first_key(cur, path->nodes[level], slot)) {
> +			btrfs_tree_read_unlock(cur);
> +			free_extent_buffer(cur);
> +			ret = -EUCLEAN;
> +			goto out;
> +		}
>  
>  		path->locks[level - 1] = BTRFS_READ_LOCK;
>  		path->nodes[level - 1] = cur;
> @@ -5232,6 +5280,11 @@ static int tree_move_down(struct btrfs_fs_info *fs_info,
>  	if (IS_ERR(eb))
>  		return PTR_ERR(eb);
>  
> +	if (btrfs_verify_first_key(eb, path->nodes[*level],
> +				   path->slots[*level])) {
> +		free_extent_buffer(eb);
> +		return -EUCLEAN;
> +	}
>  	path->nodes[*level - 1] = eb;
>  	path->slots[*level - 1] = 0;
>  	(*level)--;
> @@ -5786,6 +5839,14 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>  							  BTRFS_READ_LOCK);
>  			}
>  			next_rw_lock = BTRFS_READ_LOCK;
> +			if (btrfs_verify_first_key(next, path->nodes[level],
> +						   slot)) {
> +				ret = -EUCLEAN;
> +				btrfs_tree_read_unlock(next);
> +				free_extent_buffer(next);
> +				btrfs_release_path(path);
> +				goto done;
> +			}
>  		}
>  		break;
>  	}
> @@ -5823,6 +5884,14 @@ int btrfs_next_old_leaf(struct btrfs_root *root, struct btrfs_path *path,
>  							  BTRFS_READ_LOCK);
>  			}
>  			next_rw_lock = BTRFS_READ_LOCK;
> +			if (btrfs_verify_first_key(next, path->nodes[level],
> +						   0)) {
> +				ret = -EUCLEAN;
> +				btrfs_tree_read_unlock(next);
> +				free_extent_buffer(next);
> +				btrfs_release_path(path);
> +				goto done;
> +			}
>  		}
>  	}
>  	ret = 0;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 0eb55825862a..033d8ae027c3 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -44,6 +44,7 @@
>  #include "extent_io.h"
>  #include "extent_map.h"
>  #include "async-thread.h"
> +#include "print-tree.h"
>  
>  struct btrfs_trans_handle;
>  struct btrfs_transaction;
> @@ -3752,4 +3753,61 @@ static inline int btrfs_is_testing(struct btrfs_fs_info *fs_info)
>  #endif
>  	return 0;
>  }
> +
> +/*
> + * Verify the first key of an extent buffer matches with its parent pointer.
> + *
> + * For tree blocks in current transaction, caller should hold at least read lock
> + * for both @eb and @parent to avoid race.
> + * While for tree blocks in commit root, no such requirement.
> + */
> +static inline int btrfs_verify_first_key(struct extent_buffer *eb,

Too big for a static inline and too much code for a header. Please add
an #ifdef that will export a static inline for { return 0; } and a
normal function that will be declared in a header and defined in .c
