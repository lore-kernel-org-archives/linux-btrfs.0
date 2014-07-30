Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:24812 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754618AbaG3Hkg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 03:40:36 -0400
Message-ID: <53D8A1DA.2060703@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 15:42:18 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: replace seed device followed by unmount causes
 kernel WARNING
In-Reply-To: <1406291614-29544-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <1406291614-29544-1-git-send-email-anand.jain@oracle.com>

On Fri, 25 Jul 2014 20:33:34 +0800, Anand Jain wrote:
> After the seed device has been replaced the new target device
> is no more a seed device. So we need to bring that state in
> the fs_devices.
> 
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
>         WARN_ON(fs_devices->rw_devices);
> 
> per the btrfs-devlist tool (to dump fs_devices and
> btrfs_device from the kernel) the num_device, open_devices,
> rw_devices are still at 1 but the total_device is at 2,
> even after the seed device has been replaced in the above example.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/dev-replace.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index eea26e1..a144bb1 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -569,6 +569,19 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>  
>  	btrfs_rm_dev_replace_blocked(fs_info);
>  
> +	/*
> +	 * if we are replacing a seed device with a writable device
> +	 * then FS won't be a seeding FS any more.
> +	 */
> +	if (src_device->fs_devices->seeding && !src_device->writeable) {

First, why not move this code into btrfs_rm_dev_replace_srcdev()?

Then if the first condition is true, the second one(!src_device->writeable) must be true
because all the devices in the seed fs_device must be read-only. so only the first
check is enough.

> +		fs_info->fs_devices->rw_devices++;

If src is missing dev, we would increase it twice.

> +		fs_info->fs_devices->num_devices++;
> +		fs_info->fs_devices->open_devices++;
> +
> +		fs_info->fs_devices->seeding = 0;
> +		fs_info->fs_devices->seed = NULL;

In fact, we may have several seed fs_devices in one fs, and the seed fs_device
which includes src might not the first one, so assign seed to be NULL would break
the seed fs_device list.

Thanks
Miao

> +	}
> +
>  	btrfs_rm_dev_replace_srcdev(fs_info, src_device);
>  
>  	btrfs_rm_dev_replace_unblocked(fs_info);
> 

