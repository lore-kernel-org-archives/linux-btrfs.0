Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52154 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2K3G0v (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 01:26:51 -0500
Received: by mail-ie0-f174.google.com with SMTP id c11so174883ieb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Nov 2012 22:26:50 -0800 (PST)
Message-ID: <50B851A1.5070604@gmail.com>
Date: Fri, 30 Nov 2012 14:26:41 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: chris.mason@fusionio.com, jbacik@fusionio.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use ctl->unit for free space calculation instead
 of block_group->sectorsize
In-Reply-To: <50b84bff.e756420a.16c1.ffffc35a@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50b84bff.e756420a.16c1.ffffc35a@mx.google.com>

Sorry, there is coding style error with this patch.
I'll resend this patch later.

thanks,

On 2012年11月30日 14:02, shhuiw@gmail.com wrote:

> From: Wang Sheng-Hui <shhuiw@gmail.com>
> 
> We should use ctl->unit for free space calculation instead of block_group->sectorsize
> even though for free space use_bitmap or free space cluster we only have sectorsize assigned to ctl->unit currently. Also, we can keep it consisten in code style.
> 
> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
> ---
>  fs/btrfs/free-space-cache.c |   20 +++++++++-----------
>  1 files changed, 9 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 1027b85..c3318cb 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -1364,7 +1364,7 @@ static void recalculate_thresholds(struct btrfs_free_space_ctl *ctl)
>  	u64 bitmap_bytes;
>  	u64 extent_bytes;
>  	u64 size = block_group->key.offset;
> -	u64 bytes_per_bg = BITS_PER_BITMAP * block_group->sectorsize;
> +	u64 bytes_per_bg = BITS_PER_BITMAP * ctl->unit;
>  	int max_bitmaps = div64_u64(size + bytes_per_bg - 1, bytes_per_bg);
>  
>  	BUG_ON(ctl->total_bitmaps > max_bitmaps);
> @@ -1650,8 +1650,7 @@ static bool use_bitmap(struct btrfs_free_space_ctl *ctl,
>  	 * some block groups are so tiny they can't be enveloped by a bitmap, so
>  	 * don't even bother to create a bitmap for this
>  	 */
> -	if (BITS_PER_BITMAP * block_group->sectorsize >
> -	    block_group->key.offset)
> +	if (BITS_PER_BITMAP * ctl->unit > block_group->key.offset)
>  		return false;
>  
>  	return true;
> @@ -2298,10 +2297,10 @@ static int btrfs_bitmap_cluster(struct btrfs_block_group_cache *block_group,
>  	unsigned long total_found = 0;
>  	int ret;
>  
> -	i = offset_to_bit(entry->offset, block_group->sectorsize,
> +	i = offset_to_bit(entry->offset, ctl->unit, 
>  			  max_t(u64, offset, entry->offset));
> -	want_bits = bytes_to_bits(bytes, block_group->sectorsize);
> -	min_bits = bytes_to_bits(min_bytes, block_group->sectorsize);
> +	want_bits = bytes_to_bits(bytes, ctl->unit);
> +	min_bits = bytes_to_bits(min_bytes, ctl->unit);
>  
>  again:
>  	found_bits = 0;
> @@ -2325,23 +2324,22 @@ again:
>  
>  	total_found += found_bits;
>  
> -	if (cluster->max_size < found_bits * block_group->sectorsize)
> -		cluster->max_size = found_bits * block_group->sectorsize;
> +	if (cluster->max_size < found_bits * ctl->unit)
> +		cluster->max_size = found_bits * ctl->unit;
>  
>  	if (total_found < want_bits || cluster->max_size < cont1_bytes) {
>  		i = next_zero + 1;
>  		goto again;
>  	}
>  
> -	cluster->window_start = start * block_group->sectorsize +
> -		entry->offset;
> +	cluster->window_start = start * ctl->unit + entry->offset;
>  	rb_erase(&entry->offset_index, &ctl->free_space_offset);
>  	ret = tree_insert_offset(&cluster->root, entry->offset,
>  				 &entry->offset_index, 1);
>  	BUG_ON(ret); /* -EEXIST; Logic error */
>  
>  	trace_btrfs_setup_cluster(block_group, cluster,
> -				  total_found * block_group->sectorsize, 1);
> +				  total_found * ctl->unit, 1);
>  	return 0;
>  }
>  


