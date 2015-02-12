Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43283 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbbBLEpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 11 Feb 2015 23:45:52 -0500
Date: Thu, 12 Feb 2015 12:45:39 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] Btrfs: don't set and clear delalloc for O_DIRECT
 writes
Message-ID: <20150212044539.GC2416@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1423685339-8278-1-git-send-email-jbacik@fb.com>
 <1423685339-8278-2-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423685339-8278-2-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 03:08:58PM -0500, Josef Bacik wrote:
> We do this to get the space accounting, but this is just needless churn on the
> io_tree, so just drop setting/clearing delalloc and just drop the reserved data
> space when we have a successfull allocation.  Thanks,
> 

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/inode.c | 8 ++------
>  1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index e78a2fd..fb16fd3 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -7142,7 +7142,7 @@ static int btrfs_get_blocks_direct(struct inode *inode, sector_t iblock,
>  	int ret = 0;
>  
>  	if (create)
> -		unlock_bits |= EXTENT_DELALLOC | EXTENT_DIRTY;
> +		unlock_bits |= EXTENT_DIRTY;
>  	else
>  		len = min_t(u64, len, root->sectorsize);
>  
> @@ -7278,11 +7278,7 @@ unlock:
>  			BTRFS_I(inode)->outstanding_extents++;
>  			spin_unlock(&BTRFS_I(inode)->lock);
>  		}
> -
> -		ret = set_extent_bit(&BTRFS_I(inode)->io_tree, lockstart,
> -				     lockstart + len - 1, EXTENT_DELALLOC, NULL,
> -				     &cached_state, GFP_NOFS);
> -		BUG_ON(ret);
> +		btrfs_free_reserved_data_space(inode, len);
>  	}
>  
>  	/*
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
