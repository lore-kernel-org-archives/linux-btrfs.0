Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820AbbA3Se4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Jan 2015 13:34:56 -0500
Date: Fri, 30 Jan 2015 19:34:55 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5 8/9] btrfs: Use sb_want_write() to protect label
 change.
Message-ID: <20150130183455.GR3641@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1422609654-19519-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1422609654-19519-9-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1422609654-19519-9-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 30, 2015 at 05:20:53PM +0800, Qu Wenruo wrote:
> Use the new vfs API sb_want_write() to do the write protection of the
> label change transaction.
> 
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---
> v4:
>   Newly introduced.
> v5:
>   Change to use sb_want_write().
> ---
>  fs/btrfs/sysfs.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index b2e7bb4..3218245 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -25,6 +25,7 @@
>  #include <linux/bug.h>
>  #include <linux/genhd.h>
>  #include <linux/debugfs.h>
> +#include <linux/mount.h>
>  
>  #include "ctree.h"
>  #include "disk-io.h"
> @@ -377,8 +378,6 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  	int ret;
>  	size_t p_len;
>  
> -	if (fs_info->sb->s_flags & MS_RDONLY)
> -		return -EROFS;
>  
>  	/*
>  	 * p_len is the len until the first occurrence of either
> @@ -389,9 +388,15 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  	if (p_len >= BTRFS_LABEL_SIZE)
>  		return -EINVAL;
>  
> +	ret = sb_want_write(fs_info->sb);
> +	if (ret)
> +		return ret;

Please move the check to the beginning of the function, where the
original MS_RDONLY check was.

> +
>  	trans = btrfs_start_transaction(root, 0);
> -	if (IS_ERR(trans))
> -		return PTR_ERR(trans);
> +	if (IS_ERR(trans)) {
> +		ret = PTR_ERR(trans);
> +		goto out;
> +	}
>  
>  	spin_lock(&root->fs_info->super_lock);
>  	memset(fs_info->super_copy->label, 0, BTRFS_LABEL_SIZE);
> @@ -399,9 +404,10 @@ static ssize_t btrfs_label_store(struct kobject *kobj,
>  	spin_unlock(&root->fs_info->super_lock);
>  	ret = btrfs_commit_transaction(trans, root);
>  
> +out:
> +	sb_drop_write(fs_info->sb);
>  	if (!ret)
>  		return len;
> -
>  	return ret;
>  }
>  BTRFS_ATTR_RW(label, btrfs_label_show, btrfs_label_store);
