Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:34065 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751644Ab3FRC5z (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 22:57:55 -0400
Received: from fnstmail02.fnst.cn.fujitsu.com (tang.cn.fujitsu.com [127.0.0.1])
	by tang.cn.fujitsu.com (8.14.3/8.13.1) with ESMTP id r5I2vpmF012757
	for <linux-btrfs@vger.kernel.org>; Tue, 18 Jun 2013 10:57:51 +0800
Message-ID: <51BFCCFF.50600@cn.fujitsu.com>
Date: Tue, 18 Jun 2013 10:59:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: optimize csums insertion function
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Any comments?

Thanks
Miao

On thu, 13 Jun 2013 20:22:17 +0800, Miao Xie wrote:
> Before applying this patch, we search the csum item at first, and If the
> new csums is adjoining to the existed csum item, we call btrfs_search_slot()
> to grow this item. It is unnecessary because we can re-use the first search
> result, if so, we can reduce the time of the csum insertion.
> 
> And Without this patch, in order to avoid the overlap of the csum items,
> we had to search the tree to get the next csum item if it was in the next
> leaf. It was also inefficient, we can get the information of the next csum
> item while we look up the csum item.
> 
> This patch improved these problems.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/ctree.c     |  25 ++++++
>  fs/btrfs/ctree.h     |   2 +
>  fs/btrfs/file-item.c | 249 ++++++++++++++++++++++-----------------------------
>  3 files changed, 133 insertions(+), 143 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index 02fae7f..d2f69d8 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -144,6 +144,9 @@ noinline void btrfs_release_path(struct btrfs_path *p)
>  		free_extent_buffer(p->nodes[i]);
>  		p->nodes[i] = NULL;
>  	}
> +
> +	if (p->search_next_key)
> +		memset(&p->next_key, 0, sizeof(struct btrfs_key));
>  }
>  
>  /*
> @@ -2499,6 +2502,26 @@ done:
>  	return ret;
>  }
>  
> +static void __cache_next_key(struct btrfs_path *p, struct extent_buffer *eb,
> +			     int level, int slot, int bin_search_result)
> +{
> +	int nitems = btrfs_header_nritems(eb);
> +
> +	if (!nitems)
> +		return;
> +
> +	if (!bin_search_result)
> +		slot++;
> +
> +	if (slot >= nitems)
> +		return;
> +
> +	if (level)
> +		btrfs_node_key_to_cpu(eb, &p->next_key, slot);
> +	else
> +		btrfs_item_key_to_cpu(eb, &p->next_key, slot);
> +}
> +
>  /*
>   * look for key in the tree.  path is filled in with nodes along the way
>   * if key is found, we return zero and you can find the item in the leaf
> @@ -2658,6 +2681,8 @@ cow_done:
>  			btrfs_unlock_up_safe(p, level + 1);
>  
>  		ret = bin_search(b, key, level, &slot);
> +		if (p->search_next_key)
> +			__cache_next_key(p, b, level, slot, ret);
>  
>  		if (level != 0) {
>  			int dec = 0;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index d6dd49b..4cec301 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -573,6 +573,7 @@ struct btrfs_path {
>  	int slots[BTRFS_MAX_LEVEL];
>  	/* if there is real range locking, this locks field will change */
>  	int locks[BTRFS_MAX_LEVEL];
> +	struct btrfs_key next_key;
>  	int reada;
>  	/* keep some upper locks as we walk down */
>  	int lowest_level;
> @@ -586,6 +587,7 @@ struct btrfs_path {
>  	unsigned int skip_locking:1;
>  	unsigned int leave_spinning:1;
>  	unsigned int search_commit_root:1;
> +	unsigned int search_next_key:1;
>  };
>  
>  /*
> diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
> index a7bfc95..892f1ce 100644
> --- a/fs/btrfs/file-item.c
> +++ b/fs/btrfs/file-item.c
> @@ -25,12 +25,12 @@
>  #include "transaction.h"
>  #include "print-tree.h"
>  
> -#define __MAX_CSUM_ITEMS(r, size) ((unsigned long)(((BTRFS_LEAF_DATA_SIZE(r) - \
> -				   sizeof(struct btrfs_item) * 2) / \
> -				  size) - 1))
> -
> -#define MAX_CSUM_ITEMS(r, size) (min_t(u32, __MAX_CSUM_ITEMS(r, size), \
> -				       PAGE_CACHE_SIZE))
> +#define __BTRFS_MAX_CSUM_ITEMS(r, size) ( \
> +	(int)((BTRFS_LEAF_DATA_SIZE(r) - sizeof(struct btrfs_item) * 2) / size \
> +	      - 1) \
> +)
> +#define BTRFS_MAX_CSUM_ITEM_SIZE(r, size)		\
> +	(min_t(int, __BTRFS_MAX_CSUM_ITEMS(r, size), PAGE_CACHE_SIZE) * size)
>  
>  #define MAX_ORDERED_SUM_BYTES(r) ((PAGE_SIZE - \
>  				   sizeof(struct btrfs_ordered_sum)) / \
> @@ -661,183 +661,149 @@ out:
>  	return ret;
>  }
>  
> +static inline u64 __calc_csum_size(struct btrfs_root *root, u64 extent_size,
> +				   u16 csum_size)
> +{
> +	return (extent_size >> root->fs_info->sb->s_blocksize_bits) * csum_size;
> +}
> +
> +static u32 btrfs_calc_csum_size(struct btrfs_root *root, u64 bytenr,
> +				u64 extent_size, u16 csum_size,
> +				struct btrfs_key *next_item_key)
> +{
> +	u64 next_offset;
> +	u64 ins_size;
> +
> +	ins_size = __calc_csum_size(root, extent_size, csum_size);
> +	if (next_item_key->objectid == BTRFS_EXTENT_CSUM_OBJECTID &&
> +	    next_item_key->type == BTRFS_EXTENT_CSUM_KEY) {
> +		next_offset = next_item_key->offset - bytenr;
> +		ins_size = min(ins_size,
> +			       __calc_csum_size(root, next_offset, csum_size));
> +	}
> +
> +	return (u32)ins_size;
> +}
> +
> +static struct btrfs_csum_item *
> +btrfs_tune_csum_item(struct btrfs_root *root, struct btrfs_path *path,
> +		     struct btrfs_csum_item *item, u32 *ins_size,
> +		     u16 csum_size)
> +{
> +	struct btrfs_csum_item *orig_item;
> +	struct extent_buffer *leaf = path->nodes[0];
> +	int slot = path->slots[0];
> +	u32 extend_size;
> +	u64 csum_offset;
> +	u32 item_size;
> +
> +	orig_item = btrfs_item_ptr(leaf, slot, struct btrfs_csum_item);
> +	csum_offset = (char *)item - (char *)orig_item;
> +	item_size = (u32)(btrfs_item_size_nr(leaf, slot) - csum_offset);
> +	if (*ins_size <= item_size) {
> +		return item;
> +	} else if (btrfs_leaf_free_space(root, leaf) < csum_size) {
> +		*ins_size = item_size;
> +		return item;
> +	}
> +
> +	extend_size = btrfs_leaf_free_space(root, leaf);
> +	extend_size = extend_size / csum_size;
> +	extend_size *= csum_size;
> +
> +	*ins_size -= item_size;
> +	extend_size = min(extend_size, *ins_size);
> +
> +	btrfs_extend_item(root, path, extend_size);
> +	*ins_size = item_size + extend_size;
> +
> +	item = btrfs_item_ptr(leaf, slot, struct btrfs_csum_item);
> +	item = (struct btrfs_csum_item *)((unsigned char *)item + csum_offset);
> +	return item;
> +}
> +
>  int btrfs_csum_file_blocks(struct btrfs_trans_handle *trans,
>  			   struct btrfs_root *root,
>  			   struct btrfs_ordered_sum *sums)
>  {
>  	struct btrfs_key file_key;
> -	struct btrfs_key found_key;
>  	struct btrfs_path *path;
>  	struct btrfs_csum_item *item;
> -	struct btrfs_csum_item *item_end;
>  	struct extent_buffer *leaf = NULL;
> -	u64 next_offset;
>  	u64 total_bytes = 0;
>  	u64 csum_offset;
>  	u64 bytenr;
> -	u32 nritems;
>  	u32 ins_size;
>  	int index = 0;
> -	int found_next;
> -	int ret;
> +	int ret = 0;
>  	u16 csum_size = btrfs_super_csum_size(root->fs_info->super_copy);
> +	u32 item_size;
> +	bool might_overlap = !trans->adding_csums;
>  
>  	path = btrfs_alloc_path();
>  	if (!path)
>  		return -ENOMEM;
> +	path->search_next_key = might_overlap;
>  again:
> -	next_offset = (u64)-1;
> -	found_next = 0;
> +	csum_offset = 0;
>  	bytenr = sums->bytenr + total_bytes;
> -	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> -	file_key.offset = bytenr;
> -	btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
>  
>  	item = btrfs_lookup_csum(trans, root, path, bytenr, 1);
>  	if (!IS_ERR(item)) {
> -		ret = 0;
> +		BUG_ON(!might_overlap);
> +		ins_size = btrfs_calc_csum_size(root, bytenr,
> +						sums->len - total_bytes,
> +						csum_size, &path->next_key);
> +
>  		leaf = path->nodes[0];
> -		item_end = btrfs_item_ptr(leaf, path->slots[0],
> -					  struct btrfs_csum_item);
> -		item_end = (struct btrfs_csum_item *)((char *)item_end +
> -			   btrfs_item_size_nr(leaf, path->slots[0]));
> +		item = btrfs_tune_csum_item(root, path, item, &ins_size,
> +					    csum_size);
>  		goto found;
>  	}
> -	ret = PTR_ERR(item);
> -	if (ret != -EFBIG && ret != -ENOENT)
> -		goto fail_unlock;
>  
> -	if (ret == -EFBIG) {
> -		u32 item_size;
> +	if (PTR_ERR(item) == -EFBIG) {
>  		/* we found one, but it isn't big enough yet */
>  		leaf = path->nodes[0];
> -		item_size = btrfs_item_size_nr(leaf, path->slots[0]);
> -		if ((item_size / csum_size) >=
> -		    MAX_CSUM_ITEMS(root, csum_size)) {
> -			/* already at max size, make a new one */
> -			goto insert;
> -		}
> -	} else {
> -		int slot = path->slots[0] + 1;
> -		/* we didn't find a csum item, insert one */
> -		nritems = btrfs_header_nritems(path->nodes[0]);
> -		if (path->slots[0] >= nritems - 1) {
> -			ret = btrfs_next_leaf(root, path);
> -			if (ret == 1)
> -				found_next = 1;
> -			if (ret != 0)
> -				goto insert;
> -			slot = 0;
> -		}
> -		btrfs_item_key_to_cpu(path->nodes[0], &found_key, slot);
> -		if (found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
> -		    found_key.type != BTRFS_EXTENT_CSUM_KEY) {
> -			found_next = 1;
> -			goto insert;
> -		}
> -		next_offset = found_key.offset;
> -		found_next = 1;
> -		goto insert;
> -	}
> -
> -	/*
> -	 * at this point, we know the tree has an item, but it isn't big
> -	 * enough yet to put our csum in.  Grow it
> -	 */
> -	btrfs_release_path(path);
> -	ret = btrfs_search_slot(trans, root, &file_key, path,
> -				csum_size, 1);
> -	if (ret < 0)
> -		goto fail_unlock;
> -
> -	if (ret > 0) {
> -		if (path->slots[0] == 0)
> -			goto insert;
> -		path->slots[0]--;
> -	}
> -
> -	leaf = path->nodes[0];
> -	btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
> -	csum_offset = (bytenr - found_key.offset) >>
> -			root->fs_info->sb->s_blocksize_bits;
> -
> -	if (btrfs_key_type(&found_key) != BTRFS_EXTENT_CSUM_KEY ||
> -	    found_key.objectid != BTRFS_EXTENT_CSUM_OBJECTID ||
> -	    csum_offset >= MAX_CSUM_ITEMS(root, csum_size)) {
> -		goto insert;
> -	}
> -
> -	if (csum_offset == btrfs_item_size_nr(leaf, path->slots[0]) /
> -	    csum_size) {
> -		int extend_nr;
> -		u64 tmp;
> -		u32 diff;
> -		u32 free_space;
> -
>  		if (btrfs_leaf_free_space(root, leaf) <
> -				 sizeof(struct btrfs_item) + csum_size * 2)
> +		    sizeof(struct btrfs_item) + csum_size)
>  			goto insert;
>  
> -		free_space = btrfs_leaf_free_space(root, leaf) -
> -					 sizeof(struct btrfs_item) - csum_size;
> -		tmp = sums->len - total_bytes;
> -		tmp >>= root->fs_info->sb->s_blocksize_bits;
> -		WARN_ON(tmp < 1);
> -
> -		extend_nr = max_t(int, 1, (int)tmp);
> -		diff = (csum_offset + extend_nr) * csum_size;
> -		diff = min(diff, MAX_CSUM_ITEMS(root, csum_size) * csum_size);
> -
> -		diff = diff - btrfs_item_size_nr(leaf, path->slots[0]);
> -		diff = min(free_space, diff);
> -		diff /= csum_size;
> -		diff *= csum_size;
> -
> -		btrfs_extend_item(root, path, diff);
> -		ret = 0;
> +		ins_size = btrfs_calc_csum_size(root, bytenr,
> +						sums->len - total_bytes,
> +						csum_size, &path->next_key);
> +		csum_offset = btrfs_item_size_nr(leaf, path->slots[0]);
> +		item_size = btrfs_leaf_free_space(root, leaf);
> +		if (ins_size > item_size) {
> +			ins_size = item_size / csum_size;
> +			ins_size *= csum_size;
> +		}
> +		btrfs_extend_item(root, path, ins_size);
>  		goto csum;
> +	} else if (PTR_ERR(item) != -ENOENT) {
> +		goto out;
>  	}
> -
>  insert:
>  	btrfs_release_path(path);
> -	csum_offset = 0;
> -	if (found_next) {
> -		u64 tmp;
>  
> -		tmp = sums->len - total_bytes;
> -		tmp >>= root->fs_info->sb->s_blocksize_bits;
> -		tmp = min(tmp, (next_offset - file_key.offset) >>
> -					 root->fs_info->sb->s_blocksize_bits);
> +	ins_size = btrfs_calc_csum_size(root, bytenr,
> +					sums->len - total_bytes,
> +					csum_size, &path->next_key);
> +	ins_size = min_t(u32, ins_size,
> +			 BTRFS_MAX_CSUM_ITEM_SIZE(root, csum_size));
> +	file_key.objectid = BTRFS_EXTENT_CSUM_OBJECTID;
> +	file_key.offset = bytenr;
> +	btrfs_set_key_type(&file_key, BTRFS_EXTENT_CSUM_KEY);
>  
> -		tmp = max((u64)1, tmp);
> -		tmp = min(tmp, (u64)MAX_CSUM_ITEMS(root, csum_size));
> -		ins_size = csum_size * tmp;
> -	} else {
> -		ins_size = csum_size;
> -	}
>  	path->leave_spinning = 1;
> -	ret = btrfs_insert_empty_item(trans, root, path, &file_key,
> -				      ins_size);
> +	ret = btrfs_insert_empty_item(trans, root, path, &file_key, ins_size);
>  	path->leave_spinning = 0;
> -	if (ret < 0)
> -		goto fail_unlock;
> -	if (ret != 0) {
> -		WARN_ON(1);
> -		goto fail_unlock;
> -	}
> -	leaf = path->nodes[0];
> +	if (ret)
> +		goto out;
>  csum:
> +	leaf = path->nodes[0];
>  	item = btrfs_item_ptr(leaf, path->slots[0], struct btrfs_csum_item);
> -	item_end = (struct btrfs_csum_item *)((unsigned char *)item +
> -				      btrfs_item_size_nr(leaf, path->slots[0]));
> -	item = (struct btrfs_csum_item *)((unsigned char *)item +
> -					  csum_offset * csum_size);
> +	item = (struct btrfs_csum_item *)((unsigned char *)item + csum_offset);
>  found:
> -	ins_size = (u32)(sums->len - total_bytes) >>
> -		   root->fs_info->sb->s_blocksize_bits;
> -	ins_size *= csum_size;
> -	ins_size = min_t(u32, (unsigned long)item_end - (unsigned long)item,
> -			      ins_size);
>  	write_extent_buffer(leaf, sums->sums + index, (unsigned long)item,
>  			    ins_size);
>  
> @@ -854,7 +820,4 @@ found:
>  out:
>  	btrfs_free_path(path);
>  	return ret;
> -
> -fail_unlock:
> -	goto out;
>  }
> 

