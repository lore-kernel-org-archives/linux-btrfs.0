Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45071 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbbLKSf1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Dec 2015 13:35:27 -0500
Date: Fri, 11 Dec 2015 10:35:21 -0800
From: Liu Bo <bo.li.liu@oracle.com>
To: fdmanana@kernel.org
Cc: linux-btrfs@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH] Btrfs: fix transaction handle leak in balance
Message-ID: <20151211183520.GA13961@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1449746187-11806-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1449746187-11806-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 10, 2015 at 11:16:27AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> If we fail to allocate a new data chunk, we were jumping to the error path
> without release the transaction handle we got before. Fix this by always
> releasing it before doing the jump.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Fixes: 2c9fe8355258 ("btrfs: Fix lost-data-profile caused by balance bg")
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
>  fs/btrfs/volumes.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 3e55e07..f5e5e20 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3548,12 +3548,11 @@ again:
>  
>  			ret = btrfs_force_chunk_alloc(trans, chunk_root,
>  						      BTRFS_BLOCK_GROUP_DATA);
> +			btrfs_end_transaction(trans, chunk_root);
>  			if (ret < 0) {
>  				mutex_unlock(&fs_info->delete_unused_bgs_mutex);
>  				goto error;
>  			}
> -
> -			btrfs_end_transaction(trans, chunk_root);
>  			chunk_reserved = 1;
>  		}
>  
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
