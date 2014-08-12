Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:16501 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752178AbaHLH1y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Aug 2014 03:27:54 -0400
Message-ID: <53E9C267.4020902@cn.fujitsu.com>
Date: Tue, 12 Aug 2014 15:29:43 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] btrfs: fix rw_devices miss match after seed replace
References: <1407750176-15853-1-git-send-email-anand.jain@oracle.com> <1407750176-15853-3-git-send-email-anand.jain@oracle.com>
In-Reply-To: <1407750176-15853-3-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 11 Aug 2014 17:42:55 +0800, Anand Jain wrote:
> reproducer:
>     reproducer:
>     mount /dev/sdb /btrfs
>     btrfs dev add /dev/sdc /btrfs
>     btrfs rep start -B /dev/sdb /dev/sdd /btrfs
>     umount /btrfs
> 
> WARNING: CPU: 0 PID: 3882 at fs/btrfs/volumes.c:892 __btrfs_close_devices+0x1c8/0x200 [btrfs]()
> 
> which is
> 
>         WARN_ON(fs_devices->rw_devices);
> 
>    The problem here is that we did not add one to the rw_devices when
>    we replace the seed device with a writable device.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index eea26e1..fb0a7fa 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -562,6 +562,8 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
>  		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
>  	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
> +	if (src_device->fs_devices->seeding)
> +		fs_info->fs_devices->rw_devices++;

As I said in the previous version of this patch, we might increase ->rw_devices twice if
the source device is a missing device in the seed filesystem. Once is here, the other is
in btrfs_rm_dev_replace_srcdev().

Thanks
Miao

>  
>  	/* replace the sysfs entry */
>  	btrfs_kobj_rm_device(fs_info, src_device);
> 

