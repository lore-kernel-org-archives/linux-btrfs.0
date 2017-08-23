Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:23261 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932458AbdHWSrF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 14:47:05 -0400
Date: Wed, 23 Aug 2017 11:45:44 -0600
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs: index check-integrity state hash by a dev_t
Message-ID: <20170823174544.GB1522@dhcp-10-211-47-181.usdhcp.oraclecorp.com>
Reply-To: bo.li.liu@oracle.com
References: <20170823171032.30529-1-hch@lst.de>
 <20170823171032.30529-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823171032.30529-2-hch@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 07:10:27PM +0200, Christoph Hellwig wrote:
> We won't have the struct block_device available in the bio soon, so switch
> to the numerical dev_t instead of the block_device pointer for looking up
> the check-integrity state.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/btrfs/check-integrity.c | 31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 11d37c94ce05..9d3854839038 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -296,8 +296,7 @@ static void btrfsic_dev_state_hashtable_add(
>  		struct btrfsic_dev_state *ds,
>  		struct btrfsic_dev_state_hashtable *h);
>  static void btrfsic_dev_state_hashtable_remove(struct btrfsic_dev_state *ds);
> -static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(
> -		struct block_device *bdev,
> +static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(dev_t dev,
>  		struct btrfsic_dev_state_hashtable *h);
>  static struct btrfsic_stack_frame *btrfsic_stack_frame_alloc(void);
>  static void btrfsic_stack_frame_free(struct btrfsic_stack_frame *sf);
> @@ -385,8 +384,7 @@ static int btrfsic_process_superblock_dev_mirror(
>  		int superblock_mirror_num,
>  		struct btrfsic_dev_state **selected_dev_state,
>  		struct btrfs_super_block *selected_super);
> -static struct btrfsic_dev_state *btrfsic_dev_state_lookup(
> -		struct block_device *bdev);
> +static struct btrfsic_dev_state *btrfsic_dev_state_lookup(dev_t dev);
>  static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
>  					   u64 bytenr,
>  					   struct btrfsic_dev_state *dev_state,
> @@ -626,17 +624,15 @@ static void btrfsic_dev_state_hashtable_remove(struct btrfsic_dev_state *ds)
>  	list_del(&ds->collision_resolving_node);
>  }
>  
> -static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(
> -		struct block_device *bdev,
> +static struct btrfsic_dev_state *btrfsic_dev_state_hashtable_lookup(dev_t dev,
>  		struct btrfsic_dev_state_hashtable *h)
>  {
>  	const unsigned int hashval =
> -	    (((unsigned int)((uintptr_t)bdev)) &
> -	     (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));
> +		dev & (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1);
>  	struct btrfsic_dev_state *ds;
>  
>  	list_for_each_entry(ds, h->table + hashval, collision_resolving_node) {
> -		if (ds->bdev == bdev)
> +		if (ds->bdev->bd_dev == dev)
>  			return ds;
>  	}
>  
> @@ -668,7 +664,7 @@ static int btrfsic_process_superblock(struct btrfsic_state *state,
>  		if (!device->bdev || !device->name)
>  			continue;
>  
> -		dev_state = btrfsic_dev_state_lookup(device->bdev);
> +		dev_state = btrfsic_dev_state_lookup(device->bdev->bd_dev);
>  		BUG_ON(NULL == dev_state);
>  		for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
>  			ret = btrfsic_process_superblock_dev_mirror(
> @@ -1556,7 +1552,7 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
>  	}
>  
>  	device = multi->stripes[0].dev;
> -	block_ctx_out->dev = btrfsic_dev_state_lookup(device->bdev);
> +	block_ctx_out->dev = btrfsic_dev_state_lookup(device->bdev->bd_dev);
>  	block_ctx_out->dev_bytenr = multi->stripes[0].physical;
>  	block_ctx_out->start = bytenr;
>  	block_ctx_out->len = len;
> @@ -2654,7 +2650,7 @@ static struct btrfsic_block *btrfsic_block_lookup_or_add(
>  			pr_info("btrfsic: error, kmalloc failed!\n");
>  			return NULL;
>  		}
> -		dev_state = btrfsic_dev_state_lookup(block_ctx->dev->bdev);
> +		dev_state = btrfsic_dev_state_lookup(block_ctx->dev->bdev->bd_dev);
>  		if (NULL == dev_state) {
>  			pr_info("btrfsic: error, lookup dev_state failed!\n");
>  			btrfsic_block_free(block);
> @@ -2734,10 +2730,9 @@ static void btrfsic_cmp_log_and_dev_bytenr(struct btrfsic_state *state,
>  	}
>  }
>  
> -static struct btrfsic_dev_state *btrfsic_dev_state_lookup(
> -		struct block_device *bdev)
> +static struct btrfsic_dev_state *btrfsic_dev_state_lookup(dev_t dev)
>  {
> -	return btrfsic_dev_state_hashtable_lookup(bdev,
> +	return btrfsic_dev_state_hashtable_lookup(dev,
>  						  &btrfsic_dev_state_hashtable);
>  }
>  
> @@ -2751,7 +2746,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
>  	mutex_lock(&btrfsic_mutex);
>  	/* since btrfsic_submit_bh() might also be called before
>  	 * btrfsic_mount(), this might return NULL */
> -	dev_state = btrfsic_dev_state_lookup(bh->b_bdev);
> +	dev_state = btrfsic_dev_state_lookup(bh->b_bdev->bd_dev);
>  
>  	/* Only called to write the superblock (incl. FLUSH/FUA) */
>  	if (NULL != dev_state &&
> @@ -2808,7 +2803,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
>  	mutex_lock(&btrfsic_mutex);
>  	/* since btrfsic_submit_bio() is also called before
>  	 * btrfsic_mount(), this might return NULL */
> -	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
> +	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev->bd_dev);
>  	if (NULL != dev_state &&
>  	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
>  		unsigned int i = 0;
> @@ -2998,7 +2993,7 @@ void btrfsic_unmount(struct btrfs_fs_devices *fs_devices)
>  			continue;
>  
>  		ds = btrfsic_dev_state_hashtable_lookup(
> -				device->bdev,
> +				device->bdev->bd_dev,
>  				&btrfsic_dev_state_hashtable);
>  		if (NULL != ds) {
>  			state = ds->state;
> -- 
> 2.11.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
