Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39551 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750778AbdKFBxY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Nov 2017 20:53:24 -0500
Subject: Re: [PATCH 05/11] btrfs: simplify exit paths in btrfs_init_new_device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1509471604.git.dsterba@suse.com>
 <01ee88e7c85d15d62a8bf1bf94300226238bcb79.1509471604.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <79cdcf30-1f61-1c1e-46b4-1139f6c80f73@oracle.com>
Date: Mon, 6 Nov 2017 09:53:30 +0800
MIME-Version: 1.0
In-Reply-To: <01ee88e7c85d15d62a8bf1bf94300226238bcb79.1509471604.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


looks good.

Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand

On 11/01/2017 01:44 AM, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/volumes.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f206e83d4f52..75aed8ec64bd 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2344,17 +2344,15 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   
>   	name = rcu_string_strdup(device_path, GFP_KERNEL);
>   	if (!name) {
> -		free_device(device);
>   		ret = -ENOMEM;
> -		goto error;
> +		goto error_free_device;
>   	}
>   	rcu_assign_pointer(device->name, name);
>   
>   	trans = btrfs_start_transaction(root, 0);
>   	if (IS_ERR(trans)) {
> -		free_device(device);
>   		ret = PTR_ERR(trans);
> -		goto error;
> +		goto error_free_device;
>   	}
>   
>   	q = bdev_get_queue(bdev);
> @@ -2494,6 +2492,7 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>   		sb->s_flags |= MS_RDONLY;
>   	if (trans)
>   		btrfs_end_transaction(trans);
> +error_free_device:
>   	free_device(device);
>   error:
>   	blkdev_put(bdev, FMODE_EXCL);
> 
