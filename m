Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55666 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752855Ab3DPKwb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 06:52:31 -0400
Date: Tue, 16 Apr 2013 12:52:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 2/3] Btrfs: rescan for qgroups
Message-ID: <20130416105229.GH18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366101920-13083-1-git-send-email-list.btrfs@jan-o-sch.net>
 <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366101920-13083-3-git-send-email-list.btrfs@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 10:45:19AM +0200, Jan Schmidt wrote:
> +static long btrfs_ioctl_quota_rescan_status(struct file *file, void __user *arg)
> +{
> +	struct btrfs_root *root = BTRFS_I(fdentry(file)->d_inode)->root;
> +	struct btrfs_ioctl_quota_rescan_args *qsa;
> +	int ret = 0;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	qsa = kzalloc(sizeof(*qsa), GFP_NOFS);

The reserved field increased the size of qsa to 64 bytes, thinking about
it again, an early ENOMEM is a good indicator that the system is unable
to get memory so starting a bigger operation does not make much sense
anyway. Keep it as it is.

> +	if (!qsa)
> +		return -ENOMEM;
> +
> +	if (root->fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_RESCAN) {
> +		qsa->flags = 1;
> +		qsa->progress = root->fs_info->qgroup_rescan_progress.objectid;
> +	}
> +
> +	if (copy_to_user(arg, qsa, sizeof(*qsa)))
> +		ret = -EFAULT;
> +
> +	kfree(qsa);
> +	return ret;
> +}
> +
> --- a/include/uapi/linux/btrfs.h
> +++ b/include/uapi/linux/btrfs.h
> @@ -376,12 +376,18 @@ struct btrfs_ioctl_get_dev_stats {
>  
>  #define BTRFS_QUOTA_CTL_ENABLE	1
>  #define BTRFS_QUOTA_CTL_DISABLE	2
> -#define BTRFS_QUOTA_CTL_RESCAN	3
> +#define BTRFS_QUOTA_CTL_RESCAN__NOTUSED	3

Looks ok.

david
