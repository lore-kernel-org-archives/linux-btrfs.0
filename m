Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34275 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750874AbcFWO1r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 10:27:47 -0400
Subject: Re: [PATCH v3 2/2] btrfs: make sure device is synced before return
To: Anand Jain <anand.jain@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1465901726-15490-2-git-send-email-anand.jain@oracle.com>
 <1466686447-7780-1-git-send-email-anand.jain@oracle.com>
CC: <dsterba@suse.cz>, <holger@applied-asynchrony.com>,
        <xiaolong.ye@intel.com>
From: Chris Mason <clm@fb.com>
Message-ID: <dd4d6f70-46bf-0ce9-31f8-bc337b67fb42@fb.com>
Date: Thu, 23 Jun 2016 10:27:27 -0400
MIME-Version: 1.0
In-Reply-To: <1466686447-7780-1-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2016 08:54 AM, Anand Jain wrote:
> An inconsistent behavior due to stale reads from the
> disk was reported
>
>   mail-archive.com/linux-btrfs@vger.kernel.org/msg54188.html
>
> This patch will make sure devices are synced before
> return in the unmount thread.
>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  v2: Also to make sure bdev_closing is set it needs rcu_barrier(),
>      restored rcu_barrier().
>  v3: Removed the complicated timed-wait on blkdev_put code,
>      but make synced and invalidated before umount is returned.
>      So sorry that I have to change the title of this patch
>      as well (was: btrfs: wait for bdev put).
>
>  fs/btrfs/volumes.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 604daf315669..f741ade130a4 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -870,6 +870,11 @@ static void btrfs_close_one_device(struct btrfs_device *device)
>  	if (device->missing)
>  		fs_devices->missing_devices--;
>
> +	if (device->bdev && device->writeable) {
> +		sync_blockdev(device->bdev);
> +		invalidate_bdev(device->bdev);
> +	}
> +
>  	new_device = btrfs_alloc_device(NULL, &device->devid,
>  					device->uuid);
>  	BUG_ON(IS_ERR(new_device)); /* -ENOMEM */
>

This should do it,I'll check with the xfstest I was able to reliably get 
errors on.

Thanks!

-chris
