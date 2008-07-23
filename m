From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Use do_div() instead of native 64-bit division in
	btrfs_ordered_sum_size()
Date: Wed, 23 Jul 2008 07:13:09 -0400
Message-ID: <20080723111309.GA19988@infradead.org>
References: <1216697528.18980.34.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1216697528.18980.34.camel@shinybook.infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris, can you please put this patch in?  Without it btrfs can't be
loaded on 32bit platforms.

On Mon, Jul 21, 2008 at 11:32:08PM -0400, David Woodhouse wrote:
> Prevents the compiler emitting calls to __udivdi3() from libgcc on some
> platforms:
> WARNING: "__udivdi3" [/shiny/git/btrfs-kernel-unstable/btrfs.ko] undefined!
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> ---
> Untested but ObviouslyCorrect???. Now that I can load the module, I hit a
> BUG() immediately -- but I don't think it's caused by this patch. qv.
> 
> diff --git a/ordered-data.h b/ordered-data.h
> index 1794efd..1abe5f5 100644
> --- a/ordered-data.h
> +++ b/ordered-data.h
> @@ -97,9 +97,12 @@ struct btrfs_ordered_extent {
>   */
>  static inline int btrfs_ordered_sum_size(struct btrfs_root *root, u64 bytes)
>  {
> -	unsigned long num_sectors = (bytes + root->sectorsize - 1) /
> -		root->sectorsize;
> -	num_sectors++;
> +	unsigned long num_sectors;
> +
> +	bytes += root->sectorsize - 1;
> +	do_div(bytes, root->sectorsize);
> +	num_sectors = bytes + 1;
> +
>  	return sizeof(struct btrfs_ordered_sum) +
>  		num_sectors * sizeof(struct btrfs_sector_sum);
>  }
> 
> -- 
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
