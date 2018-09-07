Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46386 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbeIGXDa (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2018 19:03:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id u24-v6so7383445pfn.13
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Sep 2018 11:21:21 -0700 (PDT)
Date: Fri, 7 Sep 2018 11:21:19 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: use correct args for kcalloc in btrfsic_read_block
Message-ID: <20180907182119.GC29245@vader>
References: <1536343190-400-1-git-send-email-bo.liu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1536343190-400-1-git-send-email-bo.liu@linux.alibaba.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 08, 2018 at 01:59:50AM +0800, Liu Bo wrote:
> kcalloc is defined as
> kcalloc(size_t n, size_t size, gfp_t flags)
> 
> Although this won't cause problems in practice, btrfsic_read_block()
> has switched n with size.
> 
> This updates btrfsic_read_block() to be correct in using kcalloc.
> 
> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> ---
>  fs/btrfs/check-integrity.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index 833cf3c35b4d..651b75939ce9 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -1594,6 +1594,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
>  {
>  	unsigned int num_pages;
>  	unsigned int i;
> +	u64 size;

size_t?

Besides that, Reviewed-by: Omar Sandoval <osandov@fb.com>

>  	u64 dev_bytenr;
>  	int ret;
>  
> @@ -1608,9 +1609,8 @@ static int btrfsic_read_block(struct btrfsic_state *state,
>  
>  	num_pages = (block_ctx->len + (u64)PAGE_SIZE - 1) >>
>  		    PAGE_SHIFT;
> -	block_ctx->mem_to_free = kcalloc(sizeof(*block_ctx->datav) +
> -						sizeof(*block_ctx->pagev),
> -					 num_pages, GFP_NOFS);
> +	size = sizeof(*block_ctx->datav) + sizeof(*block_ctx->pagev);
> +	block_ctx->mem_to_free = kcalloc(num_pages, size, GFP_NOFS);
>  	if (!block_ctx->mem_to_free)
>  		return -ENOMEM;
>  	block_ctx->datav = block_ctx->mem_to_free;
> -- 
> 1.8.3.1
> 
