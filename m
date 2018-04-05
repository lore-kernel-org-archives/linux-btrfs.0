Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:35226 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbeDEJj7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Apr 2018 05:39:59 -0400
Subject: Re: [PATCH 05/16] btrfs: move volume_mutex to callers of
 btrfs_rm_device
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <004920f0f641ebffa974129fe8f4b0d6a9ee9f34.1522780026.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <7dc04550-5325-76ef-0636-87eb84831359@oracle.com>
Date: Thu, 5 Apr 2018 17:41:57 +0800
MIME-Version: 1.0
In-Reply-To: <004920f0f641ebffa974129fe8f4b0d6a9ee9f34.1522780026.git.dsterba@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> @@ -2716,6 +2718,7 @@ static long btrfs_ioctl_rm_dev(struct file *file, void __user *arg)
>   		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>   		goto out_drop_write;
>   	}
> +	mutex_lock(&fs_info->volume_mutex);
>   
>   	vol_args = memdup_user(arg, sizeof(*vol_args));
>   	if (IS_ERR(vol_args)) { > @@ -2730,6 +2733,7 @@ static long btrfs_ioctl_rm_dev(struct file 
*file, void __user *arg)
>   		btrfs_info(fs_info, "disk deleted %s", vol_args->name);
>   	kfree(vol_args);
>   out:
> +	mutex_unlock(&fs_info->volume_mutex);
>   	clear_bit(BTRFS_FS_EXCL_OP, &fs_info->flags);
>   out_drop_write:
>   	mnt_drop_write_file(file);

  Why not memdup_user() be outside of volume_mutex?
  But not a big deal either.


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks, Anand
