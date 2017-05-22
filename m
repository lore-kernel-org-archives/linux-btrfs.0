Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:49581 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755679AbdEVBvZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 21:51:25 -0400
Subject: Re: [PATCH 8/8] btrfs: Add new ioctl uapis for qgroup creation /
 removal
To: Sargun Dhillon <sargun@sargun.me>, <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <4ddad9de-6b0c-3587-6e27-c3513a455d60@cn.fujitsu.com>
Date: Mon, 22 May 2017 09:51:13 +0800
MIME-Version: 1.0
In-Reply-To: <20170520084005.GA4262@ircssh-2.c.rugged-nimbus-611.internal>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520084005.GA4262@ircssh-2.c.rugged-nimbus-611.internal>



At 05/20/2017 04:40 PM, Sargun Dhillon wrote:
> This patch ties together the work in the previous patches, to introduce
> semantics around the qgroup creation / removal API that are a bit more
> intuitive that the current one. It also creates two new args structures
> which have reserved space for future expansion, as opposed to single
> datastructure for both creation and removal.
> 
> The associated semantics are as follows:
> 1) You cannot create a level 0 qgroup for a subvol which does not exist
>     unless you pass in an override flag.
> 2) You cannot delete a level 0 qgroup which refers to a subvolume, which
>     currently exists unless you pass in an override flag.
> 
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> ---
>   fs/btrfs/ioctl.c           | 98 ++++++++++++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/btrfs.h | 23 +++++++++++
>   2 files changed, 121 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 5e20643..7bf34b7 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -4936,6 +4936,100 @@ static long btrfs_ioctl_qgroup_assign(struct file *file, void __user *arg)
>   	return ret;
>   }
>   
> +static long btrfs_ioctl_qgroup_create_v2(struct file *file, void __user *arg)
> +{
> +	struct btrfs_ioctl_qgroup_create_args_v2 create_args;
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_fs_info *fs_info;
> +	struct btrfs_root *root;
> +	int check_subvol_exists;
> +	int ret, err;
> +
> +	fs_info = btrfs_sb(inode->i_sb);
> +	root = BTRFS_I(inode)->root;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = copy_from_user(&create_args, arg, sizeof(create_args));
> +	if (ret)
> +		return ret;
> +
> +	if (!create_args.qgroupid)
> +		return -EINVAL;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	trans = btrfs_join_transaction(root);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
> +
> +	check_subvol_exists = !(create_args.flags &
> +				BTRFS_QGROUP_CREATE_IGNORE_UNUSED);
> +	ret = btrfs_create_qgroup(trans, fs_info, create_args.qgroupid,
> +				  check_subvol_exists);
> +
> +	err = btrfs_end_transaction(trans);
> +	if (err && !ret)
> +		ret = err;
> +
> +out:
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
> +
> +static long btrfs_ioctl_qgroup_remove_v2(struct file *file, void __user *arg)
> +{
> +	struct btrfs_ioctl_qgroup_remove_args_v2 remove_args;
> +	struct inode *inode = file_inode(file);
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_fs_info *fs_info;
> +	struct btrfs_root *root;
> +	int check_in_use;
> +	int ret, err;
> +
> +	fs_info = btrfs_sb(inode->i_sb);
> +	root = BTRFS_I(inode)->root;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	ret = copy_from_user(&remove_args, arg, sizeof(remove_args));
> +	if (ret)
> +		return ret;
> +
> +	if (!remove_args.qgroupid)
> +		return -EINVAL;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	trans = btrfs_join_transaction(root);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
> +
> +	check_in_use = !(remove_args.flags &
> +			 BTRFS_QGROUP_REMOVE_NO_CHECK_IN_USE);
> +	ret = btrfs_remove_qgroup(trans, fs_info, remove_args.qgroupid,
> +				  check_in_use);
> +
> +	err = btrfs_end_transaction(trans);
> +	if (err && !ret)
> +		ret = err;
> +
> +out:
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
> +
>   static long btrfs_ioctl_qgroup_create(struct file *file, void __user *arg)
>   {
>   	struct inode *inode = file_inode(file);
> @@ -5626,6 +5720,10 @@ long btrfs_ioctl(struct file *file, unsigned int
>   		return btrfs_ioctl_qgroup_assign(file, argp);
>   	case BTRFS_IOC_QGROUP_CREATE:
>   		return btrfs_ioctl_qgroup_create(file, argp);
> +	case BTRFS_IOC_QGROUP_CREATE_V2:
> +		return btrfs_ioctl_qgroup_create_v2(file, argp);
> +	case BTRFS_IOC_QGROUP_REMOVE_V2:
> +		return btrfs_ioctl_qgroup_remove_v2(file, argp);
>   	case BTRFS_IOC_QGROUP_LIMIT:
>   		return btrfs_ioctl_qgroup_limit(file, argp);
>   	case BTRFS_IOC_QUOTA_RESCAN:
> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
> index a456e53..0a6652d 100644
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -653,6 +653,25 @@ struct btrfs_ioctl_qgroup_create_args {
>   	__u64 create;
>   	__u64 qgroupid;
>   };
> +
> +/* Allow the user to delete qgroups even if there isn't a subvol with the id */
> +#define	BTRFS_QGROUP_CREATE_IGNORE_UNUSED		(1ULL << 0)
> +
> +struct btrfs_ioctl_qgroup_create_args_v2 {
> +	__u64 qgroupid;
> +	__u64 flags;
> +	__u64 reserved[16];
> +};

New APIs are much better than original one.
Splitting creation and deletion, so it won't cause any confusion, and 
with reserved members for us to extend it later.

The only concern is the flags. It's quite easy to confuse the 
BTRFS_QGROUP_CREATE_IGNORE_UNUSED and 
BTRFS_QGROUP_REMOVE_NO_CHECK_IN_USE, as they are the same value.

What about sharing the flags between create and remove args?



While with that IGNORE_UNUSED flags, why do we still need the mount 
option method?

IIRC, just introducing new APIs is good enough.

> +
> +/* Allow the user to delete qgroups even if they are referenced by a subvol */
> +#define	BTRFS_QGROUP_REMOVE_NO_CHECK_IN_USE		(1ULL << 0)
> +
> +struct btrfs_ioctl_qgroup_remove_args_v2 {
> +	__u64 qgroupid;
> +	__u64 flags;
> +	__u64 reserved[16];
> +};
> +
>   struct btrfs_ioctl_timespec {
>   	__u64 sec;
>   	__u32 nsec;
> @@ -818,5 +837,9 @@ enum btrfs_err_code {
>   				   struct btrfs_ioctl_feature_flags[3])
>   #define BTRFS_IOC_RM_DEV_V2 _IOW(BTRFS_IOCTL_MAGIC, 58, \
>   				   struct btrfs_ioctl_vol_args_v2)
> +#define BTRFS_IOC_QGROUP_CREATE_V2 _IOW(BTRFS_IOCTL_MAGIC, 59, \
> +			       struct btrfs_ioctl_qgroup_create_args_v2)
> +#define BTRFS_IOC_QGROUP_REMOVE_V2 _IOW(BTRFS_IOCTL_MAGIC, 60, \
> +			       struct btrfs_ioctl_qgroup_remove_args_v2)

IIRC we need acknowledgement from other developers to determine the 
ioctl number.

Thanks,
Qu

>   
>   #endif /* _UAPI_LINUX_BTRFS_H */
> 


