From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Btrfs: Remove useless condition
Date: Sun, 12 Sep 2010 14:29:55 +0200
Message-ID: <20100912122955.GA28839@cmpxchg.org>
References: <1284289340.2650.2.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1284289340.2650.2.camel@ht.satnam>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 12, 2010 at 04:32:20PM +0530, Jaswinder Singh Rajput wrote:
> 
> if (ret) is useless as it will be never NULL as in previous statement
> we are setting ret = prev for !ret

If there is no match and no extent below the given file offset, `prev'
will be NULL as well, no?

So the check is not useless, it prevents throwing out a cached success
in case of a lookup failure.

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Chris Mason <chris.mason@oracle.com>
> ---
>  fs/btrfs/ordered-data.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
> index e56c72b..7b04008 100644
> --- a/fs/btrfs/ordered-data.c
> +++ b/fs/btrfs/ordered-data.c
> @@ -154,8 +154,7 @@ static inline struct rb_node *tree_search(struct btrfs_ordered_inode_tree *tree,
>  	ret = __tree_search(root, file_offset, &prev);
>  	if (!ret)
>  		ret = prev;
> -	if (ret)
> -		tree->last = ret;
> +	tree->last = ret;
>  	return ret;
>  }
>  
> -- 
> 1.7.2.2
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
