Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:41053 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753173AbcKHM3g (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 07:29:36 -0500
Subject: Re: [PATCH 02/13] btrfs: Do per-chunk check for mount time check
To: dsterba@suse.cz
References: <1462889372-5274-1-git-send-email-anand.jain@oracle.com>
 <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <4d888bd2-de58-1830-0ad8-7a3ef347af75@oracle.com>
Date: Tue, 8 Nov 2016 20:32:12 +0800
MIME-Version: 1.0
In-Reply-To: <1462889372-5274-4-git-send-email-anand.jain@oracle.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

This and its related patches 1/13..5/13 provides a good interim
workaround to the regression caused by the patch
----
commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
Author: Miao Xie <miaox@cn.fujitsu.com>
Date:   Thu Jul 24 11:37:14 2014 +0800

     Btrfs: don't consider the missing device when allocating new chunks
----
ref [1]

[1]
https://patchwork.kernel.org/patch/8965291/

Would want to know your opinion.

The final solution is complex, and is in the RFC [2] which isn't
integration ready yet.

[2]
https://patchwork.kernel.org/patch/8965301/

Thanks, Anand


On 05/10/16 22:09, Anand Jain wrote:
> From: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Now use the btrfs_check_degraded() to do mount time degraded check.
>
> With this patch, now we can mount with the following case:
>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>  # wipefs -a /dev/sdc
>  # mount /dev/sdb /mnt/btrfs -o degraded
>  As the single data chunk is only in sdb, so it's OK to mount as degraded,
>  as missing one device is OK for RAID1.
>
> But still fail with the following case as expected:
>  # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>  # wipefs -a /dev/sdb
>  # mount /dev/sdc /mnt/btrfs -o degraded
>  As the data chunk is only in sdb, so it's not OK to mount it as degraded.
>
> Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Reported-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> [Btrfs: use btrfs_error instead of btrfs_err during mount]
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/disk-io.c | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index d01f89d130e0..4f91a049fbca 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2885,6 +2885,16 @@ int open_ctree(struct super_block *sb,
>  		goto fail_tree_roots;
>  	}
>
> +	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
> +	if (ret < 0) {
> +		btrfs_err(fs_info, "degraded writable mount failed %d", ret);
> +		goto fail_tree_roots;
> +	} else if (ret > 0 && !btrfs_test_opt(chunk_root, DEGRADED)) {
> +		btrfs_warn(fs_info,
> +			"Some device missing, but still degraded mountable, please mount with -o degraded option");
> +		ret = -EACCES;
> +		goto fail_tree_roots;
> +	}
>  	/*
>  	 * keep the device that is marked to be the target device for the
>  	 * dev_replace procedure
> @@ -2988,14 +2998,6 @@ retry_root_backup:
>  	}
>  	fs_info->num_tolerated_disk_barrier_failures =
>  		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
> -	if (fs_info->fs_devices->missing_devices >
> -	     fs_info->num_tolerated_disk_barrier_failures &&
> -	    !(sb->s_flags & MS_RDONLY)) {
> -		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
> -			fs_info->fs_devices->missing_devices,
> -			fs_info->num_tolerated_disk_barrier_failures);
> -		goto fail_sysfs;
> -	}
>
>  	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>  					       "btrfs-cleaner");
>
