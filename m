Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:47240 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3FXRDT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Jun 2013 13:03:19 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 255889A0403
	for <linux-btrfs@vger.kernel.org>; Mon, 24 Jun 2013 11:03:19 -0600 (MDT)
Date: Mon, 24 Jun 2013 13:03:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/2 v3] btrfs: obtain used_bytes in BTRFS_IOC_FS_INFO
 ioctl
Message-ID: <20130624170316.GL4288@localhost.localdomain>
References: <1370876355-16584-3-git-send-email-anand.jain@oracle.com>
 <1371799948-14176-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1371799948-14176-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 21, 2013 at 03:32:28PM +0800, Anand Jain wrote:
> btrfs-progs has to read fs info from the kernel to
> read the latest info instead of reading it from the disks,
> which generally is a stale info after certain critical
> operation.
> 
> getting used_bytes parameter will help to fix
> 	btrfs filesystem show --kernel
> to show the current info of the fs
> 
> v2->v3:
> 	everything is changed dropped the plan to introduce
> 	the new ioctl, as of now filesystem show could 
> 	manage if we add the used_bytes parameter to the
> 	BTRFS_IOC_FS_INFO and
> 	Update the title from
> 	 add framework to read fs info and dev info from the kernel
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c           | 16 ++++++++++++++--
>  include/uapi/linux/btrfs.h |  3 ++-
>  2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 0e7bcc5..082c9fc 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -2384,7 +2384,10 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
>  	struct btrfs_ioctl_fs_info_args *fi_args;
>  	struct btrfs_device *device;
>  	struct btrfs_device *next;
> -	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
> +	struct btrfs_fs_info *info = root->fs_info;
> +	struct btrfs_fs_devices *fs_devices = info->fs_devices;
> +	struct btrfs_space_info *si;
> +	u64 used_bytes = 0;
>  	int ret = 0;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -2394,8 +2397,17 @@ static long btrfs_ioctl_fs_info(struct btrfs_root *root, void __user *arg)
>  	if (!fi_args)
>  		return -ENOMEM;
>  
> +	rcu_read_lock();
> +	list_for_each_entry_rcu(si, &info->space_info, list) {
> +		used_bytes += si->bytes_used + si->bytes_reserved
> +				+ si->bytes_pinned + si->bytes_readonly
> +				+ si->bytes_may_use;
> +	}
> +	rcu_read_unlock();
> +	fi_args->used_bytes = used_bytes;
> +

So what exactly are we using this number for?  ->bytes_may_used is going to
change all the damned time because of reservations and it could even make
used_bytes to appear to be larger than total_bytes because of overcommitting.
So why exactly do you want this value?  Also how are you going to deal with
older kernels where this isn't populated?  Thanks,

Josef
