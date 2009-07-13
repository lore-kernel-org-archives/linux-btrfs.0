From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] brtfs: less- and greater than confusion
Date: Mon, 13 Jul 2009 09:22:52 -0400
Message-ID: <20090713132252.GB4704@think>
References: <4A5A6418.2070906@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, yan.zheng@oracle.com
To: Roel Kluin <roel.kluin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A5A6418.2070906@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 13, 2009 at 12:30:48AM +0200, Roel Kluin wrote:
> Without this the loop won't start
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3ab80e9..2c873c9 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2795,7 +2795,7 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
>  		}
>  	}
>  
> -	for (i = 0; i > nr; i++) {
> +	for (i = 0; i < nr; i++) {
>  		struct btrfs_multi_bio *multi;
>  		struct btrfs_bio_stripe *stripe;
>  		int ret;

Thanks, this does look buggy.  That second loop should just be to verify
the first loop didn't mess things up.  Yan Zheng, is there any reason we
shouldn't delete it?

-chris

