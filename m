Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21063 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbbHZCGY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 22:06:24 -0400
Date: Wed, 26 Aug 2015 10:06:10 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: deal with error on secondary log properly
Message-ID: <20150826020609.GB5614@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1440522583-32120-1-git-send-email-jbacik@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1440522583-32120-1-git-send-email-jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 25, 2015 at 01:09:43PM -0400, Josef Bacik wrote:
> If we have an fsync at the same time in two seperate subvolumes we could end up
> with the tree log pointing at invalid blocks.  We need to notice if our writeout

Mind to share more details of the problem?

Thanks,

-liubo
> failed in anyway, if it did then we need to do a full transaction commit and
> return an error on the subvolume that gave us the io error.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/file.c     | 4 ++++
>  fs/btrfs/tree-log.c | 4 ++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index b823fac..c8f49f5 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -2054,6 +2054,10 @@ int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
>  			if (!ret) {
>  				ret = btrfs_end_transaction(trans, root);
>  				goto out;
> +			} else if (ctx.io_err) {
> +				btrfs_end_transaction(trans, root);
> +				ret = ctx.io_err;
> +				goto out;
>  			}
>  		}
>  		if (!full_sync) {
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 1bbaace..b4f15f5 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2857,6 +2857,10 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  		ret = btrfs_wait_marked_extents(log, &log->dirty_log_pages,
>  						mark);
>  		btrfs_wait_logged_extents(trans, log, log_transid);
> +		if (ret) {
> +			btrfs_set_log_full_commit(root->fs_info, trans);
> +			ctx->io_err = ret;
> +		}
>  		wait_log_commit(log_root_tree,
>  				root_log_ctx.log_transid);
>  		mutex_unlock(&log_root_tree->log_mutex);
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
