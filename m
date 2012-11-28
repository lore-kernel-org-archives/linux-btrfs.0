Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:10978 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751272Ab2K1DEq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 22:04:46 -0500
Message-ID: <50B57F63.4050205@cn.fujitsu.com>
Date: Wed, 28 Nov 2012 11:05:07 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Anand jain <Anand.Jain@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3] Btrfs: add label to snapshot and subvol
References: <1351766770-4044-1-git-send-email-Anand.Jain@oracle.com> <1354040960-31522-1-git-send-email-Anand.Jain@oracle.com> <1354040960-31522-2-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <1354040960-31522-2-git-send-email-Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 28 Nov 2012 02:29:17 +0800, Anand jain wrote:
>  /*
> @@ -2441,6 +2443,14 @@ static inline bool btrfs_root_readonly(struct btrfs_root *root)
>  {
>  	return (root->root_item.flags & cpu_to_le64(BTRFS_ROOT_SUBVOL_RDONLY)) != 0;
>  }
> +static inline char * btrfs_root_label(struct btrfs_root_item *root_item)
> +{
> +	return (root_item->label);
> +}
> +static inline void btrfs_root_set_label(struct btrfs_root_item *root_item, char *val)
> +{
> +	memcpy(root_item->label, val, BTRFS_SUBVOL_LABEL_SIZE);
> +}
>  
>  /* struct btrfs_root_backup */
>  BTRFS_SETGET_STACK_FUNCS(backup_tree_root, struct btrfs_root_backup,
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index e58bd9d..f0b3d9d 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3725,6 +3725,57 @@ static int btrfs_ioctl_set_label(struct btrfs_root *root, void __user *arg)
>  	return 0;
>  }
>  
> +static int btrfs_ioctl_subvol_getlabel(struct btrfs_root *root,
> +						void __user *arg)
> +{
> +	char *label;
> +
> +	label = btrfs_root_label(&root->root_item);
> +	if (copy_to_user(arg, label, BTRFS_SUBVOL_LABEL_SIZE))
> +		return -EFAULT;

we also need lock here.

> +	return 0;
> +}
> +
> +static int btrfs_ioctl_subvol_setlabel(struct file *file,
> +						void __user *arg)
> +{
> +	char label[BTRFS_SUBVOL_LABEL_SIZE+1];
> +	struct btrfs_trans_handle *trans;
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	int ret;
> +
> +	if (btrfs_root_readonly(root))
> +		return -EROFS;
> +
> +	if (!inode_owner_or_capable(inode))
> +		return -EACCES;
> +
> +	ret = mnt_want_write_file(file);
> +	if (ret)
> +		return ret;
> +
> +	if (copy_from_user(label, arg, BTRFS_SUBVOL_LABEL_SIZE)) {
> +		ret = -EFAULT;
> +		goto out;
> +	}
> +
> +	mutex_lock(&inode->i_mutex);

we should use a lock which belongs to the root not inode.

Thanks
Miao
