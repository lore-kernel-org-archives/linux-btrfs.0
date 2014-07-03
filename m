Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:65009 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750884AbaGCLHU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 07:07:20 -0400
Message-ID: <53B539CE.7070201@cn.fujitsu.com>
Date: Thu, 3 Jul 2014 19:09:02 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: <linux-btrfs@vger.kernel.org>
CC: Anand Jain <Anand.Jain@oracle.com>
Subject: Re: [PATCH] Btrfs: fix wrong uevent target
References: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1404291834-11113-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

CC Anand Jain

Sorry, please ignore this patch.
Anand wrote the same patch several days ago, so this bug fix belongs to Anand
though he NACKed his patch at that time.

Thanks
Miao

On Wed, 2 Jul 2014 17:03:54 +0800, Miao Xie wrote:
> block_device's bd_disk points to the disk, not the object which block_device
> is actually corresponding to(the whole disk or a partition), so we would send
> uevent to the wrong target. Fix it.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/volumes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 95828b0..e8b9214 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -123,7 +123,7 @@ static void btrfs_kobject_uevent(struct block_device *bdev,
>  {
>  	int ret;
>  
> -	ret = kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, action);
> +	ret = kobject_uevent(&part_to_dev(bdev->bd_part)->kobj, action);
>  	if (ret)
>  		pr_warn("BTRFS: Sending event '%d' to kobject: '%s' (%p): failed\n",
>  			action,
> 

