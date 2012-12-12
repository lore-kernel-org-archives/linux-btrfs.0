Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39902 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753414Ab2LLDtz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 22:49:55 -0500
Message-ID: <50C7FEF9.6040003@cn.fujitsu.com>
Date: Wed, 12 Dec 2012 11:50:17 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Jeff Liu <jeff.liu@oracle.com>
CC: linux-btrfs@vger.kernel.org, anand.jain@oracle.com
Subject: Re: [RESEND PATCH V4 1/2] Btrfs: Add a new ioctl to get the label
 of a mounted filesystem
In-Reply-To: <50C7F889.5040103@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50C7F889.5040103@oracle.com>

On Wed, 12 Dec 2012 11:22:49 +0800, Jeff Liu wrote:
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> ---
>  fs/btrfs/ioctl.c |   14 ++++++++++++++
>  fs/btrfs/ioctl.h |    2 ++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 8fcf9a5..b0a5e17 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3699,6 +3699,18 @@ out:
>  	return ret;
>  }
>  
> +static int btrfs_ioctl_get_fslabel(struct btrfs_root *root, void __user *arg)
> +{
> +	const char *label = root->fs_info->super_copy->label;
> +	int ret;
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	ret = copy_to_user(arg, label, strlen(label));
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +
> +	return ret ? -EFAULT : 0;
> +}
> +
>  long btrfs_ioctl(struct file *file, unsigned int
>  		cmd, unsigned long arg)
>  {
> @@ -3797,6 +3809,8 @@ long btrfs_ioctl(struct file *file, unsigned int
>  		return btrfs_ioctl_qgroup_create(root, argp);
>  	case BTRFS_IOC_QGROUP_LIMIT:
>  		return btrfs_ioctl_qgroup_limit(root, argp);
> +	case BTRFS_IOC_GET_FSLABEL:
> +		return btrfs_ioctl_get_fslabel(root, argp);
>  	}
>  
>  	return -ENOTTY;
> diff --git a/fs/btrfs/ioctl.h b/fs/btrfs/ioctl.h
> index 731e287..98f896f 100644
> --- a/fs/btrfs/ioctl.h
> +++ b/fs/btrfs/ioctl.h
> @@ -453,4 +453,6 @@ struct btrfs_ioctl_send_args {
>  			       struct btrfs_ioctl_qgroup_limit_args)
>  #define BTRFS_IOC_GET_DEV_STATS _IOWR(BTRFS_IOCTL_MAGIC, 52, \
>  				      struct btrfs_ioctl_get_dev_stats)
> +#define BTRFS_IOC_GET_FSLABEL _IOR(BTRFS_IOCTL_MAGIC, 53, \
> +				   char[BTRFS_LABEL_SIZE])
>  #endif
> 

According to the project idea web,
	https://btrfs.wiki.kernel.org/index.php/Project_ideas#Development_notes.2C_please_read

number 53 has been used for the drive swapping commands, so I think we should
choose another one. Maybe 49 is good since the above web says number 50 has been
reserved for set/change label command.
