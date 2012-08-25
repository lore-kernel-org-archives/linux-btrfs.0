Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:16444 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab2HYCci (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Aug 2012 22:32:38 -0400
Message-ID: <5038394B.9080106@oracle.com>
Date: Sat, 25 Aug 2012 10:32:43 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix deadlock with freeze and sync V2
References: <1345834383-2172-1-git-send-email-jbacik@fusionio.com>
In-Reply-To: <1345834383-2172-1-git-send-email-jbacik@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2012 02:53 AM, Josef Bacik wrote:
> We can deadlock with freeze right now because we unconditionally start a
> transaction in our ->sync_fs() call.  To fix this just check and see if we
> have a running transaction to commit.  This saves us from the deadlock
> because at this point we'll have the umount sem for the sb so we're safe
> from freezes coming in after we've done our check.  With this patch the
> freeze xfstests no longer deadlocks.  Thanks,
> 

Actually I have a same patch pending to send...

Anyway, I'm happy with the bug has been fixed.

Reviewed-by: Liu Bo <bo.li.liu@oracle.com>

> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---
> V1->V2: got a little overzealous and cleaned up the ret thing without actually
> removing the now unused ret variable.
> 
>  fs/btrfs/super.c |   13 +++++++++----
>  1 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index 7b65fe8..83d6f9f 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -838,7 +838,6 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  	struct btrfs_trans_handle *trans;
>  	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
>  	struct btrfs_root *root = fs_info->tree_root;
> -	int ret;
>  
>  	trace_btrfs_sync_fs(wait);
>  
> @@ -849,11 +848,17 @@ int btrfs_sync_fs(struct super_block *sb, int wait)
>  
>  	btrfs_wait_ordered_extents(root, 0, 0);
>  
> -	trans = btrfs_start_transaction(root, 0);
> +	spin_lock(&fs_info->trans_lock);
> +	if (!fs_info->running_transaction) {
> +		spin_unlock(&fs_info->trans_lock);
> +		return 0;
> +	}
> +	spin_unlock(&fs_info->trans_lock);
> +
> +	trans = btrfs_join_transaction(root);
>  	if (IS_ERR(trans))
>  		return PTR_ERR(trans);
> -	ret = btrfs_commit_transaction(trans, root);
> -	return ret;
> +	return btrfs_commit_transaction(trans, root);
>  }
>  
>  static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
> 

