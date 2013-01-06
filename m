Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60381 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab3AFSoZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Jan 2013 13:44:25 -0500
Received: by mail-bk0-f51.google.com with SMTP id ik5so7951228bkc.24
        for <linux-btrfs@vger.kernel.org>; Sun, 06 Jan 2013 10:44:24 -0800 (PST)
Message-ID: <50E9C617.7010303@gmail.com>
Date: Sun, 06 Jan 2013 19:44:39 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        dsterba@suse.cz
Subject: Re: [RFC PATCH v9 1/2] Btrfs: Add a new ioctl to get the label of
 a mounted file system
References: <50E79461.3090802@oracle.com>
In-Reply-To: <50E79461.3090802@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jeff,

On 01/05/2013 03:48 AM, Jeff Liu wrote:
> Add a new ioctl(2) BTRFS_IOC_GET_FSLABLE, so that we can get the label upon a mounted filesystem.
> 
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Cc: Goffredo Baroncelli <kreijack@inwind.it>
> Cc: David Sterba <dsterba@suse.cz>
> 
> ---
>  fs/btrfs/ioctl.c |   21 +++++++++++++++++++++
>  fs/btrfs/ioctl.h |    2 ++
>  2 files changed, 23 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8fcf9a5..ef2f55a 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3699,6 +3699,25 @@ out:
>  	return ret;
>  }
>  

May be that it was already discussed, and I am missing something, but if
we check the label length we should terminate the string with a zero in
case this is too long...

However this is a minor bug, please push this patch forward..


> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	const char *label = root->fs_info->super_copy->label;
> +	size_t len = strnlen(label, BTRFS_LABEL_SIZE);
> +	int ret;
+       int label_is_too_long = 0;
> +
> +	if (len == BTRFS_LABEL_SIZE) {
> +		pr_warn("btrfs: label is too long, return the first %zu bytes\n",
> +			--len);

+               label_is_too_long = 1;
> +	}
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	ret = copy_to_user(arg, label, len);
+	if (!ret && label_is_too_long)
+     		ret = copy_to_user(arg+BTRFS_LABEL_SIZE, "", 1);
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +
> +	return ret ? -EFAULT : 0;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3797,6 +3816,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_create(root, argp);
>  	case BTRFS_IOC_QGROUP_LIMIT:
>  		return btrfs_ioctl_qgroup_limit(root, argp);
> +	case BTRFS_IOC_GET_FSLABEL:
> +		return btrfs_ioctl_get_fslabel(file, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 731e287..5b2cbef 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -451,6 +451,8 @@ struct btrfs_ioctl_send_args {
>  			       struct btrfs_ioctl_qgroup_create_args)
>  #define BTRFS_IOC_QGROUP_LIMIT _IOR(BTRFS_IOCTL_MAGIC, 43, \
>  			       struct btrfs_ioctl_qgroup_limit_args)
> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 49, \
> +				   char[BTRFS_LABEL_SIZE])
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>  				      struct btrfs_ioctl_get_dev_stats)
>  #endif


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli (kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
