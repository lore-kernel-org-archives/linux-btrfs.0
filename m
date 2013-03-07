Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17129 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3CGNsy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Mar 2013 08:48:54 -0500
Date: Thu, 7 Mar 2013 21:46:33 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@fusionio.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix a mismerge in btrfs_balance()
Message-ID: <20130307134632.GF18241@liubo.jp.oracle.com>
Reply-To: bo.li.liu@oracle.com
References: <1362560275-3223-1-git-send-email-idryomov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362560275-3223-1-git-send-email-idryomov@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 06, 2013 at 10:57:55AM +0200, Ilya Dryomov wrote:
> Raid56 merge (merge commit e942f88) had mistakenly removed a call to
> __cancel_balance(), which resulted in balance not cleaning up after itself
> after a successful finish.  (Cleanup includes switching the state, removing
> the balance item and releasing mut_ex_op testnset lock.)  Bring it back.
> 

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Reported-by: David Sterba <dsterba@suse.cz>
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  fs/btrfs/volumes.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 35bb2d4..33440da 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -3230,6 +3230,11 @@ int btrfs_balance(struct btrfs_balance_control *bctl,
>  		update_ioctl_balance_args(fs_info, 0, bargs);
>  	}
>  
> +	if ((ret && ret != -ECANCELED && ret != -ENOSPC) ||
> +	    balance_need_close(fs_info)) {
> +		__cancel_balance(fs_info);
> +	}
> +
>  	wake_up(&fs_info->balance_wait_q);
>  
>  	return ret;
> -- 
> 1.7.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
