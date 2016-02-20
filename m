Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44865 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1426664AbcBTKYq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 05:24:46 -0500
Subject: Re: [PATCH 1/2] btrfs: add GET_SUPPORTED_FEATURES to the control
 device ioctls
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <f85225cc3f232fda01c71c5c1afee0139a8ee5ef.1455801904.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C83EE8.7090305@oracle.com>
Date: Sat, 20 Feb 2016 18:24:40 +0800
MIME-Version: 1.0
In-Reply-To: <f85225cc3f232fda01c71c5c1afee0139a8ee5ef.1455801904.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/18/2016 09:25 PM, David Sterba wrote:
> The control device is accessible when no filesystem is mounted and we
> may want to query features supported by the module.

yes.

> This is already
> possible using the sysfs files, this ioctl is for parity and
> convenience.


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.


> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ctree.h | 1 +
>   fs/btrfs/ioctl.c | 3 +--
>   fs/btrfs/super.c | 4 ++++
>   3 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index bfe4a337fb4d..47bc50fd4f55 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -4089,6 +4089,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
>
>   /* ioctl.c */
>   long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> +int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg);
>   void btrfs_update_iflags(struct inode *inode);
>   void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
>   int btrfs_is_empty_uuid(u8 *uuid);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 952172ca7e45..f4c6ed5c5300 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5187,8 +5187,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
>   	  .compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_##suffix, \
>   	  .incompat_flags = BTRFS_FEATURE_INCOMPAT_##suffix }
>
> -static int btrfs_ioctl_get_supported_features(struct file *file,
> -					      void __user *arg)
> +int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg)
>   {
>   	static const struct btrfs_ioctl_feature_flags features[3] = {
>   		INIT_FEATURE_FLAGS(SUPP),
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d41e09fe8e38..dda6f64dfd73 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2163,6 +2163,10 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   			break;
>   		ret = !(fs_devices->num_devices == fs_devices->total_devices);
>   		break;
> +	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> +		ret = btrfs_ioctl_get_supported_features(NULL,
> +				(void __user*)arg);
> +		break;
>   	}
>
>   	kfree(vol);
>
