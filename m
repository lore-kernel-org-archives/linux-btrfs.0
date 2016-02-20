Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48797 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1427677AbcBTK0b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Feb 2016 05:26:31 -0500
Subject: Re: [PATCH 2/2] btrfs: drop unused argument in
 btrfs_ioctl_get_supported_features
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <f85225cc3f232fda01c71c5c1afee0139a8ee5ef.1455801904.git.dsterba@suse.com>
 <e17a367bc645aff089e9f677251a7e3dd889bc6d.1455801904.git.dsterba@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56C83F15.7020402@oracle.com>
Date: Sat, 20 Feb 2016 18:25:25 +0800
MIME-Version: 1.0
In-Reply-To: <e17a367bc645aff089e9f677251a7e3dd889bc6d.1455801904.git.dsterba@suse.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Reviewed-by: Anand Jain <anand.jain@oracle.com>

Thanks.

On 02/18/2016 09:25 PM, David Sterba wrote:
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
>   fs/btrfs/ctree.h | 2 +-
>   fs/btrfs/ioctl.c | 4 ++--
>   fs/btrfs/super.c | 3 +--
>   3 files changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 47bc50fd4f55..82ce847318ae 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -4089,7 +4089,7 @@ void btrfs_test_inode_set_ops(struct inode *inode);
>
>   /* ioctl.c */
>   long btrfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> -int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg);
> +int btrfs_ioctl_get_supported_features(void __user *arg);
>   void btrfs_update_iflags(struct inode *inode);
>   void btrfs_inherit_iflags(struct inode *inode, struct inode *dir);
>   int btrfs_is_empty_uuid(u8 *uuid);
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index f4c6ed5c5300..dcda7ea1e928 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -5187,7 +5187,7 @@ static int btrfs_ioctl_set_fslabel(struct file *file, void __user *arg)
>   	  .compat_ro_flags = BTRFS_FEATURE_COMPAT_RO_##suffix, \
>   	  .incompat_flags = BTRFS_FEATURE_INCOMPAT_##suffix }
>
> -int btrfs_ioctl_get_supported_features(struct file *file, void __user *arg)
> +int btrfs_ioctl_get_supported_features(void __user *arg)
>   {
>   	static const struct btrfs_ioctl_feature_flags features[3] = {
>   		INIT_FEATURE_FLAGS(SUPP),
> @@ -5466,7 +5466,7 @@ long btrfs_ioctl(struct file *file, unsigned int
>   	case BTRFS_IOC_SET_FSLABEL:
>   		return btrfs_ioctl_set_fslabel(file, argp);
>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> -		return btrfs_ioctl_get_supported_features(file, argp);
> +		return btrfs_ioctl_get_supported_features(argp);
>   	case BTRFS_IOC_GET_FEATURES:
>   		return btrfs_ioctl_get_features(file, argp);
>   	case BTRFS_IOC_SET_FEATURES:
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index dda6f64dfd73..737e6a85c71e 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -2164,8 +2164,7 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>   		ret = !(fs_devices->num_devices == fs_devices->total_devices);
>   		break;
>   	case BTRFS_IOC_GET_SUPPORTED_FEATURES:
> -		ret = btrfs_ioctl_get_supported_features(NULL,
> -				(void __user*)arg);
> +		ret = btrfs_ioctl_get_supported_features((void __user*)arg);
>   		break;
>   	}
>
>
