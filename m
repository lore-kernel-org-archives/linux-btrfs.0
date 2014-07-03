Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30012 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbaGCJZK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 05:25:10 -0400
Date: Thu, 3 Jul 2014 17:24:59 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: only unlock block in verify_parent_transid if we
 locked it
Message-ID: <20140703092458.GC20612@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1403729141-10434-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403729141-10434-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 25, 2014 at 01:45:41PM -0700, Josef Bacik wrote:
> This is a regression from my patch a26e8c9f75b0bfd8cccc9e8f110737b136eb5994, we
> need to only unlock the block if we were the one who locked it.  Otherwise this
> will trip BUG_ON()'s in locking.c  Thanks,
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

-liubo

> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/disk-io.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 8bb4aa1..f00165d 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -369,7 +369,8 @@ static int verify_parent_transid(struct extent_io_tree *io_tree,
>  out:
>  	unlock_extent_cached(io_tree, eb->start, eb->start + eb->len - 1,
>  			     &cached_state, GFP_NOFS);
> -	btrfs_tree_read_unlock_blocking(eb);
> +	if (need_lock)
> +		btrfs_tree_read_unlock_blocking(eb);
>  	return ret;
>  }
>  
> -- 
> 2.0.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
