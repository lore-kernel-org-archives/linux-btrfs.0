From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: remove BUG_ON() in compress_file_range()
Date: Thu, 22 Sep 2011 12:23:43 +0200
Message-ID: <20110922102343.GS22205@twin.jikos.cz>
References: <4E6826C9.7030603@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E6826C9.7030603@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 08, 2011 at 10:22:01AM +0800, Li Zefan wrote:
> It's not a big deal if we fail to allocate the array, and instead of
> panic we can just give up compressing.

Makes sense.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Reviewed-by: David Sterba <dsterba@suse.cz>

> ---
>  fs/btrfs/inode.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0ccc743..63b4fc0 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -393,7 +393,10 @@ again:
>  	     (BTRFS_I(inode)->flags & BTRFS_INODE_COMPRESS))) {
>  		WARN_ON(pages);
>  		pages = kzalloc(sizeof(struct page *) * nr_pages, GFP_NOFS);
> -		BUG_ON(!pages);
> +		if (!pages) {
> +			/* just bail out to the uncompressed code */
> +			goto cont;
> +		}
>  
>  		if (BTRFS_I(inode)->force_compress)
>  			compress_type = BTRFS_I(inode)->force_compress;
> @@ -424,6 +427,7 @@ again:
>  			will_compress = 1;
>  		}
>  	}
> +cont:
>  	if (start == 0) {
>  		trans = btrfs_join_transaction(root);
>  		BUG_ON(IS_ERR(trans));
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
