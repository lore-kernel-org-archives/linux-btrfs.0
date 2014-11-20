Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47004 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750973AbaKTK5K (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 05:57:10 -0500
Message-ID: <546DC968.1020900@cn.fujitsu.com>
Date: Thu, 20 Nov 2014 18:58:48 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>
CC: <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: make sure we wait on logged extents when fsycning
 two subvols
References: <1415287194-1967-1-git-send-email-jbacik@fb.com>
In-Reply-To: <1415287194-1967-1-git-send-email-jbacik@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 6 Nov 2014 10:19:54 -0500, Josef Bacik wrote:
> If we have two fsync()'s race on different subvols one will do all of its work
> to get into the log_tree, wait on it's outstanding IO, and then allow the
> log_tree to finish it's commit.  The problem is we were just free'ing that
> subvols logged extents instead of waiting on them, so whoever lost the race
> wouldn't really have their data on disk.  Fix this by waiting properly instead
> of freeing the logged extents.  Thanks,
> 
> cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <jbacik@fb.com>
> ---
>  fs/btrfs/tree-log.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 2d0fa43..70f99b1 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -2600,9 +2600,9 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
>  	if (atomic_read(&log_root_tree->log_commit[index2])) {
>  		blk_finish_plug(&plug);
>  		btrfs_wait_marked_extents(log, &log->dirty_log_pages, mark);
> +		btrfs_wait_logged_extents(log, log_transid);

Why not add this log root into a list of log root tree, and then the committer
wait all ordered extents in each log root which is added in that list? By this
way, we can let the committer do some work during the data of ordered extents is 
being transferred to the disk.

Thanks
Miao

>  		wait_log_commit(trans, log_root_tree,
>  				root_log_ctx.log_transid);
> -		btrfs_free_logged_extents(log, log_transid);
>  		mutex_unlock(&log_root_tree->log_mutex);
>  		ret = root_log_ctx.log_ret;
>  		goto out;
> 

