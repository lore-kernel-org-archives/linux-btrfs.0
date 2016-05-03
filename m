Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13177 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932325AbcECBMJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 May 2016 21:12:09 -0400
Subject: Re: [PATCH 2/2] Btrfs: add valid checks for chunk loading
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1462212951-28113-1-git-send-email-bo.li.liu@oracle.com>
 <1462212951-28113-2-git-send-email-bo.li.liu@oracle.com>
CC: <vegard.nossum@oracle.com>, <sterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <42231399-bac4-1c41-bb43-f2c7b4d1a0a0@cn.fujitsu.com>
Date: Tue, 3 May 2016 09:12:01 +0800
MIME-Version: 1.0
In-Reply-To: <1462212951-28113-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Liu Bo wrote on 2016/05/02 11:15 -0700:
> To prevent fuzz filesystem images from panic the whole system,
> we need various validation checks to refuse to mount such an image
> if btrfs finds any invalid value during loading chunks, including
> both sys_array and regular chunks.
>
> Note that these checks may not be sufficient to cover all corner cases,
> feel free to add more checks.

Looks good for me.

But would you mind to do extra check on some minor members like owner, 
io_align, io_width and sub_stripes?
Since we have a dedicated function now, if not too hard, it's never a 
bad idea to check every member for best robust.

Especially sub_stripes, as it seems to be used by division in 
btrfs_rmap_block().

Thanks,
Qu
>
> Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
> Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> ---
>  fs/btrfs/volumes.c | 84 +++++++++++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 68 insertions(+), 16 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index bd0f45f..1075573 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -6206,27 +6206,23 @@ struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>  	return dev;
>  }
>
> -static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> -			  struct extent_buffer *leaf,
> -			  struct btrfs_chunk *chunk)
> +/* Return -EIO if any error, otherwise return 0. */
> +static int btrfs_check_chunk_valid(struct btrfs_root *root,
> +				   struct extent_buffer *leaf,
> +				   struct btrfs_chunk *chunk, u64 logical)
>  {
> -	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
> -	struct map_lookup *map;
> -	struct extent_map *em;
> -	u64 logical;
>  	u64 length;
>  	u64 stripe_len;
> -	u64 devid;
> -	u8 uuid[BTRFS_UUID_SIZE];
> -	int num_stripes;
> -	int ret;
> -	int i;
> +	u16 num_stripes;
> +	u16 sub_stripes;
> +	u64 type;
>
> -	logical = key->offset;
>  	length = btrfs_chunk_length(leaf, chunk);
>  	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
>  	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> -	/* Validation check */
> +	sub_stripes = btrfs_chunk_sub_stripes(leaf, chunk);
> +	type = btrfs_chunk_type(leaf, chunk);
> +
>  	if (!num_stripes) {
>  		btrfs_err(root->fs_info, "invalid chunk num_stripes: %u",
>  			  num_stripes);
> @@ -6237,24 +6233,70 @@ static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
>  			  "invalid chunk logical %llu", logical);
>  		return -EIO;
>  	}
> +	if (btrfs_chunk_sector_size(leaf, chunk) != root->sectorsize) {
> +		btrfs_err(root->fs_info, "invalid chunk sectorsize %llu",
> +			  (unsigned long long)btrfs_chunk_sector_size(leaf,
> +								      chunk));
> +		return -EIO;
> +	}
>  	if (!length || !IS_ALIGNED(length, root->sectorsize)) {
>  		btrfs_err(root->fs_info,
>  			"invalid chunk length %llu", length);
>  		return -EIO;
>  	}
> -	if (!is_power_of_2(stripe_len)) {
> +	if (stripe_len != BTRFS_STRIPE_LEN) {
>  		btrfs_err(root->fs_info, "invalid chunk stripe length: %llu",
>  			  stripe_len);
>  		return -EIO;
>  	}
>  	if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> -	    btrfs_chunk_type(leaf, chunk)) {
> +	    type) {
>  		btrfs_err(root->fs_info, "unrecognized chunk type: %llu",
>  			  ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
>  			    BTRFS_BLOCK_GROUP_PROFILE_MASK) &
>  			  btrfs_chunk_type(leaf, chunk));
>  		return -EIO;
>  	}
> +	if ((type & BTRFS_BLOCK_GROUP_RAID10 && sub_stripes == 0) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID1 && num_stripes < 1) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 2) ||
> +	    (type & BTRFS_BLOCK_GROUP_RAID5 && num_stripes < 3) ||
> +	    (type & BTRFS_BLOCK_GROUP_DUP && num_stripes > 2) ||
> +	    ((type & BTRFS_BLOCK_GROUP_PROFILE_MASK) == 0 &&
> +	     num_stripes != 1)) {
> +		btrfs_err(root->fs_info, "Invalid num_stripes:sub_stripes %u:%u for profile %llu",
> +			  num_stripes, sub_stripes,
> +			  type & BTRFS_BLOCK_GROUP_PROFILE_MASK);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int read_one_chunk(struct btrfs_root *root, struct btrfs_key *key,
> +			  struct extent_buffer *leaf,
> +			  struct btrfs_chunk *chunk)
> +{
> +	struct btrfs_mapping_tree *map_tree = &root->fs_info->mapping_tree;
> +	struct map_lookup *map;
> +	struct extent_map *em;
> +	u64 logical;
> +	u64 length;
> +	u64 stripe_len;
> +	u64 devid;
> +	u8 uuid[BTRFS_UUID_SIZE];
> +	int num_stripes;
> +	int ret;
> +	int i;
> +
> +	logical = key->offset;
> +	length = btrfs_chunk_length(leaf, chunk);
> +	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> +	num_stripes = btrfs_chunk_num_stripes(leaf, chunk);
> +	/* Validation check */
> +	ret = btrfs_check_chunk_valid(root, leaf, chunk, logical);
> +	if (ret)
> +		return ret;
>
>  	read_lock(&map_tree->map_tree.lock);
>  	em = lookup_extent_mapping(&map_tree->map_tree, logical, 1);
> @@ -6502,6 +6544,7 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>  	u32 array_size;
>  	u32 len = 0;
>  	u32 cur_offset;
> +	u64 type;
>  	struct btrfs_key key;
>
>  	ASSERT(BTRFS_SUPER_INFO_SIZE <= root->nodesize);
> @@ -6568,6 +6611,15 @@ int btrfs_read_sys_array(struct btrfs_root *root)
>  				break;
>  			}
>
> +			type = btrfs_chunk_type(sb, chunk);
> +			if ((type & BTRFS_BLOCK_GROUP_SYSTEM) == 0) {
> +				printk(KERN_ERR
> +	    "BTRFS: invalid chunk type %llu in sys_array at offset %u\n",
> +					type, cur_offset);
> +				ret = -EIO;
> +				break;
> +			}
> +
>  			len = btrfs_chunk_item_size(num_stripes);
>  			if (cur_offset + len > array_size)
>  				goto out_short_read;
>


