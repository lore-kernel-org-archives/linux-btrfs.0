Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:20129 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750799AbeBBJPR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Feb 2018 04:15:17 -0500
Subject: Re: [PATCH 2/7] btrfs-progs: Merge btrfs_alloc_data_chunk into
 btrfs_alloc_chunk
To: Qu Wenruo <wqu@suse.com>, <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <20180202081929.15162-1-wqu@suse.com>
 <20180202081929.15162-3-wqu@suse.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <12a99e67-52bf-9b4b-86b7-eee1ee26af16@cn.fujitsu.com>
Date: Fri, 2 Feb 2018 17:20:01 +0800
MIME-Version: 1.0
In-Reply-To: <20180202081929.15162-3-wqu@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/02/2018 04:19 PM, Qu Wenruo wrote:
> We used to have two chunk allocators, btrfs_alloc_chunk() and
> btrfs_alloc_data_chunk(), the former is the more generic one, while the
> later is only used in mkfs and convert, to allocate SINGLE data chunk.
> 
> Although btrfs_alloc_data_chunk() has some special hacks to cooperate
> with convert, it's quite simple to integrity it into the generic chunk
> allocator.
> 
> So merge them into one btrfs_alloc_chunk(), with extra @convert
> parameter and necessary comment, to make code less duplicated and less
> thing to maintain.
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>   convert/main.c |   6 +-
>   extent-tree.c  |   2 +-
>   mkfs/main.c    |   8 +--
>   volumes.c      | 219 ++++++++++++++++++++++-----------------------------------
>   volumes.h      |   5 +-
>   5 files changed, 94 insertions(+), 146 deletions(-)
> 
> diff --git a/convert/main.c b/convert/main.c
> index b3ea31d7af43..b2444bb2ff21 100644
> --- a/convert/main.c
> +++ b/convert/main.c
> @@ -910,9 +910,9 @@ static int make_convert_data_block_groups(struct btrfs_trans_handle *trans,
>   
>   			len = min(max_chunk_size,
>   				  cache->start + cache->size - cur);
> -			ret = btrfs_alloc_data_chunk(trans, fs_info,
> -					&cur_backup, len,
> -					BTRFS_BLOCK_GROUP_DATA, 1);
> +			ret = btrfs_alloc_chunk(trans, fs_info,
> +					&cur_backup, &len,
> +					BTRFS_BLOCK_GROUP_DATA, true);
>   			if (ret < 0)
>   				break;
>   			ret = btrfs_make_block_group(trans, fs_info, 0,
> diff --git a/extent-tree.c b/extent-tree.c
> index e2ae74a7fe66..b085ab0352b3 100644
> --- a/extent-tree.c
> +++ b/extent-tree.c
> @@ -1906,7 +1906,7 @@ static int do_chunk_alloc(struct btrfs_trans_handle *trans,
>   		return 0;
>   
>   	ret = btrfs_alloc_chunk(trans, fs_info, &start, &num_bytes,
> -	                        space_info->flags);
> +	                        space_info->flags, false);
>   	if (ret == -ENOSPC) {
>   		space_info->full = 1;
>   		return 0;
> diff --git a/mkfs/main.c b/mkfs/main.c
> index ea65c6d897b2..358395ca0250 100644
> --- a/mkfs/main.c
> +++ b/mkfs/main.c
> @@ -82,7 +82,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
>   		ret = btrfs_alloc_chunk(trans, fs_info,
>   					&chunk_start, &chunk_size,
>   					BTRFS_BLOCK_GROUP_METADATA |
> -					BTRFS_BLOCK_GROUP_DATA);
> +					BTRFS_BLOCK_GROUP_DATA, false);
>   		if (ret == -ENOSPC) {
>   			error("no space to allocate data/metadata chunk");
>   			goto err;
> @@ -99,7 +99,7 @@ static int create_metadata_block_groups(struct btrfs_root *root, int mixed,
>   	} else {
>   		ret = btrfs_alloc_chunk(trans, fs_info,
>   					&chunk_start, &chunk_size,
> -					BTRFS_BLOCK_GROUP_METADATA);
> +					BTRFS_BLOCK_GROUP_METADATA, false);
>   		if (ret == -ENOSPC) {
>   			error("no space to allocate metadata chunk");
>   			goto err;
> @@ -133,7 +133,7 @@ static int create_data_block_groups(struct btrfs_trans_handle *trans,
>   	if (!mixed) {
>   		ret = btrfs_alloc_chunk(trans, fs_info,
>   					&chunk_start, &chunk_size,
> -					BTRFS_BLOCK_GROUP_DATA);
> +					BTRFS_BLOCK_GROUP_DATA, false);
>   		if (ret == -ENOSPC) {
>   			error("no space to allocate data chunk");
>   			goto err;
> @@ -241,7 +241,7 @@ static int create_one_raid_group(struct btrfs_trans_handle *trans,
>   	int ret;
>   
>   	ret = btrfs_alloc_chunk(trans, fs_info,
> -				&chunk_start, &chunk_size, type);
> +				&chunk_start, &chunk_size, type, false);
>   	if (ret == -ENOSPC) {
>   		error("not enough free space to allocate chunk");
>   		exit(1);
> diff --git a/volumes.c b/volumes.c
> index 677d085de96c..9ee4650351c3 100644
> --- a/volumes.c
> +++ b/volumes.c
> @@ -836,9 +836,23 @@ error:
>   				- 2 * sizeof(struct btrfs_chunk))	\
>   				/ sizeof(struct btrfs_stripe) + 1)
>   
> +/*
> + * Alloc a chunk, will insert dev extents, chunk item.
> + * NOTE: This function will not insert block group item nor mark newly
> + * allocated chunk available for later allocation.
> + * Block group item and free space update is handled by btrfs_make_block_group()
> + *
> + * @start:	return value of allocated chunk start bytenr.
> + * @num_bytes:	return value of allocated chunk size
> + * @type:	chunk type (including both profile and type)
> + * @convert:	if the chunk is allocated for convert case.
> + * 		If @convert is true, chunk allocator will skip device extent
> + * 		search, but use *start and *num_bytes as chunk start/num_bytes
> + * 		and devive offset, to build a 1:1 chunk mapping for convert.
> + */
>   int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   		      struct btrfs_fs_info *info, u64 *start,
> -		      u64 *num_bytes, u64 type)
> +		      u64 *num_bytes, u64 type, bool convert)
>   {
>   	u64 dev_offset;
>   	struct btrfs_root *extent_root = info->extent_root;
> @@ -868,10 +882,38 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   	struct btrfs_key key;
>   	u64 offset;
>   
> -	if (list_empty(dev_list)) {
> +	if (list_empty(dev_list))
>   		return -ENOSPC;
> +
> +	if (convert) {
> +		/* For convert, profile must be SINGLE */
> +		if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
Maybe BTRFS_RAID_SINGLE?

Thanks,
Su

> +			error("convert only suports SINGLE profile");
> +			return -EINVAL;
> +		}
> +		if (!IS_ALIGNED(*start, info->sectorsize)) {
> +			error("chunk start not aligned, start=%llu sectorsize=%u",
> +				*start, info->sectorsize);
> +			return -EINVAL;
> +		}
> +		if (!IS_ALIGNED(*num_bytes, info->sectorsize)) {
> +			error("chunk size not aligned, size=%llu sectorsize=%u",
> +				*num_bytes, info->sectorsize);
> +			return -EINVAL;
> +		}
> +		calc_size = *num_bytes;
> +		offset = *start;
> +		/*
> +		 * For convert, we use 1:1 chunk mapping specified by @start and
> +		 * @num_bytes, so there is no need to go through dev_extent
> +		 * searching.
> +		 */
> +		goto alloc_chunk;
>   	}
>   
> +	/*
> +	 * Chunk size calculation part.
> +	 */
>   	if (type & BTRFS_BLOCK_GROUP_PROFILE_MASK) {
>   		if (type & BTRFS_BLOCK_GROUP_SYSTEM) {
>   			calc_size = SZ_8M;
> @@ -942,6 +984,9 @@ int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   	percent_max = div_factor(btrfs_super_total_bytes(info->super_copy), 1);
>   	max_chunk_size = min(percent_max, max_chunk_size);
>   
> +	/*
> +	 * Reserve space from each device.
> +	 */
>   again:
>   	if (chunk_bytes_by_type(type, calc_size, num_stripes, sub_stripes) >
>   	    max_chunk_size) {
> @@ -972,7 +1017,8 @@ again:
>   			return ret;
>   		cur = cur->next;
>   		if (avail >= min_free) {
> -			list_move_tail(&device->dev_list, &private_devs);
> +			list_move_tail(&device->dev_list,
> +				       &private_devs);
>   			index++;
>   			if (type & BTRFS_BLOCK_GROUP_DUP)
>   				index++;
> @@ -999,9 +1045,16 @@ again:
>   		}
>   		return -ENOSPC;
>   	}
> -	ret = find_next_chunk(info, &offset);
> -	if (ret)
> -		return ret;
> +
> +	/*
> +	 * Fill chunk mapping and chunk stripes
> +	 */
> +alloc_chunk:
> +	if (!convert) {
> +		ret = find_next_chunk(info, &offset);
> +		if (ret)
> +			return ret;
> +	}
>   	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
>   	key.type = BTRFS_CHUNK_ITEM_KEY;
>   	key.offset = offset;
> @@ -1022,17 +1075,31 @@ again:
>   	index = 0;
>   	while(index < num_stripes) {
>   		struct btrfs_stripe *stripe;
> -		BUG_ON(list_empty(&private_devs));
> -		cur = private_devs.next;
> -		device = list_entry(cur, struct btrfs_device, dev_list);
>   
> -		/* loop over this device again if we're doing a dup group */
> -		if (!(type & BTRFS_BLOCK_GROUP_DUP) ||
> -		    (index == num_stripes - 1))
> -			list_move_tail(&device->dev_list, dev_list);
> +		if (!convert) {
> +			if (list_empty(&private_devs))
> +				return -ENODEV;
> +			cur = private_devs.next;
> +			device = list_entry(cur, struct btrfs_device, dev_list);
> +			if (!(type & BTRFS_BLOCK_GROUP_DUP) ||
> +			    (index == num_stripes - 1)) {
> +				/*
> +				 * loop over this device again if we're doing a
> +				 * dup group
> +				 */
> +				list_move_tail(&device->dev_list, dev_list);
> +			}
> +		} else {
> +			/* Only SINGLE is accepted in convert case */
> +			BUG_ON(num_stripes > 1);
> +			device = list_entry(dev_list->next, struct btrfs_device,
> +					    dev_list);
> +			key.offset = *start;
> +			dev_offset = *start;
> +		}
>   
>   		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
> -			     calc_size, &dev_offset, 0);
> +			     calc_size, &dev_offset, convert);
>   		if (ret < 0)
>   			goto out_chunk_map;
>   
> @@ -1049,7 +1116,7 @@ again:
>   		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
>   		index++;
>   	}
> -	BUG_ON(!list_empty(&private_devs));
> +	BUG_ON(!convert && !list_empty(&private_devs));
>   
>   	/* key was set above */
>   	btrfs_set_stack_chunk_length(chunk, *num_bytes);
> @@ -1069,6 +1136,9 @@ again:
>   	map->num_stripes = num_stripes;
>   	map->sub_stripes = sub_stripes;
>   
> +	/*
> +	 * Insert chunk item and chunk mapping.
> +	 */
>   	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
>   				btrfs_chunk_item_size(num_stripes));
>   	BUG_ON(ret);
> @@ -1098,125 +1168,6 @@ out_chunk:
>   	return ret;
>   }
>   
> -/*
> - * Alloc a DATA chunk with SINGLE profile.
> - *
> - * If 'convert' is set, it will alloc a chunk with 1:1 mapping
> - * (btrfs logical bytenr == on-disk bytenr)
> - * For that case, caller must make sure the chunk and dev_extent are not
> - * occupied.
> - */
> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
> -			   struct btrfs_fs_info *info, u64 *start,
> -			   u64 num_bytes, u64 type, int convert)
> -{
> -	u64 dev_offset;
> -	struct btrfs_root *extent_root = info->extent_root;
> -	struct btrfs_root *chunk_root = info->chunk_root;
> -	struct btrfs_stripe *stripes;
> -	struct btrfs_device *device = NULL;
> -	struct btrfs_chunk *chunk;
> -	struct list_head *dev_list = &info->fs_devices->devices;
> -	struct list_head *cur;
> -	struct map_lookup *map;
> -	u64 calc_size = SZ_8M;
> -	int num_stripes = 1;
> -	int sub_stripes = 0;
> -	int ret;
> -	int index;
> -	int stripe_len = BTRFS_STRIPE_LEN;
> -	struct btrfs_key key;
> -
> -	key.objectid = BTRFS_FIRST_CHUNK_TREE_OBJECTID;
> -	key.type = BTRFS_CHUNK_ITEM_KEY;
> -	if (convert) {
> -		if (*start != round_down(*start, info->sectorsize)) {
> -			error("DATA chunk start not sectorsize aligned: %llu",
> -					(unsigned long long)*start);
> -			return -EINVAL;
> -		}
> -		key.offset = *start;
> -		dev_offset = *start;
> -	} else {
> -		u64 tmp;
> -
> -		ret = find_next_chunk(info, &tmp);
> -		key.offset = tmp;
> -		if (ret)
> -			return ret;
> -	}
> -
> -	chunk = kmalloc(btrfs_chunk_item_size(num_stripes), GFP_NOFS);
> -	if (!chunk)
> -		return -ENOMEM;
> -
> -	map = kmalloc(btrfs_map_lookup_size(num_stripes), GFP_NOFS);
> -	if (!map) {
> -		kfree(chunk);
> -		return -ENOMEM;
> -	}
> -
> -	stripes = &chunk->stripe;
> -	calc_size = num_bytes;
> -
> -	index = 0;
> -	cur = dev_list->next;
> -	device = list_entry(cur, struct btrfs_device, dev_list);
> -
> -	while (index < num_stripes) {
> -		struct btrfs_stripe *stripe;
> -
> -		ret = btrfs_alloc_dev_extent(trans, device, key.offset,
> -			     calc_size, &dev_offset, convert);
> -		BUG_ON(ret);
> -
> -		device->bytes_used += calc_size;
> -		ret = btrfs_update_device(trans, device);
> -		BUG_ON(ret);
> -
> -		map->stripes[index].dev = device;
> -		map->stripes[index].physical = dev_offset;
> -		stripe = stripes + index;
> -		btrfs_set_stack_stripe_devid(stripe, device->devid);
> -		btrfs_set_stack_stripe_offset(stripe, dev_offset);
> -		memcpy(stripe->dev_uuid, device->uuid, BTRFS_UUID_SIZE);
> -		index++;
> -	}
> -
> -	/* key was set above */
> -	btrfs_set_stack_chunk_length(chunk, num_bytes);
> -	btrfs_set_stack_chunk_owner(chunk, extent_root->root_key.objectid);
> -	btrfs_set_stack_chunk_stripe_len(chunk, stripe_len);
> -	btrfs_set_stack_chunk_type(chunk, type);
> -	btrfs_set_stack_chunk_num_stripes(chunk, num_stripes);
> -	btrfs_set_stack_chunk_io_align(chunk, stripe_len);
> -	btrfs_set_stack_chunk_io_width(chunk, stripe_len);
> -	btrfs_set_stack_chunk_sector_size(chunk, info->sectorsize);
> -	btrfs_set_stack_chunk_sub_stripes(chunk, sub_stripes);
> -	map->sector_size = info->sectorsize;
> -	map->stripe_len = stripe_len;
> -	map->io_align = stripe_len;
> -	map->io_width = stripe_len;
> -	map->type = type;
> -	map->num_stripes = num_stripes;
> -	map->sub_stripes = sub_stripes;
> -
> -	ret = btrfs_insert_item(trans, chunk_root, &key, chunk,
> -				btrfs_chunk_item_size(num_stripes));
> -	BUG_ON(ret);
> -	if (!convert)
> -		*start = key.offset;
> -
> -	map->ce.start = key.offset;
> -	map->ce.size = num_bytes;
> -
> -	ret = insert_cache_extent(&info->mapping_tree.cache_tree, &map->ce);
> -	BUG_ON(ret);
> -
> -	kfree(chunk);
> -	return ret;
> -}
> -
>   int btrfs_num_copies(struct btrfs_fs_info *fs_info, u64 logical, u64 len)
>   {
>   	struct btrfs_mapping_tree *map_tree = &fs_info->mapping_tree;
> diff --git a/volumes.h b/volumes.h
> index 11572e78c04f..7bbdf615d31a 100644
> --- a/volumes.h
> +++ b/volumes.h
> @@ -208,10 +208,7 @@ int btrfs_read_sys_array(struct btrfs_fs_info *fs_info);
>   int btrfs_read_chunk_tree(struct btrfs_fs_info *fs_info);
>   int btrfs_alloc_chunk(struct btrfs_trans_handle *trans,
>   		      struct btrfs_fs_info *fs_info, u64 *start,
> -		      u64 *num_bytes, u64 type);
> -int btrfs_alloc_data_chunk(struct btrfs_trans_handle *trans,
> -			   struct btrfs_fs_info *fs_info, u64 *start,
> -			   u64 num_bytes, u64 type, int convert);
> +		      u64 *num_bytes, u64 type, bool convert);
>   int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>   		       int flags);
>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
> 


