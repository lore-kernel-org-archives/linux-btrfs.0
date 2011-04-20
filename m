From: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] Btrfs: Free free_space item properly in
 btrfs_trim_block_group()
Date: Wed, 20 Apr 2011 14:22:02 +0200
Message-ID: <20110420122202.GA31675@twin.jikos.cz>
References: <4DAE9B53.7090504@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	lidongyang@novell.com
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DAE9B53.7090504@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

reviewed, and made sure by the means of a coccinelle script that there
are no other instances of any kmem_cache allocated data being kfreed.

dave

On Wed, Apr 20, 2011 at 04:37:39PM +0800, Li Zefan wrote:
> Since commit dc89e9824464e91fa0b06267864ceabe3186fd8b, we've changed
> to use a specific slab for alocation of free_space items.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/btrfs/free-space-cache.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
> index 11d2e9c..13c29b1 100644
> --- a/fs/btrfs/free-space-cache.c
> +++ b/fs/btrfs/free-space-cache.c
> @@ -2301,7 +2301,7 @@ int btrfs_trim_block_group(struct btrfs_block_group_cache *block_group,
>  			start = entry->offset;
>  			bytes = min(entry->bytes, end - start);
>  			unlink_free_space(block_group, entry);
> -			kfree(entry);
> +			kmem_cache_free(btrfs_free_space_cachep, entry);
>  		}
>  
>  		spin_unlock(&block_group->tree_lock);
> -- 1.7.3.1 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
