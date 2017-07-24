Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33448 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751610AbdGXMnv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 08:43:51 -0400
Date: Mon, 24 Jul 2017 14:42:29 +0200
From: David Sterba <dsterba@suse.cz>
To: josef@toxicpanda.com
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 1/3] btrfs: don't allow trans ioctl on a directory
Message-ID: <20170724124229.GQ2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1500658149-20410-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1500658149-20410-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 21, 2017 at 01:29:07PM -0400, josef@toxicpanda.com wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> We need to use file->private_data for readdir on directories, so just
> don't allow user space transactions on directories.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index bedeec6..ddb3811 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -3968,6 +3968,9 @@ static long btrfs_ioctl_trans_start(struct file *file)
>  	struct btrfs_trans_handle *trans;
>  	int ret;
>  
> +	if (S_ISDIR(inode->i_mode))
> +		return -EINVAL;

You can't do this, starting a transaction on a directory needs to work.
The most natural way to run the ioctl is on the mount point.

The file private data would need to be able to hold multipe values, so
you can add

struct btrfs_inode {
	...
	struct priv_data {
		void *for_readdir;
		void *for_tranc_ioctl;
	};
	...
};

then set file->file_private = &btrfs_inode->priv_data; and update all
uses to check for the embedded pointers.

> +
>  	ret = -EPERM;
>  	if (!capable(CAP_SYS_ADMIN))
>  		goto out;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
