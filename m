Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53720 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753306AbeGCF6T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jul 2018 01:58:19 -0400
Subject: Re: [PATCH 2/2] btrfs: drop devices declare in
 btrfs_init_new_device()
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20180703051451.3673-1-anand.jain@oracle.com>
 <20180703051451.3673-2-anand.jain@oracle.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <92f4200f-10fb-971f-e369-26f8a837f82d@suse.com>
Date: Tue, 3 Jul 2018 08:58:16 +0300
MIME-Version: 1.0
In-Reply-To: <20180703051451.3673-2-anand.jain@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  3.07.2018 08:14, Anand Jain wrote:
> There is only one usage of the declared devices variable, instead
> use its value directly.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: Nikolay Borisov <nborisov@suse.com>

> ---
>  fs/btrfs/volumes.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index f7fa0ea26e9c..124bd8728c37 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -2406,7 +2406,6 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_device *device;
>  	struct block_device *bdev;
> -	struct list_head *devices;
>  	struct super_block *sb = fs_info->sb;
>  	struct rcu_string *name;
>  	struct btrfs_fs_devices *fs_devices = fs_info->fs_devices;
> @@ -2431,10 +2430,8 @@ int btrfs_init_new_device(struct btrfs_fs_info *fs_info, const char *device_path
>  
>  	filemap_write_and_wait(bdev->bd_inode->i_mapping);
>  
> -	devices = &fs_devices->devices;
> -
>  	mutex_lock(&fs_devices->device_list_mutex);
> -	list_for_each_entry(device, devices, dev_list) {
> +	list_for_each_entry(device, &fs_devices->devices, dev_list) {
>  		if (device->bdev == bdev) {
>  			ret = -EEXIST;
>  			mutex_unlock(
> 
