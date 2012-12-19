Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab2LSOV6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Dec 2012 09:21:58 -0500
Date: Wed, 19 Dec 2012 15:21:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: [RFC PATCH V6 2/2] Btrfs: Add a new ioctl to change the label of
 a mounted file system
Message-ID: <20121219142156.GL14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50CFDD9F.2080706@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50CFDD9F.2080706@oracle.com>

On Tue, Dec 18, 2012 at 11:06:07AM +0800, Jeff Liu wrote:
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
> +	btrfs_end_transaction(trans, root);

If this fails, eg. with EIO, it will not be reported back to the user

        ret = btrfs_end_transaction(trans, root);

should fix it.

> +
> +out_unlock:
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +	mnt_drop_write_file(file);
> +	return ret;
> +}
