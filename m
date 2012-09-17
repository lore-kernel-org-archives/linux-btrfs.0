Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:34371 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab2IQQbo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 12:31:44 -0400
Date: Mon, 17 Sep 2012 12:31:41 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix double decrease of the writer counter
Message-ID: <20120917163141.GB3143@localhost.localdomain>
References: <5056C473.50709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5056C473.50709@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:34:27AM -0600, Miao Xie wrote:
> In __btrfs_end_transaction(), we have invoked sb_end_intwrite(), but if we
> need run btrfs_commit_transaction(), we will decrease the writer counter
> for two times because btrfs_commit_transaction() also invokes sb_end_intwrite().
> Fix it.
> 

Already fixed in btrfs-next.  Thanks,

Josef
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/transaction.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
> index 27c2600..3134fdc 100644
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -551,8 +551,6 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  	btrfs_trans_release_metadata(trans, root);
>  	trans->block_rsv = NULL;
>  
> -	sb_end_intwrite(root->fs_info->sb);
> -
>  	if (lock && !atomic_read(&root->fs_info->open_ioctl_trans) &&
>  	    should_end_transaction(trans, root)) {
>  		trans->transaction->blocked = 1;
> @@ -573,6 +571,8 @@ static int __btrfs_end_transaction(struct btrfs_trans_handle *trans,
>  		}
>  	}
>  
> +	sb_end_intwrite(root->fs_info->sb);
> +
>  	WARN_ON(cur_trans != info->running_transaction);
>  	WARN_ON(atomic_read(&cur_trans->num_writers) < 1);
>  	atomic_dec(&cur_trans->num_writers);
> -- 
> 1.7.6.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
