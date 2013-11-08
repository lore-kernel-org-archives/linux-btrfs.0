Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:43006 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3KHAvO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:51:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Himangi Saraogi <himangi774@gmail.com>, opw-kernel@googlegroups.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [OPW kernel] [PATCH v2] btrfs:check-integrity.c: replace kmalloc with kmalloc_array and kzalloc with kzalloc_array.
In-Reply-To: <20131106205550.GA11060@himangi-Inspiron-N5110gmail.com>
References: <20131106205550.GA11060@himangi-Inspiron-N5110gmail.com>
Date: Fri, 08 Nov 2013 11:10:26 +1030
Message-ID: <87wqkj4tfp.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Himangi Saraogi <himangi774@gmail.com> writes:
> This patch replaces kmalloc(size * nr, ) with kmalloc_array(nr, size)
> as kmalloc_array() is preferred because it can check that the
> calculation doesn't wrap and won't return a smaller allocation.
> Also kzalloc(size * nr) was replaced with kzalloc_array().
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>

Reviewed-by: Rusty Russell <rusty@rustcorp.com.au>

Cheers,
Rusty.

> ---
>  fs/btrfs/check-integrity.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 1c47be1..925a52b 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -1660,9 +1660,10 @@ static int btrfsic_read_block(struct btrfsic_state *state,
>  
>  	num_pages = (block_ctx->len + (u64)PAGE_CACHE_SIZE - 1) >>
>  		    PAGE_CACHE_SHIFT;
> -	block_ctx->mem_to_free = kzalloc((sizeof(*block_ctx->datav) +
> -					  sizeof(*block_ctx->pagev)) *
> -					 num_pages, GFP_NOFS);
> +	block_ctx->mem_to_free = kzalloc_array(num_pages,
> +						(sizeof(*block_ctx->datav) +
> +						 sizeof(*block_ctx->pagev)),
> +						GFP_NOFS);
>  	if (!block_ctx->mem_to_free)
>  		return -1;
>  	block_ctx->datav = block_ctx->mem_to_free;
> @@ -3031,8 +3032,9 @@ void btrfsic_submit_bio(int rw, struct bio *bio)
>  			       (unsigned long long)bio->bi_sector, dev_bytenr,
>  			       bio->bi_bdev);
>  
> -		mapped_datav = kmalloc(sizeof(*mapped_datav) * bio->bi_vcnt,
> -				       GFP_NOFS);
> +		mapped_datav = kmalloc_array(bio->bi_vcnt,
> +					     sizeof(*mapped_datav),
> +					     GFP_NOFS);
>  		if (!mapped_datav)
>  			goto leave;
>  		for (i = 0; i < bio->bi_vcnt; i++) {
> -- 
> 1.7.9.5
>
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
