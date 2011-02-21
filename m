From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: Batched discard support for btrfs
Date: Mon, 21 Feb 2011 09:33:16 -0500
Message-ID: <20110221143315.GA2979@localhost.localdomain>
References: <201102211652.28014.lidongyang@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: Li Dongyang <lidongyang@novell.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201102211652.28014.lidongyang@novell.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 21, 2011 at 04:52:27PM +0800, Li Dongyang wrote:
> Here is batched discard support for btrfs, several changes were made:
> 
> btrfs_test_opt(root, DISCARD) is moved from btrfs_discard_extent
> to callers, as we still want to trim the fs even it's not mounted
> with -o discard.
> btrfs_discard_extent now reports errors and actual bytes trimmed to
> callers, for EOPNOTSUPP, we will try other stripes as an extent
> could span SSD and other drives, and we won't return error to
> callers unless we failed with all stripes.
> 
> And btrfs_discard_extent calls btrfs_map_block with READ, this means
> we won't get all stripes mapped for RAID1/DUP/RAID10, I think this
> should be fixed, Thanks.
> 
> Signed-off-by: Li Dongyang <lidongyang@novell.com>
> ---
>  fs/btrfs/ctree.h            |    3 +-
>  fs/btrfs/disk-io.c          |    5 ++-
>  fs/btrfs/extent-tree.c      |   81 ++++++++++++++++++++++++++++++++++++-------
>  fs/btrfs/free-space-cache.c |   79 +++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/free-space-cache.h |    2 +
>  fs/btrfs/ioctl.c            |   24 +++++++++++++
>  6 files changed, 179 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 2c98b3a..4486349 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2217,7 +2217,8 @@ u64 btrfs_account_ro_block_groups_free_space(struct btrfs_space_info *sinfo);
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
> index f3c96fc..7bed32a 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -1740,22 +1740,20 @@ static int remove_extent_backref(struct btrfs_trans_handle *trans,
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
>  	ret = btrfs_map_block(&root->fs_info->mapping_tree, READ,
>  			      bytenr, &map_length, &multi, 0);
> @@ -1767,13 +1765,25 @@ static int btrfs_discard_extent(struct btrfs_root *root, u64 bytenr,
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
> +			else if (ret == -EOPNOTSUPP)
> +				continue;
> +			else
> +				break;
>  		}
>  		kfree(multi);
>  	}
>  
> +	if (discarded_bytes)
> +		ret = 0;
> +
> +	if (actual_bytes)
> +		*actual_bytes = discarded_bytes;
> +
>  	return ret;
>  }
>  
> @@ -4353,7 +4363,8 @@ int btrfs_finish_extent_commit(struct btrfs_trans_handle *trans,
>  		if (ret)
>  			break;
>  
> -		ret = btrfs_discard_extent(root, start, end + 1 - start);
> +		if (btrfs_test_opt(root, DISCARD))
> +			ret = btrfs_discard_extent(root, start, end + 1 - start, NULL);
>  
>  		clear_extent_dirty(unpin, start, end, GFP_NOFS);
>  		unpin_extent_range(root, start, end);
> @@ -5401,7 +5412,8 @@ int btrfs_free_reserved_extent(struct btrfs_root *root, u64 start, u64 len)
>  		return -ENOSPC;
>  	}
>  
> -	ret = btrfs_discard_extent(root, start, len);
> +	if (btrfs_test_opt(root, DISCARD))
> +		ret = btrfs_discard_extent(root, start, len, NULL);
>  
>  	btrfs_add_free_space(cache, start, len);
>  	update_reserved_bytes(cache, len, 0, 1);
> @@ -8712,7 +8724,50 @@ int btrfs_error_unpin_extent_range(struct btrfs_root *root, u64 start, u64 end)
>  }
>  
>  int btrfs_error_discard_extent(struct btrfs_root *root, u64 bytenr,
> -			       u64 num_bytes)
> +			       u64 num_bytes, u64 *actual_bytes)
> +{
> +	return btrfs_discard_extent(root, bytenr, num_bytes, actual_bytes);
> +}
> +
> +int btrfs_trim_fs(struct btrfs_root *root, struct fstrim_range *range)
>  {
> -	return btrfs_discard_extent(root, bytenr, num_bytes);
> +	struct btrfs_fs_info *fs_info = root->fs_info;
> +	struct btrfs_block_group_cache *cache = NULL;
> +	u64 cnt;
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
> +			ret = btrfs_trim_block_group(cache,
> +						     &cnt,
> +						     start,
> +						     end,
> +						     range->minlen);
> +
> +			trimmed += cnt;
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
> index a039065..a274df5 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2154,3 +2154,82 @@ void btrfs_init_free_cluster(struct btrfs_free_cluster *cluster)
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
> +			} else {
> +				start = entry->offset + BITS_PER_BITMAP *
> +					block_group->sectorsize;
> +				spin_unlock(&block_group->tree_lock);
> +				continue;
> +			}
> +		} else {
> +			start = entry->offset;
> +			bytes = min(entry->bytes, end - start);
> +		}
> +
> +		spin_unlock(&block_group->tree_lock);
> +
> +		if (bytes >= minlen && !btrfs_remove_free_space(block_group,
> +								start,
> +								bytes)) {

So you have just done 2 searches for the same thing.  Instead of doing
btrfs_remove_free_space here, put

bitmap_clear_bits()

after the search_bitmap, and do a

unlink_free_space()

if it's not a bitmap, that way we don't race with the allocator (even though
this isn't a problem, it just sucks) and we don't do the search twice.  Other
than that it looks great, thank you,

Josef
