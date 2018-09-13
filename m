Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50579 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725757AbeINERk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Sep 2018 00:17:40 -0400
Subject: Re: [PATCH 1/3] btrfs-progs: check: lowmem: Factor out inline extent
 checking code in its own function
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180913120507.18197-1-nborisov@suse.com>
 <20180913120507.18197-2-nborisov@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f45fbd7f-540e-7a69-34f7-1a92c60af110@gmx.com>
Date: Fri, 14 Sep 2018 07:05:51 +0800
MIME-Version: 1.0
In-Reply-To: <20180913120507.18197-2-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018/9/13 下午8:05, Nikolay Borisov wrote:
> Since the inline extent code can be largely self-sufficient, factor
> it out from check_file_extent. No functional changes.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Indeed makes more sense to refactor inline check out.

Thanks,
Qu

> ---
>  check/mode-lowmem.c | 142 ++++++++++++++++++++++++++------------------
>  1 file changed, 83 insertions(+), 59 deletions(-)
> 
> diff --git a/check/mode-lowmem.c b/check/mode-lowmem.c
> index 1bce44f5658a..48c1537e7440 100644
> --- a/check/mode-lowmem.c
> +++ b/check/mode-lowmem.c
> @@ -1800,6 +1800,87 @@ static int repair_inline_ram_bytes(struct btrfs_root *root,
>  	return ret;
>  }
>  
> +
> +static int check_file_extent_inline(struct btrfs_root *root,
> +				    struct btrfs_path *path, u64 *size,
> +				    u64 *end)
> +{
> +	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
> +				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
> +	struct extent_buffer *node = path->nodes[0];
> +	struct btrfs_item *e = btrfs_item_nr(0);
> +	struct btrfs_file_extent_item *fi;
> +	struct btrfs_key fkey;
> +	u64 extent_num_bytes;
> +	u32 item_inline_len;
> +	int ret;
> +	int compressed = 0;
> +	int err = 0;
> +
> +	fi = btrfs_item_ptr(node, path->slots[0],
> +			    struct btrfs_file_extent_item);
> +	item_inline_len = btrfs_file_extent_inline_item_len(node, e);
> +	extent_num_bytes = btrfs_file_extent_ram_bytes(node, fi);
> +	compressed = btrfs_file_extent_compression(node, fi);
> +	btrfs_item_key_to_cpu(node, &fkey, path->slots[0]);
> +
> +	if (extent_num_bytes == 0) {
> +		error(
> +"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
> +				root->objectid, fkey.objectid, fkey.offset);
> +		err |= FILE_EXTENT_ERROR;
> +	}
> +
> +	if (compressed) {
> +		if (extent_num_bytes > root->fs_info->sectorsize) {
> +			error(
> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
> +				root->objectid, fkey.objectid,
> +				fkey.offset, extent_num_bytes,
> +				root->fs_info->sectorsize - 1);
> +				err |= FILE_EXTENT_ERROR;
> +		}
> +
> +		if (item_inline_len > max_inline_extent_size) {
> +			error(
> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
> +				root->objectid, fkey.objectid,
> +				fkey.offset, item_inline_len,
> +				max_inline_extent_size);
> +				err |= FILE_EXTENT_ERROR;
> +		}
> +
> +	} else {
> +
> +		if (extent_num_bytes > max_inline_extent_size) {
> +			error(
> +"root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
> +				root->objectid, fkey.objectid, fkey.offset,
> +				extent_num_bytes, max_inline_extent_size);
> +				err |= FILE_EXTENT_ERROR;
> +		}
> +
> +	}
> +	if (!compressed && extent_num_bytes != item_inline_len) {
> +		error(
> +"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
> +				root->objectid, fkey.objectid, fkey.offset,
> +				extent_num_bytes, item_inline_len);
> +		if (repair) {
> +			ret = repair_inline_ram_bytes(root, path,
> +						      &extent_num_bytes);
> +			if (ret)
> +				err |= FILE_EXTENT_ERROR;
> +		} else {
> +			err |= FILE_EXTENT_ERROR;
> +		}
> +	}
> +	*end += extent_num_bytes;
> +	*size += extent_num_bytes;
> +
> +	return err;
> +}
> +
>  /*
>   * Check file extent datasum/hole, update the size of the file extents,
>   * check and update the last offset of the file extent.
> @@ -1824,8 +1905,6 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  	u64 csum_found;		/* In byte size, sectorsize aligned */
>  	u64 search_start;	/* Logical range start we search for csum */
>  	u64 search_len;		/* Logical range len we search for csum */
> -	u32 max_inline_extent_size = min_t(u32, root->fs_info->sectorsize - 1,
> -				BTRFS_MAX_INLINE_DATA_SIZE(root->fs_info));
>  	unsigned int extent_type;
>  	unsigned int is_hole;
>  	int slot = path->slots[0];
> @@ -1838,63 +1917,8 @@ static int check_file_extent(struct btrfs_root *root, struct btrfs_path *path,
>  
>  	/* Check inline extent */
>  	extent_type = btrfs_file_extent_type(node, fi);
> -	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
> -		struct btrfs_item *e = btrfs_item_nr(slot);
> -		u32 item_inline_len;
> -
> -		item_inline_len = btrfs_file_extent_inline_item_len(node, e);
> -		extent_num_bytes = btrfs_file_extent_ram_bytes(node, fi);
> -		compressed = btrfs_file_extent_compression(node, fi);
> -		if (extent_num_bytes == 0) {
> -			error(
> -		"root %llu EXTENT_DATA[%llu %llu] has empty inline extent",
> -				root->objectid, fkey.objectid, fkey.offset);
> -			err |= FILE_EXTENT_ERROR;
> -		}
> -		if (compressed) {
> -			if (extent_num_bytes > root->fs_info->sectorsize) {
> -				error(
> -"root %llu EXTENT_DATA[%llu %llu] too large inline extent ram size, have %llu, max: %u",
> -					root->objectid, fkey.objectid,
> -					fkey.offset, extent_num_bytes,
> -					root->fs_info->sectorsize - 1);
> -				err |= FILE_EXTENT_ERROR;
> -			}
> -			if (item_inline_len > max_inline_extent_size) {
> -				error(
> -"root %llu EXTENT_DATA[%llu %llu] too large inline extent on-disk size, have %u, max: %u",
> -					root->objectid, fkey.objectid,
> -					fkey.offset, item_inline_len,
> -					max_inline_extent_size);
> -				err |= FILE_EXTENT_ERROR;
> -			}
> -		} else {
> -			if (extent_num_bytes > max_inline_extent_size) {
> - 			error(
> - "root %llu EXTENT_DATA[%llu %llu] too large inline extent size, have %llu, max: %u",
> - 				root->objectid, fkey.objectid, fkey.offset,
> - 				extent_num_bytes, max_inline_extent_size);
> -				err |= FILE_EXTENT_ERROR;
> -			}
> -		}
> -		if (!compressed && extent_num_bytes != item_inline_len) {
> -			error(
> -		"root %llu EXTENT_DATA[%llu %llu] wrong inline size, have: %llu, expected: %u",
> -				root->objectid, fkey.objectid, fkey.offset,
> -				extent_num_bytes, item_inline_len);
> -			if (repair) {
> -				ret = repair_inline_ram_bytes(root, path,
> -							      &extent_num_bytes);
> -				if (ret)
> -					err |= FILE_EXTENT_ERROR;
> -			} else {
> -				err |= FILE_EXTENT_ERROR;
> -			}
> -		}
> -		*end += extent_num_bytes;
> -		*size += extent_num_bytes;
> -		return err;
> -	}
> +	if (extent_type == BTRFS_FILE_EXTENT_INLINE)
> +		return check_file_extent_inline(root, path, size, end);
>  
>  	/* Check extent type */
>  	if (extent_type != BTRFS_FILE_EXTENT_REG &&
> 
