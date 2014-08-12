Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2745 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbaHLH2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:28:33 -0400
Message-ID: <53E9C28E.8030002@cn.fujitsu.com>
Date: Tue, 12 Aug 2014 15:30:22 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/4] btrfs: preparatory to make btrfs_rm_dev_replace_srcdev()
 seed aware
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 Aug 2014 17:42:53 +0800, Anand Jain wrote:
> There is no logical change in this patch, just a preparatory patch,
> so that changes can be easily reasoned.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5f634b6..5fd0132 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1960,19 +1960,23 @@ error_undo:
>  void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>  				 struct btrfs_device *srcdev)
>  {
> +	struct btrfs_fs_devices *fs_devices;
> +
>  	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
>  
> +	fs_devices = fs_info->fs_devices;
> +
>  	list_del_rcu(&srcdev->dev_list);
>  	list_del_rcu(&srcdev->dev_alloc_list);
> -	fs_info->fs_devices->num_devices--;
> +	fs_devices->num_devices--;
>  	if (srcdev->missing) {
> -		fs_info->fs_devices->missing_devices--;
> -		fs_info->fs_devices->rw_devices++;
> +		fs_devices->missing_devices--;
> +		fs_devices->rw_devices++;
>  	}
>  	if (srcdev->can_discard)
> -		fs_info->fs_devices->num_can_discard--;
> +		fs_devices->num_can_discard--;
>  	if (srcdev->bdev) {
> -		fs_info->fs_devices->open_devices--;
> +		fs_devices->open_devices--;
>  
>  		/*
>  		 * zero out the old super if it is not writable
> 

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
