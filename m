From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 10/10] Btrfs: drop cache with VACANCY em when we fail to
 start a transaction
Date: Thu, 29 Mar 2012 10:01:56 -0400
Message-ID: <20120329140156.GN755@shiny>
References: <1332830678-3992-1-git-send-email-liubo2009@cn.fujitsu.com>
 <1332830678-3992-11-git-send-email-liubo2009@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1332830678-3992-11-git-send-email-liubo2009@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2012 at 02:44:38PM +0800, Liu Bo wrote:
> We need to clean a VACANCY em(if we have) when we fail to start a transaction.
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/inode.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index bacf441..2b2f0b6 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3406,9 +3406,6 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>  				break;
>  			}
>  
> -			btrfs_drop_extent_cache(inode, hole_start,
> -					last_byte - 1, 0);
> -
>  			btrfs_update_inode(trans, root, inode);
>  			btrfs_end_transaction(trans, root);
>  		}
> @@ -3419,6 +3416,9 @@ int btrfs_cont_expand(struct inode *inode, loff_t oldsize, loff_t size)
>  			break;
>  	}
>  
> +	if (em && test_bit(EXTENT_FLAG_VACANCY, &em->flags))
> +		btrfs_drop_extent_cache(inode, hole_start, last_byte - 1, 0);
> +

Hmmm, last_byte isn't always setup at this point (uninit variable).  I'm
a little uncertain about what this one is fixing?

-chris
