Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab3JHBWU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 21:22:20 -0400
Date: Tue, 8 Oct 2013 09:22:08 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: free up block groups after everything
Message-ID: <20131008012207.GA768@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1381173361-7048-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381173361-7048-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 07, 2013 at 03:16:01PM -0400, Josef Bacik wrote:
> If we abort a transaction we will do the tree log cleanup at unmount, but this
> happens after we free up the block groups.  This makes all the leak detection
> warnings go off because we think we've leaked space but in reality we just
> haven't cleaned it up yet.  So instead do the block group cleanup stuff after
> free'ing the fs roots so we don't get these warnings.  Thanks,

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
>  fs/btrfs/disk-io.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index fdc75ab..419968e 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -3637,12 +3637,12 @@ int close_ctree(struct btrfs_root *root)
>  		       percpu_counter_sum(&fs_info->delalloc_bytes));
>  	}
>  
> -	btrfs_free_block_groups(fs_info);
> -
>  	btrfs_stop_all_workers(fs_info);
>  
>  	del_fs_roots(fs_info);
>  
> +	btrfs_free_block_groups(fs_info);
> +
>  	free_root_pointers(fs_info, 1);
>  
>  	iput(fs_info->btree_inode);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
