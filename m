Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58998 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498Ab2L1Lvf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Dec 2012 06:51:35 -0500
Date: Fri, 28 Dec 2012 12:51:32 +0100
From: David Sterba <dsterba@suse.cz>
To: Jeff Liu <jeff.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, anand.jain@oracle.com, miaox@cn.fujitsu.com,
        Goffredo Baroncelli <kreijack@gmail.com>, dsterba@suse.cz
Subject: Re: [RFC PATCH v8 1/2] Btrfs: Add a new ioctl to get the label of a
 mounted file system
Message-ID: <20121228115132.GU14116@twin.jikos.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50DD152C.4050701@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <50DD152C.4050701@oracle.com>

On Fri, Dec 28, 2012 at 11:42:36AM +0800, Jeff Liu wrote:
> +static int btrfs_ioctl_get_fslabel(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	const char *label = root->fs_info->super_copy->label;
> +	size_t len = strnlen(label, BTRFS_LABEL_SIZE);
> +	int ret;
> +
> +	if (len == BTRFS_LABEL_SIZE) {
> +		len--;
> +		WARN(1, "btrfs: device label is not zero terminated, "
> +			"it will be truncated to %zu bytes.\n", len);

This will print a stacktrace, it's not needed in this context, the
warning is enough.

		printk(KERN_WARNING "...");

> +	}
> +
> +	mutex_lock(&root->fs_info->volume_mutex);
> +	ret = copy_to_user(arg, label, len);
> +	mutex_unlock(&root->fs_info->volume_mutex);
> +
> +	return ret ? -EFAULT : 0;
> +}
