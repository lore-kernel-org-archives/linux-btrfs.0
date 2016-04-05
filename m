Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:28016 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbcDEH5L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 03:57:11 -0400
Subject: Re: [PATCH] Btrfs: fix missing s_id setting
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <201604050008.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57036FB8.5060409@oracle.com>
Date: Tue, 5 Apr 2016 15:56:40 +0800
MIME-Version: 1.0
In-Reply-To: <201604050008.AA00001@WIN-5MHF4RKU941.jp.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/05/2016 08:08 AM, Tsutomu Itoh wrote:
> When fs_devices->latest_bdev is deleted or is replaced, sb->s_id has
> not been updated.
> As a result, the deleted device name is displayed by btrfs_printk.
>
> [before fix]
>   # btrfs dev del /dev/sdc4 /mnt2
>   # btrfs dev add /dev/sdb6 /mnt2
>
>   [  217.458249] BTRFS info (device sdc4): found 1 extents
>   [  217.695798] BTRFS info (device sdc4): disk deleted /dev/sdc4
>   [  217.941284] BTRFS info (device sdc4): disk added /dev/sdb6
>
> [after fix]
>   # btrfs dev del /dev/sdc4 /mnt2
>   # btrfs dev add /dev/sdb6 /mnt2
>
>   [   83.835072] BTRFS info (device sdc4): found 1 extents
>   [   84.080617] BTRFS info (device sdc3): disk deleted /dev/sdc4
>   [   84.401951] BTRFS info (device sdc3): disk added /dev/sdb6


  [PATCH 05/13] Btrfs: fix fs logging for multi device

  any comments ?

  We would want to maintain the logging prefix as constant, so that
  troubleshooters with filters/scripts will find it helpful.

Thanks, Anand


> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
> ---
>   fs/btrfs/dev-replace.c |  5 ++++-
>   fs/btrfs/volumes.c     | 11 +++++++++--
>   2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index a1d6652..11c4198 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -560,8 +560,11 @@ static int btrfs_dev_replace_finishing(struct btrfs_fs_info *fs_info,
>   	tgt_device->commit_bytes_used = src_device->bytes_used;
>   	if (fs_info->sb->s_bdev == src_device->bdev)
>   		fs_info->sb->s_bdev = tgt_device->bdev;
> -	if (fs_info->fs_devices->latest_bdev == src_device->bdev)
> +	if (fs_info->fs_devices->latest_bdev == src_device->bdev) {
>   		fs_info->fs_devices->latest_bdev = tgt_device->bdev;
> +		snprintf(fs_info->sb->s_id, sizeof(fs_info->sb->s_id), "%pg",
> +			 tgt_device->bdev);
> +	}
>   	list_add(&tgt_device->dev_alloc_list, &fs_info->fs_devices->alloc_list);
>   	fs_info->fs_devices->rw_devices++;
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index e2b54d5..a471385 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1846,8 +1846,12 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path)
>   				 struct btrfs_device, dev_list);
>   	if (device->bdev == root->fs_info->sb->s_bdev)
>   		root->fs_info->sb->s_bdev = next_device->bdev;
> -	if (device->bdev == root->fs_info->fs_devices->latest_bdev)
> +	if (device->bdev == root->fs_info->fs_devices->latest_bdev) {
>   		root->fs_info->fs_devices->latest_bdev = next_device->bdev;
> +		snprintf(root->fs_info->sb->s_id,
> +			 sizeof(root->fs_info->sb->s_id), "%pg",
> +			 next_device->bdev);
> +	}
>
>   	if (device->bdev) {
>   		device->fs_devices->open_devices--;
> @@ -2034,8 +2038,11 @@ void btrfs_destroy_dev_replace_tgtdev(struct btrfs_fs_info *fs_info,
>   				 struct btrfs_device, dev_list);
>   	if (tgtdev->bdev == fs_info->sb->s_bdev)
>   		fs_info->sb->s_bdev = next_device->bdev;
> -	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev)
> +	if (tgtdev->bdev == fs_info->fs_devices->latest_bdev) {
>   		fs_info->fs_devices->latest_bdev = next_device->bdev;
> +		snprintf(fs_info->sb->s_id, sizeof(fs_info->sb->s_id), "%pg",
> +			 next_device->bdev);
> +	}
>   	list_del_rcu(&tgtdev->dev_list);
>
>   	call_rcu(&tgtdev->rcu, free_device);
>
