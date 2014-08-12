Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25037 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbaHLHZL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:25:11 -0400
Message-ID: <53E9C1C5.9020005@cn.fujitsu.com>
Date: Tue, 12 Aug 2014 15:27:01 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/4] btrfs: replace seed device followed by unmount causes
 kernel WARNING
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com> <1407750176-15853-2-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-2-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 Aug 2014 17:42:54 +0800, Anand Jain wrote:
> reproducer:
> mount /dev/sdb /btrfs
> btrfs dev add /dev/sdc /btrfs
> btrfs rep start -B /dev/sdb /dev/sdd /btrfs
> umount /btrfs
> 
> WARNING: CPU: 0 PID: 12661 at fs/btrfs/volumes.c:891 __btrfs_close_devices+0x1b0/0x200 [btrfs]()
> ::
> 
> __btrfs_close_devices()
> ::
>         WARN_ON(fs_devices->open_devices);
> 
> After the seed device has been replaced the new target device
> is no more a seed device. So we need to update the device
> numbers in the fs_devices as pointed by the fs_info.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/volumes.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 5fd0132..f098ae7 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1964,7 +1964,13 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>  
>  	WARN_ON(!mutex_is_locked(&fs_info->fs_devices->device_list_mutex));
>  
> -	fs_devices = fs_info->fs_devices;
> +	/*
> +	 * in case of fs with no seed, srcdev->fs_devices will point
> +	 * to fs_devices of fs_info. However when the dev being replaced is
> +	 * a seed dev it will point to the seed's local fs_devices. In short
> +	 * srcdev will have its correct fs_devices in both the cases.
> +	 */
> +	fs_devices = srcdev->fs_devices;

Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>

>  
>  	list_del_rcu(&srcdev->dev_list);
>  	list_del_rcu(&srcdev->dev_alloc_list);
> 

