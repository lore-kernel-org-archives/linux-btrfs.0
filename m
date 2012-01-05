From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 2/3] Btrfs: make btrfs_truncate_inode_items() more
 readable
Date: Thu, 5 Jan 2012 10:11:43 -0500
Message-ID: <20120105151142.GB1843@localhost.localdomain>
References: <4F056029.2080306@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Miao Xie <miaox@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F056029.2080306@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 05, 2012 at 04:32:41PM +0800, Miao Xie wrote:
> As the title said, this patch just make the functions of the truncation
> more readable.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |  289 ++++++++++++++++++++++++++++++------------------------
>  1 files changed, 159 insertions(+), 130 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 85e2312..df6060f 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2977,10 +2977,142 @@ out:
>  	return err;
>  }
>  
> +static int btrfs_release_and_test_inline_data_extent(
> +					struct btrfs_root *root,
> +					struct inode *inode,
> +					struct extent_buffer *leaf,
> +					struct btrfs_file_extent_item *fi,
> +					u64 offset,
> +					u64 new_size)
> +{
> +	u64 item_end;
> +
> +	item_end = offset + btrfs_file_extent_inline_len(leaf, fi) - 1;
> +
> +	if (item_end < new_size)
> +		return 0;
> +
> +	/*
> +	 * Truncate inline items is special, we have done it by
> +	 *   btrfs_truncate_page();
> +	 */
> +	if (offset < new_size)
> +		return 0;
> +
> +	if (root->ref_cows)
> +		inode_sub_bytes(inode, item_end + 1 - offset);
> +
> +	return 1;
> +}
> +
>  /*
> - * this can truncate away extent items, csum items and directory items.
> - * It starts at a high offset and removes keys until it can't find
> - * any higher than new_size
> + * If this function return 1, it means this item can be dropped directly.
> + * If 0 is returned, the item can not be dropped.
> + */
> +static int btrfs_release_and_test_data_extent(struct btrfs_trans_handle *trans,
> +					      struct btrfs_root *root,
> +					      struct btrfs_path *path,
> +					      struct inode *inode,
> +					      u64 offset,
> +					      u64 new_size)
> +{
> +	struct extent_buffer *leaf;
> +	struct btrfs_file_extent_item *fi;
> +	u64 extent_start;
> +	u64 extent_offset;
> +	u64 item_end;
> +	u64 ino = btrfs_ino(inode);
> +	u64 orig_nbytes;
> +	u64 new_nbytes;
> +	int extent_type;
> +	int ret;
> +
> +	leaf = path->nodes[0];
> +	fi = btrfs_item_ptr(leaf, path->slots[0],
> +			    struct btrfs_file_extent_item);
> +
> +	extent_type = btrfs_file_extent_type(leaf, fi);
> +	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> +		return btrfs_release_and_test_inline_data_extent(root, inode,
> +								 leaf, fi,
> +								 offset,
> +								 new_size);
> +
> +	item_end = offset + btrfs_file_extent_num_bytes(leaf, fi) - 1;
> +
> +	/*
> +	 * If the new size is beyond the end of the extent:
> +	 *   +--------------------------+
> +	 *   |				|
> +	 *   +--------------------------+
> +	 *   				  ^ new size
> +	 * so the extent should not be dropped or truncated.
> +	 */
> +	if (item_end < new_size)
> +		return 0;
> +
> +	extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
> +	if (offset < new_size) {
> +		/*
> +		 * If the new size is in the extent:
> +		 *   +--------------------------+
> +		 *   |				|
> +		 *   +--------------------------+
> +		 *   			^ new size
> +		 * so this extent should be truncated, not be dropped directly.
> +		 */
> +		orig_nbytes = btrfs_file_extent_num_bytes(leaf, fi);
> +		new_nbytes = round_up(new_size - offset, root->sectorsize);
> +
> +		btrfs_set_file_extent_num_bytes(leaf, fi, new_nbytes);
> +
> +		if (extent_start != 0 && root->ref_cows)
> +			inode_sub_bytes(inode, orig_nbytes - new_nbytes);
> +
> +		btrfs_mark_buffer_dirty(leaf);
> +		return 0;

Use ret = 0 here, and then further down...

> +	} else {
> +		/*
> +		 * If the new size is in the font of the extent:
> +		 *   +--------------------------+
> +		 *   |				|
> +		 *   +--------------------------+
> +		 *  ^ new size
> +		 * so this extent should be dropped.
> +		 */
> +
> +		/*
> +		 * It is a dummy extent, or it is in log tree, we needn't do
> +		 * anything, just drop it.
> +		 */
> +		if (extent_start == 0 ||
> +		    !(root->ref_cows || root == root->fs_info->tree_root))
> +			return 1;
> +
> +		/* If this file is not a free space management file... */
> +		/* FIXME blocksize != 4096 */
> +		if (root != root->fs_info->tree_root) {
> +			orig_nbytes = btrfs_file_extent_num_bytes(leaf, fi);
> +			inode_sub_bytes(inode, orig_nbytes);
> +		}
> +
> +		orig_nbytes = btrfs_file_extent_disk_num_bytes(leaf, fi);
> +		extent_offset = offset - btrfs_file_extent_offset(leaf, fi);
> +		btrfs_set_path_blocking(path);
> +		ret = btrfs_free_extent(trans, root, extent_start,
> +					orig_nbytes, 0,
> +					btrfs_header_owner(leaf),
> +					ino, extent_offset);
> +		BUG_ON(ret);
> +		btrfs_clear_path_blocking(path, NULL, 0);
> +
> +		return 1;

ret = 1
> +	}

return ret;

> +}
> +
> +/*
> + * this can truncate away extent items, directory items. It starts at a high
> + * offset and removes keys until it can't find any higher than new_size.
>   *
>   * csum items that cross the new i_size are truncated to the new size
>   * as well.
> @@ -2989,29 +3121,21 @@ out:
>   * will kill all the items on this inode, including the INODE_ITEM_KEY.
>   */
>  int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
> -			       struct btrfs_root *root,
> -			       struct inode *inode,
> -			       u64 new_size, u32 min_type)
> +			        struct btrfs_root *root,
> +			        struct inode *inode,
> +			        u64 new_size, u32 min_type)
>  {
>  	struct btrfs_path *path;
>  	struct extent_buffer *leaf;
> -	struct btrfs_file_extent_item *fi;
>  	struct btrfs_key key;
>  	struct btrfs_key found_key;
> -	u64 extent_start = 0;
> -	u64 extent_num_bytes = 0;
> -	u64 extent_offset = 0;
> -	u64 item_end = 0;
>  	u64 mask = root->sectorsize - 1;
> -	u32 found_type = (u8)-1;
> -	int found_extent;
> -	int del_item;
> +	u64 ino = btrfs_ino(inode);
> +	u32 found_type;
>  	int pending_del_nr = 0;
>  	int pending_del_slot = 0;
> -	int extent_type = -1;
>  	int ret;
>  	int err = 0;
> -	u64 ino = btrfs_ino(inode);
>  
>  	BUG_ON(new_size > 0 && min_type != BTRFS_EXTENT_DATA_KEY);
>  
> @@ -3019,6 +3143,7 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	if (!path)
>  		return -ENOMEM;
>  	path->reada = -1;
> +	path->leave_spinning = 1;
>  
>  	if (root->ref_cows || root == root->fs_info->tree_root)
>  		btrfs_drop_extent_cache(inode, new_size & (~mask), (u64)-1, 0);
> @@ -3037,14 +3162,11 @@ int btrfs_truncate_inode_items(struct btrfs_trans_handle *trans,
>  	key.type = (u8)-1;
>  
>  search_again:
> -	path->leave_spinning = 1;
>  	ret = btrfs_search_slot(trans, root, &key, path, -1, 1);
>  	if (ret < 0) {
>  		err = ret;
>  		goto out;
> -	}
> -
> -	if (ret > 0) {
> +	} else if (ret > 0) {
>  		/* there are no items in the tree for us to truncate, we're
>  		 * done
>  		 */
> @@ -3053,9 +3175,8 @@ search_again:
>  		path->slots[0]--;
>  	}
>  
> +	leaf = path->nodes[0];
>  	while (1) {
> -		fi = NULL;
> -		leaf = path->nodes[0];
>  		btrfs_item_key_to_cpu(leaf, &found_key, path->slots[0]);
>  		found_type = btrfs_key_type(&found_key);
>  
> @@ -3065,123 +3186,31 @@ search_again:
>  		if (found_type < min_type)
>  			break;
>  
> -		item_end = found_key.offset;
>  		if (found_type == BTRFS_EXTENT_DATA_KEY) {
> -			fi = btrfs_item_ptr(leaf, path->slots[0],
> -					    struct btrfs_file_extent_item);
> -			extent_type = btrfs_file_extent_type(leaf, fi);
> -			if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
> -				item_end +=
> -				    btrfs_file_extent_num_bytes(leaf, fi);
> -			} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -				item_end += btrfs_file_extent_inline_len(leaf,
> -									 fi);
> -			}
> -			item_end--;
> -		}
> -		if (found_type > min_type) {
> -			del_item = 1;
> -		} else {
> -			if (item_end < new_size)
> +			ret = btrfs_release_and_test_data_extent(trans, root,
> +						path, inode, found_key.offset,
> +						new_size);
> +			if (!ret)
>  				break;
> -			if (found_key.offset >= new_size)
> -				del_item = 1;
> -			else
> -				del_item = 0;
>  		}
> -		found_extent = 0;
> -		/* FIXME, shrink the extent if the ref count is only 1 */
> -		if (found_type != BTRFS_EXTENT_DATA_KEY)
> -			goto delete;
> -
> -		if (extent_type != BTRFS_FILE_EXTENT_INLINE) {
> -			u64 num_dec;
> -			extent_start = btrfs_file_extent_disk_bytenr(leaf, fi);
> -			if (!del_item) {
> -				u64 orig_num_bytes =
> -					btrfs_file_extent_num_bytes(leaf, fi);
> -				extent_num_bytes = new_size -
> -					found_key.offset + root->sectorsize - 1;
> -				extent_num_bytes = extent_num_bytes &
> -					~((u64)root->sectorsize - 1);
> -				btrfs_set_file_extent_num_bytes(leaf, fi,
> -							 extent_num_bytes);
> -				num_dec = (orig_num_bytes -
> -					   extent_num_bytes);
> -				if (root->ref_cows && extent_start != 0)
> -					inode_sub_bytes(inode, num_dec);
> -				btrfs_mark_buffer_dirty(leaf);
> -			} else {
> -				extent_num_bytes =
> -					btrfs_file_extent_disk_num_bytes(leaf,
> -									 fi);
> -				extent_offset = found_key.offset -
> -					btrfs_file_extent_offset(leaf, fi);
> -
> -				/* FIXME blocksize != 4096 */
> -				num_dec = btrfs_file_extent_num_bytes(leaf, fi);
> -				if (extent_start != 0) {
> -					found_extent = 1;
> -					if (root->ref_cows)
> -						inode_sub_bytes(inode, num_dec);
> -				}
> -			}
> -		} else if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -			/*
> -			 * we can't truncate inline items that have had
> -			 * special encodings
> -			 */
> -			if (!del_item &&
> -			    btrfs_file_extent_compression(leaf, fi) == 0 &&
> -			    btrfs_file_extent_encryption(leaf, fi) == 0 &&
> -			    btrfs_file_extent_other_encoding(leaf, fi) == 0) {
> -				u32 size = new_size - found_key.offset;
> -
> -				if (root->ref_cows) {
> -					inode_sub_bytes(inode, item_end + 1 -
> -							new_size);
> -				}
> -				size =
> -				    btrfs_file_extent_calc_inline_size(size);
> -				ret = btrfs_truncate_item(trans, root, path,
> -							  size, 1);
> -			} else if (root->ref_cows) {
> -				inode_sub_bytes(inode, item_end + 1 -
> -						found_key.offset);
> -			}
> -		}
> -delete:
> -		if (del_item) {
> -			if (!pending_del_nr) {
> -				/* no pending yet, add ourselves */
> -				pending_del_slot = path->slots[0];
> -				pending_del_nr = 1;
> -			} else if (pending_del_nr &&
> -				   path->slots[0] + 1 == pending_del_slot) {
> -				/* hop on the pending chunk */
> -				pending_del_nr++;
> -				pending_del_slot = path->slots[0];
> -			} else {
> -				BUG();
> -			}
> +
> +		if (!pending_del_nr) {
> +			/* no pending yet, add ourselves */
> +			pending_del_slot = path->slots[0];
> +			pending_del_nr = 1;
> +		} else if (pending_del_nr &&
> +			   path->slots[0] + 1 == pending_del_slot) {
> +			/* hop on the pending chunk */
> +			pending_del_nr++;
> +			pending_del_slot = path->slots[0];
>  		} else {
> -			break;
> -		}
> -		if (found_extent && (root->ref_cows ||
> -				     root == root->fs_info->tree_root)) {
> -			btrfs_set_path_blocking(path);
> -			ret = btrfs_free_extent(trans, root, extent_start,
> -						extent_num_bytes, 0,
> -						btrfs_header_owner(leaf),
> -						ino, extent_offset);
> -			BUG_ON(ret);
> +			BUG();
>  		}
>  
>  		if (found_type == BTRFS_INODE_ITEM_KEY)
>  			break;
>  
> -		if (path->slots[0] == 0 ||
> -		    path->slots[0] != pending_del_slot) {
> +		if (path->slots[0] == 0) {
>  			if (root->ref_cows &&
>  			    BTRFS_I(inode)->location.objectid !=
>  						BTRFS_FREE_INO_OBJECTID) {

Looks good.  Thanks,

Josef
