Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:43066 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaJQHPu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 03:15:50 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so292024pad.36
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 00:15:50 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 1/2] Btrfs: check_int: use the known block location
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1413474529-7251-1-git-send-email-sbehrens@giantdisaster.de>
Date: Fri, 17 Oct 2014 15:15:35 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <6386E596-EEEA-4700-9166-27DF2033E063@gmail.com>
References: <1413474529-7251-1-git-send-email-sbehrens@giantdisaster.de>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> The xfstest btrfs/014 which tests the balance operation caused issues with
> the check_int module. The attempt was made to use btrfs_map_block() to
> find the physical location for a written block. However, this was not
> at all needed since the location of the written block was known since
> a hook to submit_bio() was the reason for entering the check_int module.
> Additionally, after a block relocation it happened that btrfs_map_block()
> failed causing misleading error messages afterwards.
> 
> This patch changes the check_int module to use the known information of
> the physical location from the bio.
> 
> Reported-by: Wang Shilong <wangshilong1991@gmail.com>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

This passed my Tests after applying both patches.

Tested-by: Wang Shilong <wangshilong1991@gmail.com>


> ---
> fs/btrfs/check-integrity.c | 66 ++++++++--------------------------------------
> 1 file changed, 11 insertions(+), 55 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index ce92ae30250f..65fc2e0bbc4a 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -326,9 +326,6 @@ static int btrfsic_handle_extent_data(struct btrfsic_state *state,
> static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
> 			     struct btrfsic_block_data_ctx *block_ctx_out,
> 			     int mirror_num);
> -static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
> -				  u32 len, struct block_device *bdev,
> -				  struct btrfsic_block_data_ctx *block_ctx_out);
> static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx);
> static int btrfsic_read_block(struct btrfsic_state *state,
> 			      struct btrfsic_block_data_ctx *block_ctx);
> @@ -1609,25 +1606,6 @@ static int btrfsic_map_block(struct btrfsic_state *state, u64 bytenr, u32 len,
> 	return ret;
> }
> 
> -static int btrfsic_map_superblock(struct btrfsic_state *state, u64 bytenr,
> -				  u32 len, struct block_device *bdev,
> -				  struct btrfsic_block_data_ctx *block_ctx_out)
> -{
> -	block_ctx_out->dev = btrfsic_dev_state_lookup(bdev);
> -	block_ctx_out->dev_bytenr = bytenr;
> -	block_ctx_out->start = bytenr;
> -	block_ctx_out->len = len;
> -	block_ctx_out->datav = NULL;
> -	block_ctx_out->pagev = NULL;
> -	block_ctx_out->mem_to_free = NULL;
> -	if (NULL != block_ctx_out->dev) {
> -		return 0;
> -	} else {
> -		printk(KERN_INFO "btrfsic: error, cannot lookup dev (#2)!\n");
> -		return -ENXIO;
> -	}
> -}
> -
> static void btrfsic_release_block_ctx(struct btrfsic_block_data_ctx *block_ctx)
> {
> 	if (block_ctx->mem_to_free) {
> @@ -2004,24 +1982,13 @@ again:
> 			}
> 		}
> 
> -		if (block->is_superblock)
> -			ret = btrfsic_map_superblock(state, bytenr,
> -						     processed_len,
> -						     bdev, &block_ctx);
> -		else
> -			ret = btrfsic_map_block(state, bytenr, processed_len,
> -						&block_ctx, 0);
> -		if (ret) {
> -			printk(KERN_INFO
> -			       "btrfsic: btrfsic_map_block(root @%llu)"
> -			       " failed!\n", bytenr);
> -			goto continue_loop;
> -		}
> -		block_ctx.datav = mapped_datav;
> -		/* the following is required in case of writes to mirrors,
> -		 * use the same that was used for the lookup */
> 		block_ctx.dev = dev_state;
> 		block_ctx.dev_bytenr = dev_bytenr;
> +		block_ctx.start = bytenr;
> +		block_ctx.len = processed_len;
> +		block_ctx.pagev = NULL;
> +		block_ctx.mem_to_free = NULL;
> +		block_ctx.datav = mapped_datav;
> 
> 		if (is_metadata || state->include_extent_data) {
> 			block->never_written = 0;
> @@ -2135,10 +2102,6 @@ again:
> 			/* this is getting ugly for the
> 			 * include_extent_data case... */
> 			bytenr = 0;	/* unknown */
> -			block_ctx.start = bytenr;
> -			block_ctx.len = processed_len;
> -			block_ctx.mem_to_free = NULL;
> -			block_ctx.pagev = NULL;
> 		} else {
> 			processed_len = state->metablock_size;
> 			bytenr = btrfs_stack_header_bytenr(
> @@ -2151,22 +2114,15 @@ again:
> 				       "Written block @%llu (%s/%llu/?)"
> 				       " !found in hash table, M.\n",
> 				       bytenr, dev_state->name, dev_bytenr);
> -
> -			ret = btrfsic_map_block(state, bytenr, processed_len,
> -						&block_ctx, 0);
> -			if (ret) {
> -				printk(KERN_INFO
> -				       "btrfsic: btrfsic_map_block(root @%llu)"
> -				       " failed!\n",
> -				       dev_bytenr);
> -				goto continue_loop;
> -			}
> 		}
> -		block_ctx.datav = mapped_datav;
> -		/* the following is required in case of writes to mirrors,
> -		 * use the same that was used for the lookup */
> +
> 		block_ctx.dev = dev_state;
> 		block_ctx.dev_bytenr = dev_bytenr;
> +		block_ctx.start = bytenr;
> +		block_ctx.len = processed_len;
> +		block_ctx.pagev = NULL;
> +		block_ctx.mem_to_free = NULL;
> +		block_ctx.datav = mapped_datav;
> 
> 		block = btrfsic_block_alloc();
> 		if (NULL == block) {
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

