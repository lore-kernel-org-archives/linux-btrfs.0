Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:32852 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab2LTURu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Dec 2012 15:17:50 -0500
Message-ID: <50D372E6.1000902@inwind.it>
Date: Thu, 20 Dec 2012 21:19:50 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz
Subject: Re: [RFC PATCH v7 2/2] Btrfs: Add a new ioctl to set/change the label
 of a mounted file system
In-Reply-To: <50D2CF9A.6040704@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50D2CF9A.6040704@oracle.com>

On 12/20/2012 09:43 AM, Jeff Liu wrote:
> With the new ioctl(2) BTRFS_IOC_SET_FSLABEL, we can set/change the label of a mounted file system.
>  
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Goffredo Baroncelli <kreijack@inwind.it>
> Cc: David Sterba <dsterba@suse.cz>

Reviewed-by: Goffredo Baroncelli <kreijack@inwind.it>

> ---
>  fs/btrfs/ioctl.c |   39 +++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |    2 ++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 6a2488a..99aa812 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3712,6 +3712,43 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
>  	return ret ? -EFAULT : 0;
>  }
>  
> +static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct btrfs_super_block *super_block = root->fs_info->super_copy;
> +	struct btrfs_trans_handle *trans;
> +	char label[BTRFS_LABEL_SIZE];
> +	int ret;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (copy_from_user(label, arg, sizeof(label)))
> +		return -EFAULT;
> +
> +	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE)
> +		return -EINVAL;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	trans = btrfs_start_transaction(root, 1);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out_unlock;
> +	}
> +
> +	strcpy(super_block->label, label);
> +	ret = btrfs_end_transaction(trans, root);
> +
> +out_unlock:
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3812,6 +3849,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_limit(root, argp);
>  	case BTRFS_IOC_GET_FSLABEL:
>  		return btrfs_ioctl_get_fslabel(file, argp);
> +	case BTRFS_IOC_SET_FSLABEL:
> +		return btrfs_ioctl_set_fslabel(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 5b2cbef..2abe239 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -453,6 +453,8 @@ struct btrfs_ioctl_send_args {
>  			       struct btrfs_ioctl_qgroup_limit_args)
>  #define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
>  				   char[BTRFS_LABEL_SIZE])
> +#define BTRFS_IOC_SET_FSLABEL _IOW(BTRFS_IOCTL_MAGIC, 50, \
> +				   char[BTRFS_LABEL_SIZE])
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>  				      struct btrfs_ioctl_get_dev_stats)
>  #endif


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
