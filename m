Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:18717 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753501AbaJQIEW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Oct 2014 04:04:22 -0400
Message-ID: <5440CDED.8010907@cn.fujitsu.com>
Date: Fri, 17 Oct 2014 16:06:05 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: check-int: don't complain about balanced blocks
References: <1413474529-7251-1-git-send-email-sbehrens@giantdisaster.de> <1413474529-7251-2-git-send-email-sbehrens@giantdisaster.de>
In-Reply-To: <1413474529-7251-2-git-send-email-sbehrens@giantdisaster.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 16 Oct 2014 17:48:49 +0200, Stefan Behrens wrote:
> The xfstest btrfs/014 which tests the balance operation caused that the
> check_int module complained that known blocks changed their physical
> location. Since this is not an error in this case, only print such
> message if the verbose mode was enabled.
> 
> Reported-by: Wang Shilong <wangshilong1991@gmail.com>
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/check-integrity.c | 87 ++++++++++++++++++++++++++--------------------
>  1 file changed, 49 insertions(+), 38 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 65fc2e0bbc4a..65226d7c9fe0 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -1325,24 +1325,28 @@ static int btrfsic_create_link_to_next_block(
>  		l = NULL;
>  		next_block->generation = BTRFSIC_GENERATION_UNKNOWN;
>  	} else {
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

According to the coding style, we don't expect the user-visible strings are broken.

Thanks
Miao

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
>  		next_block->logical_bytenr = next_bytenr;
>  
>  		next_block->mirror_num = *mirror_nump;
> @@ -1528,7 +1532,9 @@ static int btrfsic_handle_extent_data(
>  				return -1;
>  			}
>  			if (!block_was_created) {
> -				if (next_block->logical_bytenr != next_bytenr &&
> +				if ((state->print_mask &
> +				     BTRFSIC_PRINT_MASK_VERBOSE) &&
> +				    next_block->logical_bytenr != next_bytenr &&
>  				    !(!next_block->is_metadata &&
>  				      0 == next_block->logical_bytenr)) {
>  					printk(KERN_INFO
> @@ -1881,25 +1887,30 @@ again:
>  							       dev_state,
>  							       dev_bytenr);
>  			}
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
>  			block->logical_bytenr = bytenr;
>  		} else {
>  			if (num_pages * PAGE_CACHE_SIZE <
> 

