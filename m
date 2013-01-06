Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:57300 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab3AFScd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 13:32:33 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so8087424bkc.10
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 10:32:31 -0800 (PST)
Message-ID: <50E9C34E.1060100@gmail.com>
Date: Sun, 06 Jan 2013 19:32:46 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz
Subject: Re: [RFC PATCH v9 2/2] Btrfs: set/change the label of a mounted file
 system
References: <50E79468.7050407@oracle.com>
In-Reply-To: <50E79468.7050407@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Reviewed-by: Goffredo Baroncelli <kreijack@inwind.it>

On 01/05/2013 03:48 AM, Jeff Liu wrote:
> With this new ioctl(2) BTRFS_IOC_SET_FSLABEL, we can set/change the label of a mounted file system.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Miao Xie <miaox@cn.fujitsu.com>
> Reviewed-by: Goffredo Baroncelli <kreijack@inwind.it>
> Reviewed-by: David Sterba <dsterba@suse.cz>
> 
> ---
>  fs/btrfs/ioctl.c |   42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/btrfs/ioctl.h |    2 ++
>  2 files changed, 44 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index ef2f55a..8e676c3 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3718,6 +3718,46 @@ static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
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
> +	if (strnlen(label, BTRFS_LABEL_SIZE) == BTRFS_LABEL_SIZE) {
> +		pr_err("btrfs: unable to set label with more than %d bytes\n",
> +		       BTRFS_LABEL_SIZE - 1);
> +		return -EINVAL;
> +	}
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	trans = btrfs_start_transaction(root, 0);
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
> @@ -3818,6 +3858,8 @@ long btrfs_ioctl(struct file *file, unsigned int
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
