Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43769 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623AbbBPJ3u (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Feb 2015 04:29:50 -0500
Date: Mon, 16 Feb 2015 17:29:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix condition of commit transaction
Message-ID: <20150216092934.GA23683@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1423919919-25118-1-git-send-email-zhaolei@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1423919919-25118-1-git-send-email-zhaolei@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 14, 2015 at 09:18:39PM +0800, Zhaolei wrote:
> From: Zhao Lei <zhaolei@cn.fujitsu.com>
> 
> Old code bypass commit transaction when we don't have enough
> pinned space, but another case is there exist freed bgs in current
> transction, it have possibility to make alloc_chunk success.
> 
> This patch modify the condition to:
> if (have_free_bg || have_pinned_space) commit_transaction()
> 
> Confirmed above action by printk before and after patch.

Looks good.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

Thanks,

-liubo
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index a684086..414d533 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3679,7 +3679,7 @@ int btrfs_check_data_free_space(struct inode *inode, u64 bytes)
>  	struct btrfs_root *root = BTRFS_I(inode)->root;
>  	struct btrfs_fs_info *fs_info = root->fs_info;
>  	u64 used;
> -	int ret = 0, committed = 0, alloc_chunk = 1;
> +	int ret = 0, committed = 0, have_pinned_space = 1, alloc_chunk = 1;
>  
>  	/* make sure bytes are sectorsize aligned */
>  	bytes = ALIGN(bytes, root->sectorsize);
> @@ -3747,11 +3747,12 @@ alloc:
>  
>  		/*
>  		 * If we don't have enough pinned space to deal with this
> -		 * allocation don't bother committing the transaction.
> +		 * allocation, and no removed chunk in current transaction,
> +		 * don't bother committing the transaction.
>  		 */
>  		if (percpu_counter_compare(&data_sinfo->total_bytes_pinned,
>  					   bytes) < 0)
> -			committed = 1;
> +			have_pinned_space = 0;
>  		spin_unlock(&data_sinfo->lock);
>  
>  		/* commit the current transaction and try again */
> @@ -3763,10 +3764,15 @@ commit_trans:
>  			trans = btrfs_join_transaction(root);
>  			if (IS_ERR(trans))
>  				return PTR_ERR(trans);
> -			ret = btrfs_commit_transaction(trans, root);
> -			if (ret)
> -				return ret;
> -			goto again;
> +			if (have_pinned_space ||
> +			    trans->transaction->have_free_bgs) {
> +				ret = btrfs_commit_transaction(trans, root);
> +				if (ret)
> +					return ret;
> +				goto again;
> +			} else {
> +				btrfs_end_transaction(trans, root);
> +			}
>  		}
>  
>  		trace_btrfs_space_reservation(root->fs_info,
> -- 
> 1.8.5.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
