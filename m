From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [patch] btrfs: fix gfp flags masking
Date: Mon, 15 Mar 2010 11:29:03 -0400
Message-ID: <20100315152903.GT3035@think>
References: <20100315150016.GC2869@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100315150016.GC2869@laptop>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 16, 2010 at 02:00:16AM +1100, Nick Piggin wrote:
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> --
> Index: linux-2.6/fs/btrfs/compression.c
> ===================================================================
> --- linux-2.6.orig/fs/btrfs/compression.c
> +++ linux-2.6/fs/btrfs/compression.c
> @@ -478,7 +478,7 @@ static noinline int add_ra_bio_pages(str
>  			goto next;
>  		}
>  
> -		page = alloc_page(mapping_gfp_mask(mapping) | GFP_NOFS);
> +		page = alloc_page(mapping_gfp_mask(mapping) & ~__GFP_FS);
>  		if (!page)
>  			break;

Thanks Nick, this will be in the next pull.

-chris

