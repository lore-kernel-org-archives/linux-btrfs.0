Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27583 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbIYHHV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 03:07:21 -0400
Message-ID: <5604F249.3020204@oracle.com>
Date: Fri, 25 Sep 2015 15:05:45 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: Do per-chunk check for mount time check
References: <1442801443-5132-1-git-send-email-quwenruo@cn.fujitsu.com> <1442801443-5132-3-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442801443-5132-3-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/21/2015 10:10 AM, Qu Wenruo wrote:
> Now use the btrfs_check_degraded() to do mount time degraded check.
>
> With this patch, now we can mount with the following case:
>   # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>   # wipefs -a /dev/sdc
>   # mount /dev/sdb /mnt/btrfs -o degraded
>   As the single data chunk is only in sdb, so it's OK to mount as
>   degraded, as missing one device is OK for RAID1.
>
> But still fail with the following case as expected:
>   # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>   # wipefs -a /dev/sdb
>   # mount /dev/sdc /mnt/btrfs -o degraded
>   As the data chunk is only in sdb, so it's not OK to mount it as
>   degraded.
>
> Reported-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Reported-by: Anand Jain <anand.jain@oracle.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0b658d0..d64299f 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2858,6 +2858,16 @@ int open_ctree(struct super_block *sb,
>   		goto fail_tree_roots;
>   	}
>
> +	ret = btrfs_check_degradable(fs_info, fs_info->sb->s_flags);
> +	if (ret < 0) {
> +		btrfs_error(fs_info, ret, "degraded writable mount failed");

> +		goto fail_tree_roots;

same here too. if at all we are failing the mount. there is no point in 
doing the error handling (btrfs_error()) instead just error reporting is 
better (btrfs_err()).

Thanks, Anand



> +	} else if (ret > 0 && !btrfs_test_opt(chunk_root, DEGRADED)) {
> +		btrfs_warn(fs_info,
> +			"Some device missing, but still degraded mountable, please mount with -o degraded option");
> +		ret = -EACCES;
> +		goto fail_tree_roots;
> +	}
>   	/*
>   	 * keep the device that is marked to be the target device for the
>   	 * dev_replace procedure
> @@ -2947,14 +2957,6 @@ retry_root_backup:
>   	}
>   	fs_info->num_tolerated_disk_barrier_failures =
>   		btrfs_calc_num_tolerated_disk_barrier_failures(fs_info);
> -	if (fs_info->fs_devices->missing_devices >
> -	     fs_info->num_tolerated_disk_barrier_failures &&
> -	    !(sb->s_flags & MS_RDONLY)) {
> -		pr_warn("BTRFS: missing devices(%llu) exceeds the limit(%d), writeable mount is not allowed\n",
> -			fs_info->fs_devices->missing_devices,
> -			fs_info->num_tolerated_disk_barrier_failures);
> -		goto fail_sysfs;
> -	}
>
>   	fs_info->cleaner_kthread = kthread_run(cleaner_kthread, tree_root,
>   					       "btrfs-cleaner");
>
