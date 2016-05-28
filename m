Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46885 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336AbcE1DMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 23:12:41 -0400
Date: Fri, 27 May 2016 20:14:12 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH v3 15/22] btrfs-progs: convert: Introduce new function to
 create converted image
Message-ID: <20160528031412.GB31255@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1454043812-7893-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1454043812-7893-16-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1454043812-7893-16-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 01:03:25PM +0800, Qu Wenruo wrote:
> Use new function, create_convert_image_v2() to create snapshot of old
> filesystem.
> 
> Unlike old function which is called after copying all inodes, this
> function need to be called before copying inodes.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>  btrfs-convert.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 184 insertions(+)
> 
> diff --git a/btrfs-convert.c b/btrfs-convert.c
> index 102953a..16e2309 100644
> --- a/btrfs-convert.c
> +++ b/btrfs-convert.c
> @@ -1412,6 +1412,7 @@ static int create_image_file_range(struct btrfs_trans_handle *trans,
>  fail:
>  	return ret;
>  }
> +
>  /*
>   * Create the fs image file.
>   */
> @@ -1605,6 +1606,189 @@ fail:
>  	return ret;
>  }
>  
> +static int create_image_file_range_v2(struct btrfs_trans_handle *trans,
> +				      struct btrfs_root *root,
> +				      struct cache_tree *used,
> +				      struct btrfs_inode_item *inode,
> +				      u64 ino, u64 bytenr, u64 *ret_len,
> +				      int datacsum)
> +{
> +	struct cache_extent *cache;
> +	struct btrfs_block_group_cache *bg_cache;
> +	u64 len = *ret_len;
> +	u64 disk_bytenr;
> +	int ret;
> +
> +	BUG_ON(bytenr != round_down(bytenr, root->sectorsize));
> +	BUG_ON(len != round_down(len, root->sectorsize));
> +	len = min_t(u64, len, BTRFS_MAX_EXTENT_SIZE);
> +
> +	cache = search_cache_extent(used, bytenr);
> +	if (cache) {
> +		if (cache->start <= bytenr) {
> +			/*
> +			 * |///////Used///////|
> +			 *	|<--insert--->|
> +			 *	bytenr
> +			 */
> +			len = min_t(u64, len, cache->start + cache->size -
> +				    bytenr);
> +			disk_bytenr = bytenr;
> +		} else {
> +			/*
> +			 *		|//Used//|
> +			 *  |<-insert-->|
> +			 *  bytenr
> +			 */
> +			len = min(len, cache->start - bytenr);
> +			disk_bytenr = 0;
> +			datacsum = 0;
> +		}
> +	} else {
> +		/*
> +		 * |//Used//|		|EOF
> +		 *	    |<-insert-->|
> +		 *	    bytenr
> +		 */
> +		disk_bytenr = 0;
> +		datacsum = 0;
> +	}
> +
> +	if (disk_bytenr) {
> +		/* Check if the range is in a data block group */
> +		bg_cache = btrfs_lookup_block_group(root->fs_info, bytenr);
> +		if (!bg_cache)
> +			return -ENOENT;
> +		if (!(bg_cache->flags & BTRFS_BLOCK_GROUP_DATA))
> +			return -EINVAL;
> +
> +		/* The extent should never cross block group boundary */
> +		len = min_t(u64, len, bg_cache->key.objectid +
> +			    bg_cache->key.offset - bytenr);
> +	}
> +
> +	BUG_ON(len != round_down(len, root->sectorsize));
> +	ret = btrfs_record_file_extent(trans, root, ino, inode, bytenr,
> +				       disk_bytenr, len);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (datacsum)
> +		ret = csum_disk_extent(trans, root, bytenr, len);
> +	*ret_len = len;
> +	return ret;
> +}
> +
> +static int wipe_reserved_ranges(struct cache_tree *tree, u64 min_stripe_size,
> +				int ensure_size);
> +
> +/*
> + * Create the fs image file of old filesystem.
> + *
> + * This is completely fs independent as we have cctx->used, only
> + * need to create file extents point to all the posistions.

s/posistions/positions/g


> + * TODO: Add handler for reserved ranges in next patch
> + */
> +static int create_image_v2(struct btrfs_root *root,
> +			   struct btrfs_mkfs_config *cfg,
> +			   struct btrfs_convert_context *cctx,
> +			   u64 size, char *name, int datacsum)
> +{
> +	struct btrfs_inode_item buf;
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_path *path = NULL;
> +	struct btrfs_key key;
> +	struct cache_extent *cache;
> +	struct cache_tree used_tmp;
> +	u64 cur;
> +	u64 ino;
> +	int ret;
> +
> +	trans = btrfs_start_transaction(root, 1);
> +	if (!trans)
> +		return -ENOMEM;
> +
> +	cache_tree_init(&used_tmp);
> +
> +	ret = btrfs_find_free_objectid(trans, root, BTRFS_FIRST_FREE_OBJECTID,
> +				       &ino);
> +	if (ret < 0)
> +		goto out;
> +	ret = btrfs_new_inode(trans, root, ino, 0600 | S_IFREG);
> +	if (ret < 0)
> +		goto out;
> +	ret = btrfs_add_link(trans, root, ino, BTRFS_FIRST_FREE_OBJECTID, name,
> +			     strlen(name), BTRFS_FT_REG_FILE, NULL, 1);
> +	if (ret < 0)
> +		goto out;
> +
> +	path = btrfs_alloc_path();
> +	if (!path) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	key.objectid = ino;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;
> +
> +	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
> +	if (ret) {
> +		ret = (ret > 0 ? -ENOENT : ret);
> +		goto out;
> +	}
> +	read_extent_buffer(path->nodes[0], &buf,
> +			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
> +			sizeof(buf));
> +	btrfs_release_path(path);

It seems unnecessary to search for inode_item, inode_item is
initialized by fill_inode_item(), so fill_inode_item(...&buf...) is fine.

> +
> +	/*
> +	 * Create a new used space cache, which doesn't contain the reserved
> +	 * range
> +	 */
> +	for (cache = first_cache_extent(&cctx->used); cache;
> +	     cache = next_cache_extent(cache)) {
> +		ret = add_cache_extent(&used_tmp, cache->start, cache->size);
> +		if (ret < 0)
> +			goto out;
> +	}

It's not clear why we need used_tmp.

Thanks,

-liubo
> +	ret = wipe_reserved_ranges(&used_tmp, 0, 0);
> +	if (ret < 0)
> +		goto out;
> +
> +	/*
> +	 * Start from 1M, as 0~1M is reserved, and create_image_file_range_v2()
> +	 * can't handle bytenr 0(will consider it as a hole)
> +	 */
> +	cur = 1024 * 1024;
> +	while (cur < size) {
> +		u64 len = size - cur;
> +
> +		ret = create_image_file_range_v2(trans, root, &used_tmp,
> +						&buf, ino, cur, &len, datacsum);
> +		if (ret < 0)
> +			goto out;
> +		cur += len;
> +	}
> +
> +	key.objectid = ino;
> +	key.type = BTRFS_INODE_ITEM_KEY;
> +	key.offset = 0;
> +	ret = btrfs_search_slot(trans, root, &key, path, 0, 1);
> +	if (ret) {
> +		ret = (ret > 0 ? -ENOENT : ret);
> +		goto out;
> +	}
> +	btrfs_set_stack_inode_size(&buf, cfg->num_bytes);
> +	write_extent_buffer(path->nodes[0], &buf,
> +			btrfs_item_ptr_offset(path->nodes[0], path->slots[0]),
> +			sizeof(buf));
> +out:
> +	free_extent_cache_tree(&used_tmp);
> +	btrfs_free_path(path);
> +	btrfs_commit_transaction(trans, root);
> +	return ret;
> +}
> +
>  static struct btrfs_root * link_subvol(struct btrfs_root *root,
>  		const char *base, u64 root_objectid)
>  {
> -- 
> 2.7.0
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
