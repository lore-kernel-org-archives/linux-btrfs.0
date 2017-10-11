Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754285AbdJKHix (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Oct 2017 03:38:53 -0400
Subject: Re: [PATCH v2] Btrfs: avoid losing data raid profile when deleting a
 device
To: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
References: <20171009180128.23610-1-bo.li.liu@oracle.com>
 <20171010175305.31633-1-bo.li.liu@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <59bcc1ff-6f19-dc44-1b41-4d7bd7ad9a6c@suse.com>
Date: Wed, 11 Oct 2017 10:38:50 +0300
MIME-Version: 1.0
In-Reply-To: <20171010175305.31633-1-bo.li.liu@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.10.2017 20:53, Liu Bo wrote:
> We've avoided data losing raid profile when doing balance, but it
> turns out that deleting a device could also result in the same
> problem
> 
> This fixes the problem by creating an empty data chunk before
> relocating the data chunk.

Why is this needed - copy the metadata of the to-be-relocated chunk into
the newly created empty chunk? I don't entirely understand that code but
doesn't this seem a bit like a hack in order to stash some information?
Perhaps you could elaborate the logic a bit more in the changelog?

> 
> Metadata/System chunk are supposed to have non-zero bytes all the time
> so their raid profile is persistent.

I think this changelog is a bit scarce on detail as to the culprit of
the problem. Could you perhaps put a sentence or two what the underlying
logic which deletes the raid profile if a chunk is empty ?

> 
> Reported-by: James Alandt <James.Alandt@wdc.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
> 
> v2: - return the correct error.
>     - move helper ahead of __btrfs_balance().
> 
>  fs/btrfs/volumes.c | 84 ++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 65 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 4a72c45..a74396d 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3018,6 +3018,48 @@ static int btrfs_relocate_sys_chunks(struct btrfs_fs_info *fs_info)
>  	return ret;
>  }
>  
> +/*
> + * return 1 : allocate a data chunk successfully,
> + * return <0: errors during allocating a data chunk,
> + * return 0 : no need to allocate a data chunk.
> + */
> +static int btrfs_may_alloc_data_chunk(struct btrfs_fs_info *fs_info,
> +				      u64 chunk_offset)
> +{
> +	struct btrfs_block_group_cache *cache;
> +	u64 bytes_used;
> +	u64 chunk_type;
> +
> +	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
> +	ASSERT(cache);
> +	chunk_type = cache->flags;
> +	btrfs_put_block_group(cache);
> +
> +	if (chunk_type & BTRFS_BLOCK_GROUP_DATA) {
> +		spin_lock(&fs_info->data_sinfo->lock);
> +		bytes_used = fs_info->data_sinfo->bytes_used;
> +		spin_unlock(&fs_info->data_sinfo->lock);
> +
> +		if (!bytes_used) {
> +			struct btrfs_trans_handle *trans;
> +			int ret;
> +
> +			trans =	btrfs_join_transaction(fs_info->tree_root);
> +			if (IS_ERR(trans))
> +				return PTR_ERR(trans);
> +
> +			ret = btrfs_force_chunk_alloc(trans, fs_info,
> +						      BTRFS_BLOCK_GROUP_DATA);
> +			btrfs_end_transaction(trans);
> +			if (ret < 0)
> +				return ret;
> +
> +			return 1;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static int insert_balance_item(struct btrfs_fs_info *fs_info,
>  			       struct btrfs_balance_control *bctl)
>  {
> @@ -3476,7 +3518,6 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  	u32 count_meta = 0;
>  	u32 count_sys = 0;
>  	int chunk_reserved = 0;
> -	u64 bytes_used = 0;
>  
>  	/* step one make some room on all the devices */
>  	devices = &fs_info->fs_devices->devices;
> @@ -3635,28 +3676,21 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>  			goto loop;
>  		}
>  
> -		ASSERT(fs_info->data_sinfo);
> -		spin_lock(&fs_info->data_sinfo->lock);
> -		bytes_used = fs_info->data_sinfo->bytes_used;
> -		spin_unlock(&fs_info->data_sinfo->lock);
> -
> -		if ((chunk_type & BTRFS_BLOCK_GROUP_DATA) &&
> -		    !chunk_reserved && !bytes_used) {
> -			trans = btrfs_start_transaction(chunk_root, 0);
> -			if (IS_ERR(trans)) {
> -				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> -				ret = PTR_ERR(trans);
> -				goto error;
> -			}
> -
> -			ret = btrfs_force_chunk_alloc(trans, fs_info,
> -						      BTRFS_BLOCK_GROUP_DATA);
> -			btrfs_end_transaction(trans);
> +		if (!chunk_reserved) {
> +			/*
> +			 * We may be relocating the only data chunk we have,
> +			 * which could potentially end up with losing data's
> +			 * raid profile, so lets allocate an empty one in
> +			 * advance.
> +			 */
> +			ret = btrfs_may_alloc_data_chunk(fs_info,
> +							 found_key.offset);
>  			if (ret < 0) {
>  				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
>  				goto error;
> +			} else if (ret == 1) {
> +				chunk_reserved = 1;
>  			}
> -			chunk_reserved = 1;
>  		}
>  
>  		ret = btrfs_relocate_chunk(fs_info, found_key.offset);
> @@ -4419,6 +4453,18 @@ int btrfs_shrink_device(struct btrfs_device *device, u64 new_size)
>  		chunk_offset = btrfs_dev_extent_chunk_offset(l, dev_extent);
>  		btrfs_release_path(path);
>  
> +		/*
> +		 * We may be relocating the only data chunk we have,
> +		 * which could potentially end up with losing data's
> +		 * raid profile, so lets allocate an empty one in
> +		 * advance.
> +		 */
> +		ret = btrfs_may_alloc_data_chunk(fs_info, chunk_offset);
> +		if (ret < 0) {
> +			mutex_unlock(&fs_info->delete_unused_bgs_mutex);
> +			goto done;
> +		}
> +
>  		ret = btrfs_relocate_chunk(fs_info, chunk_offset);
>  		mutex_unlock(&fs_info->delete_unused_bgs_mutex);
>  		if (ret && ret != -ENOSPC)
> 
