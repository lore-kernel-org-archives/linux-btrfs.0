Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:33004 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2K1KvX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 28 Nov 2012 05:51:23 -0500
Date: Wed, 28 Nov 2012 18:49:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2] Btrfs: fix off-by-one error of the reserved size of
 btrfs_allocate()
Message-ID: <20121128104932.GA2791@liubo>
References: <50B5E766.3010804@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50B5E766.3010804@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 28, 2012 at 06:28:54PM +0800, Miao Xie wrote:
> alloc_end is not the real end of the current extent, it is the start of the
> next adjoining extent. So we needn't +1 when calculating the size the space
> that is about to be reserved.
> 

Good catch.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

thanks,
liubo

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/file.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 641bbaa..bd5afcc 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2085,7 +2085,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>  	 * Make sure we have enough space before we do the
>  	 * allocation.
>  	 */
> -	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start + 1);
> +	ret = btrfs_check_data_free_space(inode, alloc_end - alloc_start);
>  	if (ret)
>  		return ret;
>  
> @@ -2192,7 +2192,7 @@ static long btrfs_fallocate(struct file *file, int mode,
>  out:
>  	mutex_unlock(&inode->i_mutex);
>  	/* Let go of our reservation. */
> -	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start + 1);
> +	btrfs_free_reserved_data_space(inode, alloc_end - alloc_start);
>  	return ret;
>  }
>  
> -- 
> 1.7.11.7
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
