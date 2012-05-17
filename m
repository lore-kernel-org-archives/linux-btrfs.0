Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40928 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761989Ab2EQPUJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 11:20:09 -0400
Received: by weyu7 with SMTP id u7so1229060wey.19
        for <linux-btrfs@vger.kernel.org>; Thu, 17 May 2012 08:20:08 -0700 (PDT)
Date: Thu, 17 May 2012 18:20:04 +0300
From: Ilya Dryomov <idryomov@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: fix memory leak in btrfs_pause_balance()
Message-ID: <20120517152004.GC1934@zambezi.lan>
References: <4FB4E7FD.8050108@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB4E7FD.8050108@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 17, 2012 at 07:58:53PM +0800, Miao Xie wrote:
> We forget to free fs_info->balance_ctl in the btrfs_pause_balance()
> when umounting the fs.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index c536d52..fd7fe80 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2937,6 +2937,9 @@ int btrfs_pause_balance(struct btrfs_fs_info *fs_info)
>  		ret = -ENOTCONN;
>  	}
>  
> +	if (btrfs_fs_closing(fs_info) && fs_info->balance_ctl)
> +		unset_balance_control(fs_info);
> +
>  	mutex_unlock(&fs_info->balance_mutex);
>  	return ret;
>  }

It is kfree()'d in free_fs_info(), which should be called on unmount.
Am I missing something here ?

Thanks,

		Ilya
