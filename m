Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38749 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbbIQJop (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Sep 2015 05:44:45 -0400
Message-ID: <55FA8B31.9080604@oracle.com>
Date: Thu, 17 Sep 2015 17:43:13 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: Remove unneeded missing device number check
References: <1442375031-18212-1-git-send-email-quwenruo@cn.fujitsu.com> <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com>
In-Reply-To: <1442375031-18212-2-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/16/2015 11:43 AM, Qu Wenruo wrote:
> As we do per-chunk missing device number check at read_one_chunk() time,
> it's not needed to do global missing device number check.
>
> Just remove it.

However the missing device count, what we have during the remount is not 
fine grained per chunk.
-----------
btrfs_remount
::
                  if (fs_info->fs_devices->missing_devices >
                      fs_info->num_tolerated_disk_barrier_failures &&
                     !(*flags & MS_RDONLY ||
                         btrfs_test_opt(root, DEGRADED))) {
                         btrfs_warn(fs_info,
                                 "too many missing devices, writeable 
remount is not allowed");
                         ret = -EACCES;
                         goto restore;
                 }
---------

Thanks, Anand


> Now btrfs can handle the following case:
>   # mkfs.btrfs -f -m raid1 -d single /dev/sdb /dev/sdc
>
>   Data chunk will be located in sdb, so we should be safe to wipe sdc
>   # wipefs -a /dev/sdc
>
>   # mount /dev/sdb /mnt/btrfs -o degraded
>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
>   fs/btrfs/disk-io.c | 8 --------
>   1 file changed, 8 deletions(-)
>
> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
> index 0b658d0..ac640ea 100644
> --- a/fs/btrfs/disk-io.c
> +++ b/fs/btrfs/disk-io.c
> @@ -2947,14 +2947,6 @@ retry_root_backup:
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
