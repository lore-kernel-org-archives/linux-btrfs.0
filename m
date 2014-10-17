Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:51107 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbaJQHQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 03:16:16 -0400
Received: by mail-pd0-f169.google.com with SMTP id w10so308950pde.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Oct 2014 00:16:15 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH 2/2] Btrfs: check-int: don't complain about balanced blocks
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <1413474529-7251-2-git-send-email-sbehrens@giantdisaster.de>
Date: Fri, 17 Oct 2014 15:16:13 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8B9C507D-8E72-4947-A122-F9C3EA2870C4@gmail.com>
References: <1413474529-7251-1-git-send-email-sbehrens@giantdisaster.de> <1413474529-7251-2-git-send-email-sbehrens@giantdisaster.de>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

 The xfstest btrfs/014 which tests the balance operation caused that the
> check_int module complained that known blocks changed their physical
> location. Since this is not an error in this case, only print such
> message if the verbose mode was enabled.
> 
> Reported-by: Wang Shilong <wangshilong1991@gmail.com>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

This passed my Tests after applying both patches.

Tested-by: Wang Shilong <wangshilong1991@gmail.com>

> ---
> fs/btrfs/check-integrity.c | 87 ++++++++++++++++++++++++++--------------------
> 1 file changed, 49 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 65fc2e0bbc4a..65226d7c9fe0 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -1325,24 +1325,28 @@ static int btrfsic_create_link_to_next_block(
> 		l = NULL;
> 		next_block->generation = BTRFSIC_GENERATION_UNKNOWN;
> 	} else {
> -		if (next_block->logical_bytenr != next_bytenr &&
> -		    !(!next_block->is_metadata &&
> -		      0 == next_block->logical_bytenr)) {
> -			printk(KERN_INFO
> -			       "Referenced block @%llu (%s/%llu/%d)"
> -			       " found in hash table, %c,"
> -			       " bytenr mismatch (!= stored %llu).\n",
> -			       next_bytenr, next_block_ctx->dev->name,
> -			       next_block_ctx->dev_bytenr, *mirror_nump,
> -			       btrfsic_get_block_type(state, next_block),
> -			       next_block->logical_bytenr);
> -		} else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
> -			printk(KERN_INFO
> -			       "Referenced block @%llu (%s/%llu/%d)"
> -			       " found in hash table, %c.\n",
> -			       next_bytenr, next_block_ctx->dev->name,
> -			       next_block_ctx->dev_bytenr, *mirror_nump,
> -			       btrfsic_get_block_type(state, next_block));
> +		if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE) {
> +			if (next_block->logical_bytenr != next_bytenr &&
> +			    !(!next_block->is_metadata &&
> +			      0 == next_block->logical_bytenr))
> +				printk(KERN_INFO
> +				       "Referenced block @%llu (%s/%llu/%d)"
> +				       " found in hash table, %c,"
> +				       " bytenr mismatch (!= stored %llu).\n",
> +				       next_bytenr, next_block_ctx->dev->name,
> +				       next_block_ctx->dev_bytenr, *mirror_nump,
> +				       btrfsic_get_block_type(state,
> +							      next_block),
> +				       next_block->logical_bytenr);
> +			else
> +				printk(KERN_INFO
> +				       "Referenced block @%llu (%s/%llu/%d)"
> +				       " found in hash table, %c.\n",
> +				       next_bytenr, next_block_ctx->dev->name,
> +				       next_block_ctx->dev_bytenr, *mirror_nump,
> +				       btrfsic_get_block_type(state,
> +							      next_block));
> +		}
> 		next_block->logical_bytenr = next_bytenr;
> 
> 		next_block->mirror_num = *mirror_nump;
> @@ -1528,7 +1532,9 @@ static int btrfsic_handle_extent_data(
> 				return -1;
> 			}
> 			if (!block_was_created) {
> -				if (next_block->logical_bytenr != next_bytenr &&
> +				if ((state->print_mask &
> +				     BTRFSIC_PRINT_MASK_VERBOSE) &&
> +				    next_block->logical_bytenr != next_bytenr &&
> 				    !(!next_block->is_metadata &&
> 				      0 == next_block->logical_bytenr)) {
> 					printk(KERN_INFO
> @@ -1881,25 +1887,30 @@ again:
> 							       dev_state,
> 							       dev_bytenr);
> 			}
> -			if (block->logical_bytenr != bytenr &&
> -			    !(!block->is_metadata &&
> -			      block->logical_bytenr == 0))
> -				printk(KERN_INFO
> -				       "Written block @%llu (%s/%llu/%d)"
> -				       " found in hash table, %c,"
> -				       " bytenr mismatch"
> -				       " (!= stored %llu).\n",
> -				       bytenr, dev_state->name, dev_bytenr,
> -				       block->mirror_num,
> -				       btrfsic_get_block_type(state, block),
> -				       block->logical_bytenr);
> -			else if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE)
> -				printk(KERN_INFO
> -				       "Written block @%llu (%s/%llu/%d)"
> -				       " found in hash table, %c.\n",
> -				       bytenr, dev_state->name, dev_bytenr,
> -				       block->mirror_num,
> -				       btrfsic_get_block_type(state, block));
> +			if (state->print_mask & BTRFSIC_PRINT_MASK_VERBOSE) {
> +				if (block->logical_bytenr != bytenr &&
> +				    !(!block->is_metadata &&
> +				      block->logical_bytenr == 0))
> +					printk(KERN_INFO
> +					       "Written block @%llu (%s/%llu/%d)"
> +					       " found in hash table, %c,"
> +					       " bytenr mismatch"
> +					       " (!= stored %llu).\n",
> +					       bytenr, dev_state->name,
> +					       dev_bytenr,
> +					       block->mirror_num,
> +					       btrfsic_get_block_type(state,
> +								      block),
> +					       block->logical_bytenr);
> +				else
> +					printk(KERN_INFO
> +					       "Written block @%llu (%s/%llu/%d)"
> +					       " found in hash table, %c.\n",
> +					       bytenr, dev_state->name,
> +					       dev_bytenr, block->mirror_num,
> +					       btrfsic_get_block_type(state,
> +								      block));
> +			}
> 			block->logical_bytenr = bytenr;
> 		} else {
> 			if (num_pages * PAGE_CACHE_SIZE <
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Best Regards,
Wang Shilong

