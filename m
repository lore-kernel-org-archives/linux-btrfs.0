From: Li Dongyang <lidongyang@novell.com>
Subject: Re: [PATCH 1/2] Btrfs: fix space leak when skipping small extents during trimming
Date: Tue, 5 Jul 2011 12:07:12 +0800
Message-ID: <201107051207.12368.lidongyang@novell.com>
References: <4E0030DF.4080704@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E0030DF.4080704@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tuesday, June 21, 2011 01:49:19 PM Li Zefan wrote:
> We're taking a free space extent out of the free space cache, trimming
> it and then putting it back into the cache.
> 
sorry for the late reply, I can hardly to find time look at this.
> However for an extent that is smaller than the specified minimum length,
> it's taken out but won't be put back, which causes space leak.
yes, you are correct, and the fix looks good to me, Thanks
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
> 
> Unfortunately I have no trim-able device to test the patch.
> 
> ---
>  fs/btrfs/free-space-cache.c |   34 +++++++++++++++++-----------------
>  1 files changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 9f985a4..292c0d9 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2460,6 +2460,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  	u64 bytes = 0;
>  	u64 actually_trimmed;
>  	int ret = 0;
> +	int update_ret;
>  
>  	*trimmed = 0;
>  
> @@ -2483,6 +2484,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  		}
>  
>  		if (entry->bitmap) {
> +			bytes = 0;
>  			ret = search_bitmap(ctl, entry, &start, &bytes);
>  			if (!ret) {
>  				if (start >= end) {
> @@ -2490,6 +2492,8 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  					break;
>  				}
>  				bytes = min(bytes, end - start);
> +				if (bytes < minlen)
> +					goto next;
>  				bitmap_clear_bits(ctl, entry, start, bytes);
>  				if (entry->bytes == 0)
>  					free_bitmap(ctl, entry);
> @@ -2503,33 +2507,29 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  		} else {
>  			start = entry->offset;
>  			bytes = min(entry->bytes, end - start);
> +			if (bytes < minlen)
> +				goto next;
>  			unlink_free_space(ctl, entry);
>  			kmem_cache_free(btrfs_free_space_cachep, entry);
>  		}
>  
>  		spin_unlock(&ctl->tree_lock);
>  
> -		if (bytes >= minlen) {
> -			int update_ret;
> -			update_ret = btrfs_update_reserved_bytes(block_group,
> -								 bytes, 1, 1);
> +		update_ret = btrfs_update_reserved_bytes(block_group,
> +							 bytes, 1, 1);
>  
> -			ret = btrfs_error_discard_extent(fs_info->extent_root,
> -							 start,
> -							 bytes,
> -							 &actually_trimmed);
> +		ret = btrfs_error_discard_extent(fs_info->extent_root, start,
> +						 bytes, &actually_trimmed);
>  
> -			btrfs_add_free_space(block_group, start, bytes);
> -			if (!update_ret)
> -				btrfs_update_reserved_bytes(block_group,
> -							    bytes, 0, 1);
> +		btrfs_add_free_space(block_group, start, bytes);
> +		if (!update_ret)
> +			btrfs_update_reserved_bytes(block_group, bytes, 0, 1);
>  
> -			if (ret)
> -				break;
> -			*trimmed += actually_trimmed;
> -		}
> +		if (ret)
> +			break;
> +		*trimmed += actually_trimmed;
> +next:
>  		start += bytes;
> -		bytes = 0;
>  
>  		if (fatal_signal_pending(current)) {
>  			ret = -ERESTARTSYS;
> 
