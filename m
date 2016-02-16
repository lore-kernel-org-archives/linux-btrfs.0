Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21931 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610AbcBPJOq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Feb 2016 04:14:46 -0500
Subject: Re: [PATCH 14/15] btrfs: rename btrfs_find_device_by_user_input
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1455556900.git.dsterba@suse.com>
 <fc1748ace148802b9a122ae6222aea742f7cb9ea.1455556900.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C2E87B.9000506@oracle.com>
Date: Tue, 16 Feb 2016 17:14:35 +0800
MIME-Version: 1.0
In-Reply-To: <fc1748ace148802b9a122ae6222aea742f7cb9ea.1455556900.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand


On 02/16/2016 01:34 AM, David Sterba wrote:
> For clarity how we are going to find the device, let's call it a device
> specifier, devspec for short. Also rename the arguments that are a
> leftover from previous function purpose.
>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/dev-replace.c |  2 +-
>   fs/btrfs/volumes.c     | 17 ++++++++++-------
>   fs/btrfs/volumes.h     |  4 ++--
>   3 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
> index 3e2616d151d9..1731f92b6247 100644
> --- a/fs/btrfs/dev-replace.c
> +++ b/fs/btrfs/dev-replace.c
> @@ -322,7 +322,7 @@ int btrfs_dev_replace_start(struct btrfs_root *root,
>
>   	/* the disk copy procedure reuses the scrub code */
>   	mutex_lock(&fs_info->volume_mutex);
> -	ret = btrfs_find_device_by_user_input(root, args->start.srcdevid,
> +	ret = btrfs_find_device_by_devspec(root, args->start.srcdevid,
>   					    args->start.srcdev_name,
>   					    &src_device);
>   	if (ret) {
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 8fee24f92574..05d9bc0cdd49 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -1779,7 +1779,7 @@ int btrfs_rm_device(struct btrfs_root *root, char *device_path, u64 devid)
>   	if (ret)
>   		goto out;
>
> -	ret = btrfs_find_device_by_user_input(root, devid, device_path,
> +	ret = btrfs_find_device_by_devspec(root, devid, device_path,
>   				&device);
>   	if (ret)
>   		goto out;
> @@ -2065,23 +2065,26 @@ int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
>   	}
>   }
>
> -int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
> -					 char *srcdev_name,
> +/*
> + * Lookup a device given by device id, or the path if the id is 0.
> + */
> +int btrfs_find_device_by_devspec(struct btrfs_root *root, u64 devid,
> +					 char *devpath,
>   					 struct btrfs_device **device)
>   {
>   	int ret;
>
> -	if (srcdevid) {
> +	if (devid) {
>   		ret = 0;
> -		*device = btrfs_find_device(root->fs_info, srcdevid, NULL,
> +		*device = btrfs_find_device(root->fs_info, devid, NULL,
>   					    NULL);
>   		if (!*device)
>   			ret = -ENOENT;
>   	} else {
> -		if (!srcdev_name || !srcdev_name[0])
> +		if (!devpath || !devpath[0])
>   			return -EINVAL;
>
> -		ret = btrfs_find_device_missing_or_by_path(root, srcdev_name,
> +		ret = btrfs_find_device_missing_or_by_path(root, devpath,
>   							   device);
>   	}
>   	return ret;
> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
> index a13a538cb01e..febdb7bc9370 100644
> --- a/fs/btrfs/volumes.h
> +++ b/fs/btrfs/volumes.h
> @@ -448,8 +448,8 @@ void btrfs_close_extra_devices(struct btrfs_fs_devices *fs_devices, int step);
>   int btrfs_find_device_missing_or_by_path(struct btrfs_root *root,
>   					 char *device_path,
>   					 struct btrfs_device **device);
> -int btrfs_find_device_by_user_input(struct btrfs_root *root, u64 srcdevid,
> -					 char *srcdev_name,
> +int btrfs_find_device_by_devspec(struct btrfs_root *root, u64 devid,
> +					 char *devpath,
>   					 struct btrfs_device **device);
>   struct btrfs_device *btrfs_alloc_device(struct btrfs_fs_info *fs_info,
>   					const u64 *devid,
>
