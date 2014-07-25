Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48292 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757022AbaGYHxS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Jul 2014 03:53:18 -0400
Message-ID: <53D20DBC.5030108@oracle.com>
Date: Fri, 25 Jul 2014 15:56:44 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] Btrfs: Fix the problem that the replace destroys
 the seed filesystem
References: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
In-Reply-To: <1406173035-29478-1-git-send-email-miaox@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


  Thanks for nailing down most of the seed related bugs, scratching
  off few from my list.


On 07/24/2014 11:37 AM, Miao Xie wrote:
> The seed filesystem was destroyed by the device replace, the reproduce
> method is:
>   # mkfs.btrfs -f <dev0>
>   # btrfstune -S 1 <dev0>
>   # mount <dev0> <mnt>
>   # btrfs device add <dev1> <mnt>
>   # umount <mnt>
>   # mount <dev1> <mnt>
>   # btrfs replace start -f <dev0> <dev2> <mnt>
>   # umount <mnt>
>   # mount <dev0> <mnt>
>
> It is because we erase the super block on the seed device. It is wrong,
> we should not change anything on the seed device.

nice fix.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>   fs/btrfs/volumes.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2776070f..19188df 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1853,8 +1853,12 @@ void btrfs_rm_dev_replace_srcdev(struct btrfs_fs_info *fs_info,
>   	if (srcdev->bdev) {
>   		fs_info->fs_devices->open_devices--;
>
> -		/* zero out the old super */
> -		btrfs_scratch_superblock(srcdev);
> +		/*
> +		 * zero out the old super if it is not writable
> +		 * (e.g. seed device)
> +		 */
> +		if (srcdev->writeable)
> +			btrfs_scratch_superblock(srcdev);
>   	}
>
>   	call_rcu(&srcdev->rcu, free_device);
>
