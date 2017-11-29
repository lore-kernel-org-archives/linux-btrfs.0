Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48098 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753851AbdK2REp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 29 Nov 2017 12:04:45 -0500
Date: Wed, 29 Nov 2017 18:04:43 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: hannes@cmpxchg.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        jack@suse.cz, linux-fsdevel@vger.kernel.org, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v2 03/11] lib: make the fprop batch size a multiple of
 PAGE_SIZE
Message-ID: <20171129170443.GC28256@quack2.suse.cz>
References: <1511385366-20329-1-git-send-email-josef@toxicpanda.com>
 <1511385366-20329-4-git-send-email-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1511385366-20329-4-git-send-email-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed 22-11-17 16:15:58, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We are converting the writeback counters to use bytes instead of pages,
> so we need to make the batch size for the percpu modifications align
> properly with the new units.  Since we used pages before, just multiply
> by PAGE_SIZE to get the equivalent bytes for the batch size.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Looks good to me, just please make this part of patch 5/11. Otherwise
bisection may get broken by too large errors in per-cpu counters of IO
completions... Thanks!

								Honza

> ---
>  lib/flex_proportions.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/flex_proportions.c b/lib/flex_proportions.c
> index 2cc1f94e03a1..b0343ae71f5e 100644
> --- a/lib/flex_proportions.c
> +++ b/lib/flex_proportions.c
> @@ -166,7 +166,7 @@ void fprop_fraction_single(struct fprop_global *p,
>  /*
>   * ---- PERCPU ----
>   */
> -#define PROP_BATCH (8*(1+ilog2(nr_cpu_ids)))
> +#define PROP_BATCH (8*PAGE_SIZE*(1+ilog2(nr_cpu_ids)))
>  
>  int fprop_local_init_percpu(struct fprop_local_percpu *pl, gfp_t gfp)
>  {
> -- 
> 2.7.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
