Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:54283 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754880Ab2IUPY5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Sep 2012 11:24:57 -0400
Date: Fri, 21 Sep 2012 17:24:44 +0200
From: David Sterba <dave@jikos.cz>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
Message-ID: <20120921152444.GV17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5051BAB8.7080200@cn.fujitsu.com>
 <505A8632.10101@cn.fujitsu.com>
 <505C2E62.2000400@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <505C2E62.2000400@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 21, 2012 at 05:07:46PM +0800, Miao Xie wrote:
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3335,6 +3335,24 @@ static long btrfs_ioctl_balance(struct file *file, void __user *arg)
>  
>  			goto do_balance;
>  		}
> +
> +		if ((bargs->data.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->data.usage < 0 || bargs->data.usage > 100)) {

the 0 checks belong here

> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->meta.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->meta.usage < 0 || bargs->meta.usage > 100)) {
> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
> +
> +		if ((bargs->sys.flags & BTRFS_BALANCE_ARGS_USAGE) &&
> +		    (bargs->sys.usage < 0 || bargs->sys.usage > 100)) {
> +			ret = -EINVAL;
> +			goto out_bargs;
> +		}
>  	} else {
>  		bargs = NULL;
>  	}
> @@ -2347,7 +2335,8 @@ static int chunk_usage_filter(struct btrfs_fs_info *fs_info, u64 chunk_offset,
>  	cache = btrfs_lookup_block_group(fs_info, chunk_offset);
>  	chunk_used = btrfs_block_group_used(&cache->item);
>  
> -	user_thresh = div_factor_fine(cache->key.offset, bargs->usage);
> +	BUG_ON(bargs->usage < 0 || bargs->usage > 100);

otherwise it reliably crashes here

> +	user_thresh = div_factor(cache->key.offset, bargs->usage);
>  	if (chunk_used < user_thresh)
>  		ret = 0;
>  

other than that, patch looks good tome,

thanks,
david
