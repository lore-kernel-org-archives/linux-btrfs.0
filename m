Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:65097 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab2LLEO4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 23:14:56 -0500
Message-ID: <50C804D9.5060700@cn.fujitsu.com>
Date: Wed, 12 Dec 2012 12:15:21 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RESEND PATCH V4 2/2] Btrfs: Add a new ioctl to change the label
 of a mounted filesystem
In-Reply-To: <50C7F894.9000709@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50C7F894.9000709@oracle.com>

On wed, 12 Dec 2012 11:23:00 +0800, Jeff Liu wrote:
> Add a new ioctl BTRFS_FS_SETLABEL to change the label of a mounted filesystem.
> 
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> ---
>  fs/btrfs/ioctl.c |   34 ++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |    2 ++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index b0a5e17..ebbf634 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3711,6 +3711,38 @@ static int btrfs_ioctl_get_fslabel(struct btrfs_root *root, void __user *arg)
>  	return ret ? -EFAULT : 0;
>  }
>  
> +static int btrfs_ioctl_set_fslabel(struct btrfs_root *root, void __user *arg)
> +{
> +	struct btrfs_super_block *super_block = root->fs_info->super_copy;
> +	struct btrfs_trans_handle *trans;
> +	char label[BTRFS_LABEL_SIZE];
> +	int ret = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;

Since this label is a global parameter, we needn't check the root
is R/O or not.

The check we need is the write access of the fs, so we need call
	mnt_want_write_file()

> +
> +	if (copy_from_user(label, arg, sizeof(label)))
> +		return -EFAULT;
> +
> +	label[BTRFS_LABEL_SIZE - 1] = '\0';

I don't think setting the last byte to '\0' is a good way, because the user would be
very strange that the new label is truncated, but the program told him that it was done
successfully.

> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out_unlock;
> +	}
> +	strcpy(super_block->label, label);
> +	btrfs_end_transaction(trans, root);
> +
> +out_unlock:
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3811,6 +3843,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_limit(root, argp);
>  	case BTRFS_IOC_GET_FSLABEL:
>  		return btrfs_ioctl_get_fslabel(root, argp);
> +	case BTRFS_IOC_SET_FSLABEL:
> +		return btrfs_ioctl_set_fslabel(root, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 98f896f..cc4e657 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -455,4 +455,6 @@ struct btrfs_ioctl_send_args {
>  				      struct btrfs_ioctl_get_dev_stats)
>  #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
>  				   char[BTRFS_LABEL_SIZE])
> +#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 54, \
> +				   char[BTRFS_LABEL_SIZE])
>  #endif

number 50 has been reserved for this feature.

Thanks
Miao

