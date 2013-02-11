Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758094Ab3BKRAg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 12:00:36 -0500
Message-ID: <5119238A.9080306@redhat.com>
Date: Mon, 11 Feb 2013 10:59:54 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: add cancellation points to defrag
References: <1360453086-10683-1-git-send-email-dsterba@suse.cz>
In-Reply-To: <1360453086-10683-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/9/13 5:38 PM, David Sterba wrote:
> The defrag operation can take very long, we want to have a way how to
> cancel it. The code checks for a pending signal at safe points in the
> defrag loops and returns EAGAIN. This means a user can press ^C after
> running 'btrfs fi defrag', woks for both defrag modes, files and root.
> 
> Returning from the command was instant in my light tests, but may take
> longer depending on the aging factor of the filesystem.

When __btrfs_run_defrag_inode() calls btrfs_defrag_file() and gets
-EAGAIN back due to the cancellation, will it reset the defrag->
counters and call btrfs_requeue_inode_defrag()?  Is that ok?

Should __btrfs_run_defrag_inode explicitly check for and handle
an actual error returned to it?

Thanks,
-Eric

> Signed-off-by: David Sterba <dsterba@suse.cz>
> ---
>  fs/btrfs/ctree.h       |    7 +++++++
>  fs/btrfs/ioctl.c       |    6 ++++++
>  fs/btrfs/transaction.c |    6 ++++++
>  3 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 547b7b0..4b41d7c 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3745,4 +3745,11 @@ static inline int is_fstree(u64 rootid)
>  		return 1;
>  	return 0;
>  }
> +
> +static inline int btrfs_defrag_cancelled(struct btrfs_fs_info *fs_info)
> +{
> +	return signal_pending(current);
> +}
> +
> +
>  #endif
> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
> index 338f259..78a5580 100644
> --- a/fs/btrfs/ioctl.c
> +++ b/fs/btrfs/ioctl.c
> @@ -1206,6 +1206,12 @@ int btrfs_defrag_file(struct inode *inode, struct file *file,
>  		if (!(inode->i_sb->s_flags & MS_ACTIVE))
>  			break;
>  
> +		if (btrfs_defrag_cancelled(root->fs_info)) {
> +			printk(KERN_DEBUG "btrfs: defrag_file cancelled\n");
> +			ret = -EAGAIN;
> +			break;
> +		}
> +
>  		if (!should_defrag_range(inode, (u64)i << PAGE_CACHE_SHIFT,
>  					 extent_thresh, &last_len, &skip,
>  					 &defrag_end, range->flags &
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index fc03aa6..2c509c4 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -986,6 +986,12 @@ int btrfs_defrag_root(struct btrfs_root *root, int cacheonly)
>  
>  		if (btrfs_fs_closing(root->fs_info) || ret != -EAGAIN)
>  			break;
> +
> +		if (btrfs_defrag_cancelled(root->fs_info)) {
> +			printk(KERN_DEBUG "btrfs: defrag_root cancelled\n");
> +			ret = -EAGAIN;
> +			break;
> +		}
>  	}
>  	root->defrag_running = 0;
>  	return ret;
> 

