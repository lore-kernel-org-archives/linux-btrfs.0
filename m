Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49865 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab3HTSeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 14:34:08 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4921D7C0432
	for <linux-btrfs@vger.kernel.org>; Tue, 20 Aug 2013 12:34:08 -0600 (MDT)
Date: Tue, 20 Aug 2013 14:34:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Anand Jain <anand.jain@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: return btrfs error code for dev excl ops err
Message-ID: <20130820183405.GH3990@localhost.localdomain>
References: <1376979054-2883-1-git-send-email-anand.jain@oracle.com>
 <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1376979054-2883-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 20, 2013 at 02:10:54PM +0800, Anand Jain wrote:
> now threads can return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS
> as defined in btrfs.h for the dev excl operation error in
> the FS, which means with this kernel would stop logging
> (almost an user error) into the /var/log/messages
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
>  fs/btrfs/ioctl.c           |   12 ++++--------
>  include/uapi/linux/btrfs.h |    3 +--
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 107c5f4..89f346c 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1382,9 +1382,8 @@ static noinline int btrfs_ioctl_resize(struct file *file,
>  
>  	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
>  			1)) {
> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
>  		mnt_drop_write_file(file);
> -		return -EINVAL;
> +		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  	}
>  
>  	mutex_lock(&root->fs_info->volume_mutex);
> @@ -2346,8 +2345,7 @@ static long btrfs_ioctl_add_dev(struct btrfs_root *root, void __user *arg)
>  
>  	if (atomic_xchg(&root->fs_info->mutually_exclusive_operation_running,
>  			1)) {
> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
> -		return -EINVAL;
> +		return BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  	}
>  
>  	mutex_lock(&root->fs_info->volume_mutex);
> @@ -3638,8 +3636,7 @@ static long btrfs_ioctl_dev_replace(struct btrfs_root *root, void __user *arg)
>  		if (atomic_xchg(
>  			&root->fs_info->mutually_exclusive_operation_running,
>  			1)) {
> -			pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
> -			ret = -EINPROGRESS;
> +			ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  		} else {
>  			ret = btrfs_dev_replace_start(root, p);
>  			atomic_set(
> @@ -3883,8 +3880,7 @@ again:
>  	} else {
>  		/* this is (1) */
>  		mutex_unlock(&fs_info->balance_mutex);
> -		pr_info("btrfs: dev add/delete/balance/replace/resize operation in progress\n");
> -		ret = -EINVAL;
> +		ret = BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS;
>  		goto out;
>  	}
>  
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index 90d7bd9..182305f 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -505,8 +505,7 @@ static inline char *btrfs_err_str(enum btrfs_err_code err_code)
>  		case BTRFS_ERROR_DEV_ONLY_WRITABLE:
>  			return "unable to remove the only writeable device";
>  		case BTRFS_ERROR_DEV_EXCL_RUN_IN_PROGRESS:
> -			return "add/delete/balance/replace/resize operation "\
> -				"in progress";
> +			return "add/delete/balance/replace/resize operation in progress";
>  		default:
>  			return NULL;

This is an unnecessary change.  Thanks,

Josef
