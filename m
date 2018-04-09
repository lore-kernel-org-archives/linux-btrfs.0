Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:44406 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeDIIhG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 04:37:06 -0400
Subject: Re: [PATCH 10/16] btrfs: remove wrong use of volume_mutex from
 btrfs_dev_replace_start
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <14a1aaa2-f079-c3f0-14db-6376f90ee635@oracle.com>
Date: Mon, 9 Apr 2018 16:39:03 +0800
MIME-Version: 1.0
In-Reply-To: <3506f0f2a65a88ef2a5bb1cfff0617503621ba19.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/04/2018 02:34 AM, David Sterba wrote:
> The volume mutex does not protect against anything in this case, the
> comment about scrub is right but not related to locking and looks
> confusing. The comment in btrfs_find_device_missing_or_by_path is wrong
> and confusing too.
> 
> The device_list_mutex is not held here to protect device lookup, but in
> this case device replace cannot run in parallel with device removal (due
> to exclusive op protection), so we don't need further locking here.

Agreed, usage of device_list_mutex and volume_mutex is kind of redundant.

There are unfinished features in btrfs volume, such as device offline 
while it was mounted (patches in the ML).

It's better to replace volume_mutex with device_list_mutex instead of 
removing it, as we might need it in the context mentioned above.

Or it's not a good idea to clean up until all the features are in place 
otherwise we end up adding the locks again at some point.

Thanks, Anand


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/dev-replace.c | 7 +------
>   fs/btrfs/volumes.c     | 4 ----
>   2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 346bd460f8e7..ba011af9b0d2 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -426,18 +426,13 @@ int btrfs_dev_replace_start(struct btrfs_fs_info *fs_info,
>   	struct btrfs_device *tgt_device = NULL;
>   	struct btrfs_device *src_device = NULL;
>   
> -	/* the disk copy procedure reuses the scrub code */
> -	mutex_lock(&fs_info->volume_mutex);
>   	ret = btrfs_find_device_by_devspec(fs_info, srcdevid,
>   					    srcdev_name, &src_device);
> -	if (ret) {
> -		mutex_unlock(&fs_info->volume_mutex);
> +	if (ret)
>   		return ret;
> -	}
>   
>   	ret = btrfs_init_dev_replace_tgtdev(fs_info, tgtdev_name,
>   					    src_device, &tgt_device);
> -	mutex_unlock(&fs_info->volume_mutex);
>   	if (ret)
>   		return ret;
>   
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index b073ab4c3c70..0ae29cd69363 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2198,10 +2198,6 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_fs_info *fs_info,
>   		struct btrfs_device *tmp;
>   
>   		devices = &fs_info->fs_devices->devices;
> -		/*
> -		 * It is safe to read the devices since the volume_mutex
> -		 * is held by the caller.
> -		 */
>   		list_for_each_entry(tmp, devices, dev_list) {
>   			if (test_bit(BTRFS_DEV_STATE_IN_FS_METADATA,
>   					&tmp->dev_state) && !tmp->bdev) {
> 
