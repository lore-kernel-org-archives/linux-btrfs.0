From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH V2] Btrfs: Batched discard support for btrfs
Date: Tue, 1 Mar 2011 18:17:47 +0800
Message-ID: <201103011817.48010.lidongyang@novell.com>
References: <201102251616.27741.lidongyang@novell.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: Lukas Czerner <lczerner@redhat.com>,
	David Sterba <dsterba@suse.cz>, Kurt Garloff <garloff@suse.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102251616.27741.lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday, February 25, 2011 04:16:27 PM Li Dongyang wrote:
> Thanks for your comments, here is the updated patch.
> I've tested it with xfstests 251(thanks to Lukas), and it looks fine to me.
> 
when we call btrfs_map_block() for RAID0/1/10/ or DUP, it only returns a single stripe
length at most, I'm a bit confused why we are doing this and it makes a little trouble to
this patch: we just trim the first stripe on each device right now.
We can loop in btrfs_discard_extent(), mapping each stripe and trim them, but I think the
ideal way is mapping the full length of the free extent and trim that all at once, ideas?

Thanks a lot,
Li Dongyang
> Signed-off-by: Li Dongyang <lidongyang@novell.com>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> Reviewed-by: Kurt Garloff <garloff@suse.de>
> ---
> Changelog V2:
>     *Check if we have devices support trim before trying to trim the fs, also adjust
>       minlen according to the discard_granularity.
>     *Update reserved extent calculations in btrfs_trim_block_group().
>     *Call cond_resched() without checking need_resched()
>     *Use bitmap_clear_bits() and unlink_free_space() instead of btrfs_remove_free_space(),
>       so we won't search the same extent for twice.
>     *Try harder in btrfs_discard_extent(), now we won't report errors
>      if it's not a EOPNOTSUPP.
>     *make sure the block group is cached before trimming it,or we'll see an empty caching
>      tree if the block group is not cached.
>     *Minor return value fix in btrfs_discard_block_group(). 
> ---
>  fs/btrfs/ctree.h            |    5 ++-
>  fs/btrfs/disk-io.c          |    5 ++-
>  fs/btrfs/extent-tree.c      |  102 +++++++++++++++++++++++++++++++++----------
>  fs/btrfs/free-space-cache.c |   92 ++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/free-space-cache.h |    2 +
>  fs/btrfs/ioctl.c            |   47 ++++++++++++++++++++
>  6 files changed, 227 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2c98b3a..5cbc05c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2147,6 +2147,8 @@ int btrfs_free_extent(struct btrfs_trans_handle *trans,
>  		      u64 root_objectid, u64 owner, u64 offset);
>  
>  int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len);
> +int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
> +				u64 num_bytes, int reserve, int sinfo);
>  int btrfs_prepare_extent_commit(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root);
>  int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
> @@ -2217,7 +2219,8 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
>  int btrfs_error_unpin_extent_range(struct btrfs_root *root,
>  				   u64 start, u64 end);
>  int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
> -			       u64 num_bytes);
> +			       u64 num_bytes, u64 *actual_bytes);
> +int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range);
>  
>  /* ctree.c */
>  int btrfs_bin_search(struct extent_buffer *eb, struct btrfs_key *key,
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index e1aa8d6..bcb9451 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2947,7 +2947,10 @@ static int btrfs_destroy_pinned_extent(struct btrfs_root *root,
>  			break;
>  
>  		/* opt_discard */
> -		ret = btrfs_error_discard_extent(root, start, end + 1 - start);
> +		if (btrfs_test_opt(root, DISCARD))
> +			ret = btrfs_error_discard_extent(root, start,
> +							 end + 1 - start,
> +							 NULL);
>  
>  		clear_extent_dirty(unpin, start, end, GFP_NOFS);
>  		btrfs_error_unpin_extent_range(root, start, end);
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index f3c96fc..38100c8 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -36,8 +36,6 @@
>  static int update_block_group(struct btrfs_trans_handle *trans,
>  			      struct btrfs_root *root,
>  			      u64 bytenr, u64 num_bytes, int alloc);
> -static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
> -				 u64 num_bytes, int reserve, int sinfo);
>  static int __btrfs_free_extent(struct btrfs_trans_handle *trans,
>  				struct btrfs_root *root,
>  				u64 bytenr, u64 num_bytes, u64 parent,
> @@ -442,7 +440,7 @@ static int cache_block_group(struct btrfs_block_group_cache *cache,
>  	 * allocate blocks for the tree root we can't do the fast caching since
>  	 * we likely hold important locks.
>  	 */
> -	if (!trans->transaction->in_commit &&
> +	if (trans && (!trans->transaction->in_commit) &&
>  	    (root && root != root->fs_info->tree_root)) {
>  		spin_lock(&cache->lock);
>  		if (cache->cached != BTRFS_CACHE_NO) {
> @@ -1740,24 +1738,22 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
>  	return ret;
>  }
>  
> -static void btrfs_issue_discard(struct block_device *bdev,
> +static int btrfs_issue_discard(struct block_device *bdev,
>  				u64 start, u64 len)
>  {
> -	blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
> +	return blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL, 0);
>  }
>  
>  static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
> -				u64 num_bytes)
> +				u64 num_bytes, u64 *actual_bytes)
>  {
>  	int ret;
>  	u64 map_length = num_bytes;
> +	u64 discarded_bytes = 0;
>  	struct btrfs_multi_bio *multi = NULL;
>  
> -	if (!btrfs_test_opt(root, DISCARD))
> -		return 0;
> -
>  	/* Tell the block device(s) that the sectors can be discarded */
> -	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
> +	ret = btrfs_map_block(&root->fs_info->mapping_tree, WRITE,
>  			      bytenr, &map_length, &multi, 0);
>  	if (!ret) {
>  		struct btrfs_bio_stripe *stripe = multi->stripes;
> @@ -1767,13 +1763,21 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
>  			map_length = num_bytes;
>  
>  		for (i = 0; i < multi->num_stripes; i++, stripe++) {
> -			btrfs_issue_discard(stripe->dev->bdev,
> -					    stripe->physical,
> -					    map_length);
> +			ret = btrfs_issue_discard(stripe->dev->bdev,
> +						  stripe->physical,
> +						  map_length);
> +			if (!ret)
> +				discarded_bytes += map_length;
>  		}
>  		kfree(multi);
>  	}
>  
> +	if (discarded_bytes || ret == -EOPNOTSUPP)
> +		ret = 0;
> +
> +	if (actual_bytes)
> +		*actual_bytes = discarded_bytes;
> +
>  	return ret;
>  }
>  
> @@ -4214,8 +4218,8 @@ int btrfs_pin_extent(struct btrfs_root *root,
>   * update size of reserved extents. this function may return -EAGAIN
>   * if 'reserve' is true or 'sinfo' is false.
>   */
> -static int update_reserved_bytes(struct btrfs_block_group_cache *cache,
> -				 u64 num_bytes, int reserve, int sinfo)
> +int btrfs_update_reserved_bytes(struct btrfs_block_group_cache *cache,
> +				u64 num_bytes, int reserve, int sinfo)
>  {
>  	int ret = 0;
>  	if (sinfo) {
> @@ -4353,7 +4357,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
>  		if (ret)
>  			break;
>  
> -		ret = btrfs_discard_extent(root, start, end + 1 - start);
> +		if (btrfs_test_opt(root, DISCARD))
> +			ret = btrfs_discard_extent(root, start, end + 1 - start, NULL);
>  
>  		clear_extent_dirty(unpin, start, end, GFP_NOFS);
>  		unpin_extent_range(root, start, end);
> @@ -4694,10 +4699,10 @@ void btrfs_free_tree_block(struct btrfs_trans_handle *trans,
>  		WARN_ON(test_bit(EXTENT_BUFFER_DIRTY, &buf->bflags));
>  
>  		btrfs_add_free_space(cache, buf->start, buf->len);
> -		ret = update_reserved_bytes(cache, buf->len, 0, 0);
> +		ret = btrfs_update_reserved_bytes(cache, buf->len, 0, 0);
>  		if (ret == -EAGAIN) {
>  			/* block group became read-only */
> -			update_reserved_bytes(cache, buf->len, 0, 1);
> +			btrfs_update_reserved_bytes(cache, buf->len, 0, 1);
>  			goto out;
>  		}
>  
> @@ -5180,7 +5185,7 @@ checks:
>  					     search_start - offset);
>  		BUG_ON(offset > search_start);
>  
> -		ret = update_reserved_bytes(block_group, num_bytes, 1,
> +		ret = btrfs_update_reserved_bytes(block_group, num_bytes, 1,
>  					    (data & BTRFS_BLOCK_GROUP_DATA));
>  		if (ret == -EAGAIN) {
>  			btrfs_add_free_space(block_group, offset, num_bytes);
> @@ -5401,10 +5406,11 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
>  		return -ENOSPC;
>  	}
>  
> -	ret = btrfs_discard_extent(root, start, len);
> +	if (btrfs_test_opt(root, DISCARD))
> +		ret = btrfs_discard_extent(root, start, len, NULL);
>  
>  	btrfs_add_free_space(cache, start, len);
> -	update_reserved_bytes(cache, len, 0, 1);
> +	btrfs_update_reserved_bytes(cache, len, 0, 1);
>  	btrfs_put_block_group(cache);
>  
>  	return ret;
> @@ -5603,7 +5609,7 @@ int btrfs_alloc_logged_file_extent(struct btrfs_trans_handle *trans,
>  		put_caching_control(caching_ctl);
>  	}
>  
> -	ret = update_reserved_bytes(block_group, ins->offset, 1, 1);
> +	ret = btrfs_update_reserved_bytes(block_group, ins->offset, 1, 1);
>  	BUG_ON(ret);
>  	btrfs_put_block_group(block_group);
>  	ret = alloc_reserved_file_extent(trans, root, 0, root_objectid,
> @@ -8712,7 +8718,55 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
>  }
>  
>  int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
> -			       u64 num_bytes)
> +			       u64 num_bytes, u64 *actual_bytes)
>  {
> -	return btrfs_discard_extent(root, bytenr, num_bytes);
> +	return btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
> +}
> +
> +int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
> +{
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_block_group_cache *cache = NULL;
> +	u64 group_trimmed;
> +	u64 start;
> +	u64 end;
> +	u64 trimmed = 0;
> +	int ret = 0;
> +
> +	cache = btrfs_lookup_block_group(fs_info, range->start);
> +
> +	while (cache) {
> +		if (cache->key.objectid >= (range->start + range->len)) {
> +			btrfs_put_block_group(cache);
> +			break;
> +		}
> +
> +		start = max(range->start, cache->key.objectid);
> +		end = min(range->start + range->len,
> +				cache->key.objectid + cache->key.offset);
> +
> +		if (end - start >= range->minlen) {
> +			if (!block_group_cache_done(cache)) {
> +				ret = cache_block_group(cache, NULL, root, 0);
> +				if (!ret)
> +					wait_block_group_cache_done(cache);
> +			}
> +			ret = btrfs_trim_block_group(cache,
> +						     &group_trimmed,
> +						     start,
> +						     end,
> +						     range->minlen);
> +
> +			trimmed += group_trimmed;
> +			if (ret < 0) {
> +				btrfs_put_block_group(cache);
> +				break;
> +			}
> +		}
> +
> +		cache = next_block_group(fs_info->tree_root, cache);
> +	}
> +
> +	range->len = trimmed;
> +	return ret;
>  }
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index a039065..84801ee 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2154,3 +2154,95 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
>  	cluster->block_group = NULL;
>  }
>  
> +int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
> +			   u64 *trimmed, u64 start, u64 end, u64 minlen)
> +{
> +	struct btrfs_free_space *entry = NULL;
> +	struct btrfs_fs_info *fs_info = block_group->fs_info;
> +	u64 bytes = 0;
> +	u64 actually_trimmed;
> +	int ret = 0;
> +
> +	*trimmed = 0;
> +
> +	while (start < end) {
> +		spin_lock(&block_group->tree_lock);
> +
> +		if (block_group->free_space < minlen) {
> +			spin_unlock(&block_group->tree_lock);
> +			break;
> +		}
> +
> +		entry = tree_search_offset(block_group, start, 0, 1);
> +		if (!entry)
> +			entry = tree_search_offset(block_group,
> +						   offset_to_bitmap(block_group,
> +								    start),
> +						   1, 1);
> +
> +		if (!entry || entry->offset >= end) {
> +			spin_unlock(&block_group->tree_lock);
> +			break;
> +		}
> +
> +		if (entry->bitmap) {
> +			ret = search_bitmap(block_group, entry, &start, &bytes);
> +			if (!ret) {
> +				if (start >= end ) {
> +					spin_unlock(&block_group->tree_lock);
> +					break;
> +				}
> +				bytes = min(bytes, end - start);
> +				bitmap_clear_bits(block_group, entry,
> +						  start, bytes);
> +				if (entry->bytes == 0)
> +					free_bitmap(block_group, entry);
> +			} else {
> +				start = entry->offset + BITS_PER_BITMAP *
> +					block_group->sectorsize;
> +				spin_unlock(&block_group->tree_lock);
> +				ret = 0;
> +				continue;
> +			}
> +		} else {
> +			start = entry->offset;
> +			bytes = min(entry->bytes, end - start);
> +			unlink_free_space(block_group, entry);
> +			kfree(entry);
> +		}
> +
> +		spin_unlock(&block_group->tree_lock);
> +
> +		if (bytes >= minlen) {
> +			int update_ret;
> +			update_ret = btrfs_update_reserved_bytes(block_group,
> +								 bytes, 1, 1);
> +
> +			ret = btrfs_error_discard_extent(fs_info->extent_root,
> +							 start,
> +							 bytes,
> +							 &actually_trimmed);
> +
> +			btrfs_add_free_space(block_group,
> +					     start, bytes);
> +			if (!update_ret)
> +				btrfs_update_reserved_bytes(block_group,
> +							    bytes, 0, 1);
> +
> +			if (ret)
> +				break;
> +			*trimmed += actually_trimmed;
> +		}
> +		start += bytes;
> +		bytes = 0;
> +
> +		if (fatal_signal_pending(current)) {
> +			ret = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		cond_resched();
> +	}
> +
> +	return ret;
> +}
> diff --git a/fs/btrfs/free-space-cache.h b/fs/btrfs/free-space-cache.h
> index e49ca5c..65c3b93 100644
> --- a/fs/btrfs/free-space-cache.h
> +++ b/fs/btrfs/free-space-cache.h
> @@ -68,4 +68,6 @@ u64 btrfs_alloc_from_cluster(struct btrfs_block_group_cache *block_group,
>  int btrfs_return_cluster_to_free_space(
>  			       struct btrfs_block_group_cache *block_group,
>  			       struct btrfs_free_cluster *cluster);
> +int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
> +			   u64 *trimmed, u64 start, u64 end, u64 minlen);
>  #endif
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index be2d4f6..f0220c5 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -40,6 +40,7 @@
>  #include <linux/xattr.h>
>  #include <linux/vmalloc.h>
>  #include <linux/slab.h>
> +#include <linux/blkdev.h>
>  #include "compat.h"
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -225,6 +226,50 @@ static int btrfs_ioctl_getversion(struct file *file, int __user *arg)
>  	return put_user(inode->i_generation, arg);
>  }
>  
> +static noinline int btrfs_ioctl_fitrim(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = fdentry(file)->d_sb->s_fs_info;
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_device *device;
> +	struct request_queue *q;
> +	struct fstrim_range range;
> +	u64 minlen = ULLONG_MAX;
> +	u64 num_devices = 0;
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	mutex_lock(&fs_info->fs_devices->device_list_mutex);
> +	list_for_each_entry(device, &fs_info->fs_devices->devices, dev_list) {
> +		if (!device->bdev)
> +			continue;
> +		q = bdev_get_queue(device->bdev);
> +		if (blk_queue_discard(q)) {
> +			num_devices++;
> +			minlen = min((u64)q->limits.discard_granularity,
> +				     minlen);
> +		}
> +	}
> +	mutex_unlock(&fs_info->fs_devices->device_list_mutex);
> +	if (!num_devices) {
> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (copy_from_user(&range, arg, sizeof(range)))
> +		return -EFAULT;
> +
> +	range.minlen = max(range.minlen, minlen);
> +	ret = btrfs_trim_fs(root, &range);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (copy_to_user(arg, &range, sizeof(range)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  static noinline int create_subvol(struct btrfs_root *root,
>  				  struct dentry *dentry,
>  				  char *name, int namelen,
> @@ -2385,6 +2430,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_setflags(file, argp);
>  	case FS_IOC_GETVERSION:
>  		return btrfs_ioctl_getversion(file, argp);
> +	case FITRIM:
> +		return btrfs_ioctl_fitrim(file, argp);
>  	case BTRFS_IOC_SNAP_CREATE:
>  		return btrfs_ioctl_snap_create(file, argp, 0);
>  	case BTRFS_IOC_SNAP_CREATE_V2:
> 
